from draw import DrawInfo

import numpy as np
import mediapipe as mp

mp_pose = mp.solutions.pose

class Curl:
    """Bicep curl exercise module."""

    def __init__(self): 

        # Framework Refernece given by the  framework itself
        self.framework = None

        # Count of the current frame since the exercise started
        self.start_frame = 0

        # Tags for the counting logic
        self.hip_fail = False
        self.knee_fail = False
        self.perfect_tag = False # Rep was perfect (in the range of motion requirement)
        self.completed = False # Rep was done 
        self.stage = "idle" # "up" or "down" keeps track of the current movement  

        # Cues related values 
        self.minimum_angle = 100  # consider start of the rep 
        self.best_angle = 50 # best rep angle (good range of motion)
        self.start_angle = 150 # less then this is not a good rep (bad range of motion)  
        self.min_vizibility = 0.7

        # Debugging Counter of reps
        self.counter = 0

    def analyze_frame(self, frame_count, landmarks):
        """ | Analyzes frame | calls method of framework when rep is finished with the rep information"""

        # Sync frame count
        self.frame_count = frame_count
        
        if landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].z< landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].z:         
            # Get right key positions 
            shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y]
            elbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y]
            wrist = [landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y]
            hip = [landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y]
            knee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].y]
            heel = [landmarks[mp_pose.PoseLandmark.RIGHT_HEEL.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_HEEL.value].y]

            if landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].visibility < self.min_vizibility:
                return None
            if landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].visibility < self.min_vizibility:
                return None
            if landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].visibility < self.min_vizibility:
                return None
            if landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].visibility < self.min_vizibility:
                return None
            if landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].visibility < self.min_vizibility:
                return None    
            if landmarks[mp_pose.PoseLandmark.RIGHT_HEEL.value].visibility < self.min_vizibility:
                return None    
        else:

            # Get left key positions 
            shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y]
            elbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y]
            wrist = [landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y]
            hip = [landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x,landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y]
            knee = [landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].y]
            heel = [landmarks[mp_pose.PoseLandmark.LEFT_HEEL.value].x,landmarks[mp_pose.PoseLandmark.LEFT_HEEL.value].y] 
            
            if landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].visibility < self.min_vizibility:
                return None
            if landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].visibility < self.min_vizibility:
                return None
            if landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].visibility < self.min_vizibility:
                return None
            if landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].visibility < self.min_vizibility:
                return None
            if landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].visibility < self.min_vizibility:
                return None    
            if landmarks[mp_pose.PoseLandmark.LEFT_HEEL.value].visibility < self.min_vizibility:
                return None    
        

        # Calculate right angle
        elbow_angle = self.calculate_angle(shoulder, elbow, wrist)
        hip_angle = self.calculate_angle(shoulder, hip, knee)
        knee_angle = self.calculate_angle(hip, knee, heel)

        # Right Curl counter logic
        self.count(elbow_angle) 
        
        # Return body form feed 
        return self.create_draw((shoulder, elbow, wrist, hip, knee, heel), (hip_angle, knee_angle))

    def create_draw(self, joints, angles):
        """ Called every frame to give graphycal feedback of the joints (good or bad form)"""

        drawing = DrawInfo()
        
        drawing.add_point('shoulder', joints[0][0], joints[0][1])
        drawing.add_point('elbow', joints[1][0], joints[1][1])
        drawing.add_point('wrist', joints[2][0], joints[2][1])
        drawing.add_point('hip', joints[3][0], joints[3][1])
        drawing.add_point('knee', joints[4][0], joints[4][1])
        drawing.add_point('heel', joints[5][0], joints[5][1])

        
        good = self.check_hip(angles[0])                
        drawing.add_segment('shoulder', 'hip', good) # Back

        good = self.check_knee(angles[1])  
        drawing.add_segment('hip', 'knee', good) # Upper leg
        drawing.add_segment('knee', 'heel', good) # Lower leg

        drawing.add_segment('shoulder', 'elbow', True) # Upper arm
        drawing.add_segment('elbow', 'wrist', True) # Forearm

        return drawing

    def check_hip(self, angle):
        """ Form Checking method """
        # Check if hip posture is good
        if angle < 145 and self.stage != 'idle':

            self.hip_fail = True
            return False
        return True 
 
        
    def check_knee(self, angle):
        """ Form Checking method """
        # Check if knee posture is good        
        if angle < 150 and self.stage != 'idle':

            self.knee_fail = True
            return False
        return True 
 

    def count(self, angle):
        """ Responsible for counting reps and keep track of range of motion type problems"""

        if angle < self.start_angle and self.stage == 'idle' and not self.completed:
            # Started motion

            # Save current frame as the start of the rep
            self.start_frame = self.frame_count
            # Update state
            self.stage = "up"
            print("\n[State] Movement Started ! \n")

        if angle < self.minimum_angle and self.stage =='up' and not self.completed:
            # Bare minimum motion rep 

            # Update state
            self.stage="down"
            
            # Update flag
            self.completed = True     
            
            print("[State] Minimum reached...\n")
            
        if angle < self.best_angle and not self.perfect_tag:
            # Perfected motion rep 
            
            # Update flags
            self.completed = True
            self.perfect_tag =True 
            
            # Update state
            self.stage="down"

            print("[State] Maximum reached...\n")

        if angle > self.start_angle-10 and self.stage =='down' and self.completed:  
            # Completed movement 
            
            # Update counter
            self.counter +=1
            # Update state
            self.stage = "idle"

            # Call framework method to announce that the rep has ended
            self.framework.repetition_done(self.start_frame)  

            print("[State] Rep Finished...\n")  
            print("[Info] Rep Count: " + str(self.counter) + "\n\n")   
            
            #Check all form errors
            if self.hip_fail:
                self.framework.add_feedback("curl_back")
                print("[FeedBack] Dont bend forward")
            
            if self.knee_fail:
                self.framework.add_feedback("curl_knee")
                print("[FeedBack] Dont bend your knees")

            if not self.perfect_tag:
                self.framework.add_feedback("curl_rom")
                print("[FeedBack] Not full motion rep >:(\n\n")

            if self.perfect_tag and not self.knee_fail and not self.hip_fail:
                print("[FeedBack] Good rep :)\n")
            

            # Reset flags
            self.hip_fail = False
            self.perfect_tag = False
            self.knee_fail = False 
            self.completed = False

        # Get a frame's bounds
        def get_bounds(landmarks) -> tuple:

            # If it's right facing...
            if landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].z < landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].z:         
                x = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x
                max_y = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y
                min_y = landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].y

                # The padding will be 10% from max to min
                padding = (max_y - min_y) / 10
            # Left facing
            else:
                x = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x
                max_y = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y
                min_y = landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].y

                # The padding will be 10% from max to min
                padding = (max_y - min_y) / 10

            # Adds the padding
            upper_left = [x + padding * 8, max_y + padding * 2]
            lower_right = [x - padding * 8, min_y - padding * 2]

            def clamp(n, smallest, largest):
                return max(smallest, min(n, largest))

            #Clam the values
            upper_left = [clamp(upper_left[0], 0, 1), clamp(upper_left[1], 0, 1)]
            lower_right = [clamp(lower_right[0],0,1), clamp(lower_right[1],0,1)]

            return upper_left, lower_right


    def calculate_angle(self, a_,b_,c_):
        """Calculate angle abc given those 3 coordinates"""
        angle = None
        a = np.array(a_)  
        b = np.array(b_)  
        c = np.array(c_)  
        radians = np.arctan2(c[1]-b[1], c[0]-b[0]) - np.arctan2(a[1]-b[1], a[0]-b[0])
        angle = np.abs(radians*180.0/np.pi)
        if angle >180.0:
            angle = 360-angle
 
        return angle 
