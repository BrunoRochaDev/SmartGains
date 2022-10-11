import cv2 # OpenCV, computer vision
import mediapipe as mp # MediaPipe, pose estimation
import math # For angle calculations
from PIL import Image # For creating gifs

class Framework:

    FPS = 10 # Frames per second

    SET_gesture_DETECT = FPS # The number of consecutive frames of set gesture for it to register (1s)

    FRAME_BUFFER_SIZE = 10 * FPS # The max number of frames the buffers holds (10 seconds)

    def __init__(self):
        self.pose = mp.solutions.pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5)

        self.rep_count = 0

        # Buffer for storing frames pertaining to a rep
        self.frame_count = 0
        self.frame_buffer = []
        self.frames_storage = {} # Storage of the frames for every rep. Gif conversion happens when the set is done

        self.started_set = False
        self.set_gesture_count = 0

        self.gesture_timer_max = 5 * self.FPS # The number of frames until the gesture takes effect (5s)
        self.gesture_timer_state = False
        self.gesture_timer_count = 0

    def set_exercise(self, exercise):
        """Selects what exercise should be evaluated."""
        exercise.framework = self
        self.exercise = exercise

    def process_frame(self, frame):
        """Processes frame (actual cue analysis is delegated to exercise object)."""

        # Recolor image
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB) #(Convert bgr to rgb)
        image.flags.writeable = False #Saves memory

        # Make detection
        results = self.pose.process(image)

        try:
            # Sometimes no landmarks are detected. So we put this inside a try catch
            landmarks = results.pose_landmarks.landmark;

            # Stores the frame in the buffer
            self.store_frame(image, landmarks)

            # Checks for hand gesture
            self.set_gesture(landmarks) 

            # Set has started
            if self.started_set:
                # Exercise object analyzes the frame
                if self.exercise != None: 
                    self.exercise.analyze_frame(self.frame_count, results.pose_landmarks.landmark) 
                else:
                    print('NO EXERCISE SELECTED!')
        except Exception as e:
            print("Er",e)
            pass

        # Recolor back to GBR2
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

        # Draws landmarks on top of frame
        mp.solutions.drawing_utils.draw_landmarks(image, results.pose_landmarks, mp.solutions.pose.POSE_CONNECTIONS)  

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
            right_elbow = [landmarks[mp.solutions.pose.PoseLandmark.RIGHT_ELBOW.value].x,landmarks[mp.solutions.pose.PoseLandmark.RIGHT_ELBOW.value].y]
            right_wrist = [landmarks[mp.solutions.pose.PoseLandmark.RIGHT_WRIST.value].x,landmarks[mp.solutions.pose.PoseLandmark.RIGHT_WRIST.value].y]

            # Get left arm positions
            left_elbow = [landmarks[mp.solutions.pose.PoseLandmark.LEFT_ELBOW.value].x,landmarks[mp.solutions.pose.PoseLandmark.LEFT_ELBOW.value].y]
            left_wrist = [landmarks[mp.solutions.pose.PoseLandmark.LEFT_WRIST.value].x,landmarks[mp.solutions.pose.PoseLandmark.LEFT_WRIST.value].y]

            # The wrists should be near the chest
            # The head width will be used for padding
            padding = abs(landmarks[mp.solutions.pose.PoseLandmark.LEFT_EAR.value].x - landmarks[mp.solutions.pose.PoseLandmark.RIGHT_EAR.value].x)
            max_height = landmarks[mp.solutions.pose.PoseLandmark.RIGHT_SHOULDER.value].y - padding
            min_height = landmarks[mp.solutions.pose.PoseLandmark.RIGHT_SHOULDER.value].y + padding * 4

            #  Wrists should be between heights
            if left_wrist[1] < max_height or left_wrist[1] > min_height or right_wrist[1] < max_height or right_wrist[1] > min_height:
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
                    #Start timer!
                    self.gesture_timer_state = True
                    self.gesture_timer_count = 0
                    self.set_gesture_count = 0

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

    def store_frame(self, frame, landmarks):
        """Stores the frame in the buffer. If buffer is already full, removes the older frame to make room"""

        # Converts frame to a pillow image
        PIL_image = Image.fromarray(frame)

        self.frame_count += 1 # Frame count starts at 1

        # Buffer is full. Removes oldest frame to make room
        if len(self.frame_buffer) == self.FRAME_BUFFER_SIZE:
            self.frame_buffer = self.frame_buffer[1:]

        # Appends the frame and count
        self.frame_buffer.append([self.frame_count, PIL_image, landmarks])

    def add_feedback(self, feedback_id : str, feedback_intensity : float):
        """Adds a feedback to the current repetition."""
        pass

    def repetition_done(self, start_frame : int):
        """Finalizes a repetition and stores all the info pertaining to it."""

        self.rep_count += 1 
        print(f"[Framework] rep done. {self.rep_count} reps so far!")

        # Select images from starting frame
        frames = []
        for count, frame, landmarks in self.frame_buffer:
            # Select all frames after the starting frame
            if count >= start_frame:
                frames.append((frame, landmarks))

        # Crop images
        frames = self.crop_images(frames)

        self.frame_buffer.clear() # Clears buffer
        self.frames_storage[self.rep_count] = frames # Store the cropped frames for gif conversion at the end of set

    def crop_images(self, frames) -> list:
        """Crop the frames of a repetition so that only the user is visible (removes empty space)."""

        # Get a frame's bounds
        def get_bounds(landmarks) -> tuple:
            upper_left = [landmarks[mp.solutions.pose.PoseLandmark.RIGHT_SHOULDER.value].x,landmarks[mp.solutions.pose.PoseLandmark.RIGHT_EAR.value].y] # Shoulder X, Ear Y
            lower_right = [landmarks[mp.solutions.pose.PoseLandmark.LEFT_SHOULDER.value].x,landmarks[mp.solutions.pose.PoseLandmark.LEFT_ANKLE.value].y] # Shoulder X, Ear Y
            # The head width will be used for padding
            padding = abs(landmarks[mp.solutions.pose.PoseLandmark.LEFT_EAR.value].x - landmarks[mp.solutions.pose.PoseLandmark.RIGHT_EAR.value].x)

            # Adds the padding
            if upper_left[0] < lower_right[0]: # If the left shoulder is to the left of the right shoulder...
                upper_left = [upper_left[0] - padding*3, upper_left[1] - padding*3]
                lower_right = [lower_right[0] + padding*3, lower_right[1] + padding]
            else:
                upper_left = [upper_left[0] + padding*3, upper_left[1] - padding*3]
                lower_right = [lower_right[0] - padding*3, lower_right[1] + padding]

            def clamp(n, smallest, largest):
                return max(smallest, min(n, largest))

            #Clam the values
            upper_left = [clamp(upper_left[0], 0, 1), clamp(upper_left[1], 0, 1)]
            lower_right = [clamp(lower_right[0],0,1), clamp(lower_right[1],0,1)]

            return upper_left, lower_right

        # Go through each frame and update the bounds
        upper_left = [1,0]
        lower_right = [0,1]
        images = []
        for frame in frames:
            landmarks = frame[1]
            images.append(frame[0])

            # Get the bounds of the frame
            ul, lr = get_bounds(landmarks)

            # Updates the bounds if needed
            if upper_left[0] > ul[0]: # Left
                upper_left[0] = ul[0]
            if upper_left[1] < ul[1]: # Up
                upper_left[1] = ul[1]
            if lower_right[0] < lr[0]: # Right
                lower_right[0] = lr[0]
            if lower_right[1] > lr[1]: # Down
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

        # Do noyhing if no reps were done
        if self.rep_count == 0:
            return

        # Generate gifs
        for i in range(1, self.rep_count):
            # Generates the gif
            frames = self.frames_storage[i]
            frames[0].save(f'RepetitionGifs/rep_{i}.gif',
                save_all=True, append_images=frames[1:], optimize=False, duration=40, loop=0)