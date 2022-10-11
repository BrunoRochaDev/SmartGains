from inspect import currentframe
from tracemalloc import start
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
        self.best_angle = 30 # best rep angle (good range of motion)
        self.start_angle = 160 # less then this is not a good rep (bad range of motion)  
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
        

        #return True
        return self.create_draw(landmarks, hip_angle, knee_angle)

    def create_draw(self, landmarks, hip, knee):
        drawing = DrawInfo()
        
        drawing.add_point('shoulder', landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y)
        drawing.add_point('elbow',landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x, landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y )
        drawing.add_point('wrist', landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x, landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y)
        drawing.add_point('hip', landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x, landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y)
        drawing.add_point('knee', landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].x, landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].y)
        drawing.add_point('heel', landmarks[mp_pose.PoseLandmark.LEFT_HEEL.value].x, landmarks[mp_pose.PoseLandmark.LEFT_HEEL.value].y)

        
        good = self.check_hip(hip)                
        drawing.add_segment('shoulder', 'hip', good)
        drawing.add_segment('hip', 'knee', good)

        good = self.check_knee(knee)  
        drawing.add_segment('hip', 'knee', good)
        drawing.add_segment('knee', 'heel', good)

        return drawing

    def check_hip(self, angle):
        # Check if hip posture is good
        if angle < 160 and self.stage != 'idle':

            self.hip_fail = True
            return False
        return True 
 
        
    def check_knee(self, angle):
        # Check if knee posture is good        
        if angle < 160 and self.stage != 'idle':

            self.knee_fail = True
            return False
        return True 
 

    def count(self, angle):
        """ Responsible for counting reps and keep track of range of motion tyype problems"""

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

        if angle > self.start_angle and self.stage =='down' and self.completed:  
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
                
                self.framework.add_feedback(Error("curl_hb", True, ("shoulder", "hip", "knee") , self.hip_fail))
                #print("[FeedBack] Dont bend forward")
            
            if self.knee_fail:
                 
                self.framework.add_feedback(Error("curl_kb" , True, ("hip", "knee", "heel"), self.knee_fail))
                #print("[FeedBack] Dont bend your knees")

            if not self.perfect_tag:

                self.framework.add_feedback(Error("curl_rm", False, ("shoulder", "elbow", "wrist")))
                #print("[FeedBack] Not full motion rep >:(\n\n")

            if self.perfect_tag and not self.knee_fail and not self.hip_fail:
                print("[FeedBack] Good rep :)\n")
            

            # Reset flags
            self.hip_fail = False
            self.perfect_tag = False
            self.knee_fail = False 
            self.completed = False

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