import cv2 # OpenCV, computer vision
import mediapipe as mp # MediaPipe, pose estimation
import math # For angle calculations
from PIL import Image, ImageDraw # For creating gifs
from protocol import * # For sending messages
import base64 # For encoding gifs

mp_pose = mp.solutions.pose

from curl import Curl

class Framework:

    FPS = 2 # Frames per second

    SET_gesture_DETECT = FPS # The number of consecutive frames of set gesture for it to register (1s)

    FRAME_BUFFER_SIZE = 10 * FPS # The max number of frames the buffers holds (10 seconds)

    CORRECT_COLOR = 'green'
    WRONG_COLOR = 'red'
    TRACE_COLOR = 'white'
    LINE_WIDTH = 3
    KNOB_RADIUS = 3

    def __init__(self):
        self.pose = mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5)

        # Should be set by the main.py
        self.message_callback= None
        self.exercise = None

        # Set variables
        self.clean()

    def clean(self):
        """Reset everything from scratch."""
        self.exercise = None

        self.rep_count = 0

        # For sending to the frontend
        self.last_in_frame = True

        # Buffer for storing frames pertaining to a rep
        self.frame_count = 0
        self.frame_buffer = []
        self.frames_storage = {} # Storage of the frames for every rep. Gif conversion happens when the set is done

        self.started_set = False
        self.set_gesture_count = 0

        self.gesture_timer_max = 5 * self.FPS # The number of frames until the gesture takes effect (5s)
        self.gesture_timer_state = False
        self.gesture_timer_count = 0

        # Buffer for the feedback
        self.last_feedback = []

    def set_exercise(self, exercise):
        """Selects what exercise should be evaluated."""
        exercise.framework = self
        self.exercise = exercise
        print('Exercise module updated.')

    def process_frame(self, frame):
        """Processes frame (actual cue analysis is delegated to exercise object)."""
        # Do nothing if there's no exercise module
        if self.exercise == None:
            print("No exercise module selected.")
            return

        # Recolor image
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB) #(Convert bgr to rgb)
        image.flags.writeable = False #Saves memory

        # Make detection
        results = self.pose.process(image)

        try:
            # Sometimes no landmarks are detected. So we put this inside a try catch
            landmarks = results.pose_landmarks.landmark

            # Checks for hand gesture
            self.set_gesture(landmarks) 

            # Set has started
            if self.started_set:
                # Exercise object analyzes the frame
                draw_info = self.exercise.analyze_frame(self.frame_count, results.pose_landmarks.landmark) 
                
                # If draw_info is null, then the exercise object could not find all the necessary landmarks 
                if draw_info == None:
                    # Update last in frame
                    if self.last_in_frame:
                        self.send_message(InFrame(False))
                        self.last_in_frame = False
                else:
                    # Stores the frame in the buffer
                    self.store_frame(image, landmarks, draw_info)

                    # Update last in frame
                    if self.last_in_frame == False:
                        self.send_message(InFrame(True))
                        self.last_in_frame = True

        except Exception as e:
            print("Er",e)
            pass

        # Recolor back to GBR2
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

        # Draws landmarks on top of frame
        mp.solutions.drawing_utils.draw_landmarks(image, results.pose_landmarks, mp_pose.POSE_CONNECTIONS)  

        # Displays the frame for debugging
        cv2.imshow('Mediapipe Feed', image)

    def set_gesture(self, landmarks):
        """Starts/ends set if forearms cross"""

        # If the timer has already started...
        if self.gesture_timer_state:
            if self.started_set or self.gesture_timer_count >= self.gesture_timer_max:
                self.gesture_timer_state = False
                self.gesture_timer_count = 0
                self.started_set = not self.started_set
                print("SET STARTED!" if self.started_set else "SET ENDED!")

                # Trigger end set event
                if not self.started_set:
                    self.set_ended()

            self.gesture_timer_count += 1
            return

        try:
            # Get right arm positions
            right_elbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y]
            right_wrist = [landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y]

            # Get left arm positions
            left_elbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y]
            left_wrist = [landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y]

            # Get shoulder positions
            left_shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y]
            right_shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y]

            # The wrists should be near the opposite shoulder
            # The head width will be used for padding
            padding = abs(landmarks[mp_pose.PoseLandmark.LEFT_EAR.value].x - landmarks[mp_pose.PoseLandmark.RIGHT_EAR.value].x)

            def get_distance(p, q):
                """ 
                Return euclidean distance between points p and q
                assuming both to have the same number of dimensions
                """
                # sum of squared difference between coordinates
                s_sq_difference = 0
                for p_i,q_i in zip(p,q):
                    s_sq_difference += (p_i - q_i)**2
                
                # take sq root of sum of squared difference
                distance = s_sq_difference**0.5
                return distance

            #  Wrists should be near the opposite shoulder
            if get_distance(left_wrist, right_shoulder) > padding * 3 or get_distance(right_wrist, left_shoulder) > padding * 3:
                return False

            # Check for intersection
            res = self.is_crossed(right_elbow, right_wrist, left_elbow, left_wrist)

            # If the forearms intersect...
            if res: 
                # Increase the number of frames with forearms crossed
                self.set_gesture_count += 1
            # If doesn't intersect...
            else: 
                # If the gesture is done and the detection timer is up, the gesture is computed
                if self.set_gesture_count >= self.SET_gesture_DETECT:
                    # Start timer!
                    self.gesture_timer_state = True
                    self.gesture_timer_count = 0
                    self.set_gesture_count = 0

                    # Inform the frontend
                    self.send_message(GestureDetected())

                    #Print the timer duration
                    if not self.started_set:
                        print(f'Starting {self.gesture_timer_max / self.FPS}s timer...')
                else:
                    # Restart count
                    self.gesture_timer_count = 0

        except Exception as e:
            print('Exception: ', e)
            pass

    def is_crossed(self, R1, R2, L1, L2):
        """Checks if the forearms cross"""

        # Helper function for detecting intersection
        def ccw(A,B,C):
            return (C[1]-A[1]) * (B[0]-A[0]) > (B[1]-A[1]) * (C[0]-A[0])

        # If the forearms don't intersect, then they are not crossed.
        if not (ccw(R1,L1,L2) != ccw(R2,L1,L2) and ccw(R1,R2,L1) != ccw(R1,R2,L2)):
            return False

        # However, the angle between the forearms should be close to 90º

        # Helper dot product function
        def dot(vA, vB):
            return vA[0]*vB[0]+vA[1]*vB[1]

        # Gets the difference
        Rdiff = [(R1[0]-R2[0]), (R1[1]-R2[1])]
        Ldiff = [(L1[0]-L2[0]), (L1[1]-L2[1])]

        # Get dot prod
        dot_prod = dot(Rdiff, Ldiff)

        # Get magnitudes
        magA = dot(Rdiff, Rdiff)**0.5
        magB = dot(Ldiff, Ldiff)**0.5

        # Get cosine value
        cos_ = dot_prod/magA/magB

        # Get angle in radians and then convert to degrees
        angle = math.acos(dot_prod/magB/magA)
        ang_deg = math.degrees(angle)%360

        # gesture is only detected if the angle is within 20 degrees of 90º
        return 70 < ang_deg < 110

    def store_frame(self, PIL_image, landmarks, draw_info):
        """Stores the frame in the buffer. If buffer is already full, removes the older frame to make room"""

        #Frame is already PIL_image because it's converted by draw

        self.frame_count += 1 # Frame count starts at 1

        # Buffer is full. Removes oldest frame to make room
        if len(self.frame_buffer) == self.FRAME_BUFFER_SIZE:
            self.frame_buffer = self.frame_buffer[1:]

        # Appends the frame and count
        self.frame_buffer.append([self.frame_count, PIL_image, landmarks, draw_info])

    def add_feedback(self, feedback_id : str):
        """Adds a feedback to the current repetition."""
        self.last_feedback.append(feedback_id)

    def repetition_done(self, start_frame : int):
        """Finalizes a repetition and stores all the info pertaining to it."""

        self.rep_count += 1 
        print(f"[Framework] rep done. {self.rep_count} reps so far!")

        # Send the data to the frontend
        self.send_message(RepDone(self.rep_count, self.last_feedback))
        self.last_feedback.clear()

        # Select images from starting frame
        frames_crop = []
        for count, frame, landmarks, draw_info in self.frame_buffer:
            # Select all frames after the starting frame
            if count >= start_frame:
                # Draws on top of the frame as per the exercise object guidelines
                img = self.draw_frame(frame, draw_info) # Also convert to PIL image
                frames_crop.append((img, landmarks))

        # Clears buffer
        self.frame_buffer.clear() 

        # Crop images
        frames_crop = self.crop_images(frames_crop)

        self.frames_storage[self.rep_count] = frames_crop # Store the cropped frames for gif conversion at the end of set

    def draw_frame(self, frame, draw_info):
        """Draws the landmarks on top of the frame. Also converts to PIL"""

        # Converts frame to a pillow image
        PIL_image = Image.fromarray(frame)
        
        # In case draw object is null
        if draw_info == None:
            return PIL_image

        # Creates a drawer object
        drawer = ImageDraw.Draw(PIL_image)
        width, height = PIL_image.size

        # Draws each segment
        for segment in draw_info.segments:
            start_pos = draw_info.points[segment[0]]
            end_pos = draw_info.points[segment[1]]
            correct = segment[2]

            # Converts to pixel coords
            start_x = start_pos[0] * width
            start_y = start_pos[1] * height
            end_x = end_pos[0] * width
            end_y = end_pos[1] * height

            # Draws the line
            drawer.line([start_x, start_y, end_x, end_y], fill=self.CORRECT_COLOR if correct else self.WRONG_COLOR, width=self.LINE_WIDTH)

        # Draw traces
        for point in draw_info.traces[:-1]:
            # Draws the line
            drawer.line([point[0][1], point[0][1], point[1][0], point[1][1]], fill=self.TRACE_COLOR, width=self.LINE_WIDTH)

        # Draws a knob at each point
        for point in draw_info.points.values():
            # Converts to pixel coords
            x = point[0] * width
            y = point[1] * height
            drawer.ellipse([x-self.KNOB_RADIUS,y-self.KNOB_RADIUS,x+self.KNOB_RADIUS,y+self.KNOB_RADIUS], outline='white',fill=self.CORRECT_COLOR, width=1)

        return PIL_image # Returns pill image

    def crop_images(self, frames) -> list:
        """Crop the frames of a repetition so that only the user is visible (removes empty space)."""

        # Go through each frame and update the bounds
        upper_left = [1,0]
        lower_right = [0,1]
        images = []
        for frame in frames:
            landmarks = frame[1]
            images.append(frame[0])

            # Get the bounds of the frame
            ul, lr = self.exercise.get_bounds(landmarks)

            # Updates the bounds if needed
            if upper_left[0] > ul[0]: # Left
                upper_left[0] = ul[0]
            if upper_left[1] > ul[1]: # Up
                upper_left[1] = ul[1]
            if lower_right[0] < lr[0]: # Right
                lower_right[0] = lr[0]
            if lower_right[1] < lr[1]: # Down
                lower_right[1] = lr[1]

        # Convert coordinates to actual pixel coords
        width, height = images[0].size
        upper_left = [upper_left[0] * width, upper_left[1] * height]
        lower_right = [lower_right[0] * width, lower_right[1] * height]

        # Crop images
        for i in range(len(images)):
            images[i] = (images[i].crop((upper_left[0], upper_left[1], lower_right[0], lower_right[1])))

        return images

    def set_ended(self):
        """Generate gifs and process data"""

        # Do nothing if no reps were done
        if self.rep_count == 0:
            return

        # Generate gifs
        for count in range(1, self.rep_count+1):
            # Generates the gif
            frames = self.frames_storage[count]
            frames[0].save(f'RepetitionGifs/rep_{count}.gif',
                save_all=True, append_images=frames[1:], optimize=False, duration=40, loop=0)

            # Sends the encoded gif to the frontend
            with open(f'RepetitionGifs/rep_{count}.gif', "rb") as image_file:
                encoded_string = base64.b64encode(image_file.read()).decode('utf-8')
                self.send_message(Gif(count, encoded_string))

        self.send_message(SetState("false"))

        # Reset
        self.clean()

    def send_message(self, message):
        """Send message to the frontend"""
        if self.message_callback == None:
            print("No callback function.")
            return

        print(f"[API] Sending a {message.type} message...")
        self.message_callback(message)