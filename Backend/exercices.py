from inspect import currentframe
from tracemalloc import start
import numpy as np
import mediapipe as mp
mp_pose = mp.solutions.pose

class curls:

    def __init__(self): 

        # Framework Refernece given by the  framework itself
        self.framework = None

        # Count of the current frame since the exercise started
        self.start_frame = 0

        # Tags for the counting logic
        self.hip_fail = False
        self.knee_fail = False
        self.perfect_tag = [False, False] # Rep was perfect (in the range of motion requirement)
        self.completed = [False, False] # Rep was done 
        self.stage = ["up","up"] # "up" or "down" keeps track of the current movement  

        # Cues related values 
        self.minimum_angle = 100  # consider start of the rep 
        self.best_angle = 30 # best rep angle (good range of motion)
        self.start_angle = 160 # less then this is not a good rep (bad range of motion)  

        # Debugging Counter of reps
        self.counter = 0
 
 

    def analyze_frame(self, frame_count, landmarks):
        """ | Analyzes frame | calls method of framework when rep is finished with the rep information"""

        self.frame_count = frame_count

        # Get right key positions 
        right_shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y]
        right_elbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y]
        right_wrist = [landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y]
        right_hip = [landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y]
        right_knee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].y]
        right_heel = [landmarks[mp_pose.PoseLandmark.RIGHT_HEEL.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_HEEL.value].y]
        # Calculate right angle
        right_elbow_angle = self.calculate_angle(right_shoulder, right_elbow, right_wrist)
        right_hip_angle = self.calculate_angle(right_shoulder, right_hip, right_knee)
        right_knee_angle = self.calculate_angle(right_hip, right_knee, right_heel)
        # Get left key positions 
        left_shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y]
        left_elbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y]
        left_wrist = [landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y]
        left_hip = [landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x,landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y]
        left_knee = [landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].y]
        left_heel = [landmarks[mp_pose.PoseLandmark.LEFT_HEEL.value].x,landmarks[mp_pose.PoseLandmark.LEFT_HEEL.value].y]
        # Calculate left angle
        left_elbow_angle = self.calculate_angle(left_shoulder, left_elbow, left_wrist)  
        left_hip_angle = self.calculate_angle(left_shoulder, left_hip, left_knee)
        left_knee_angle = self.calculate_angle(left_hip, left_knee, left_heel)
         
        # Right Curl counter logic
        self.count(right_elbow_angle,0) 
        self.check_hip(right_hip_angle, 0)   
        self.check_knee(right_knee_angle, 0)      


        # Left Curl counter logic
        self.count(left_elbow_angle,1)     

       
    def check_hip(self, angle,side):
        
        if angle < 170 and (self.stage[0] != 'idle' or self.stage[1] != 'idle') and not self.hip_fail:
            print("[Instant FeedBack] HIP !!!!\n")
            self.hip_fail = True

        return 

    def check_knee(self, angle,side):
        
        if angle < 170 and (self.stage[0] != 'idle' or self.stage[1] != 'idle') and not self.knee_fail:
            print("[Instant FeedBack] KNEE !!!!\n")
            self.knee_fail = True

        return 


    def count(self, angle, side):
        """ Responsible for counting reps and keep track of range of motion tyype problems"""



    
        if angle < self.start_angle and self.stage[side] == 'idle' and self.stage[self.invert_side(side)] == 'idle' and not self.completed[side]:
            # Started motion

            self.start_frame = self.frame_count
            self.stage[side] = "up"
            print("\n[State] Movement Started ! \n")

        if angle < self.minimum_angle and self.stage[side] =='up' and not self.completed[side]:
            # Bare minimum motion rep 

            self.stage[side]="down"
            self.completed[side] = True     
            print("[State] Minimum reached...\n")
            
        if angle < self.best_angle and not self.perfect_tag[side] and self.stage[self.invert_side(side)] == 'idle':
            # Perfected motion rep 

            self.completed[side] = True
            self.perfect_tag[side] =True
            
            self.stage[side]="down"
            print("[State] Maximum reached...\n")

        if angle > self.start_angle and self.stage[side] =='down' and self.completed[side]:  
            # Completed movement 
            
            
                
            self.counter +=1
            self.stage[side] = "idle"
            self.framework.repetition_done(self.start_frame)
            
            

            print("[State] Rep Finished...\n")  
            print("[Info] Rep Count: " + str(self.counter) + "\n\n")   
            
            if self.hip_fail:
                
                print("[FeedBack] Dont bend forward")
            
            if self.knee_fail:
                 
                print("[FeedBack] Dont bend your knees")

            if not self.perfect_tag[side]:
                print("[FeedBack] Not full motion rep >:(\n\n")

            if self.perfect_tag[side] and not self.knee_fail and not self.hip_fail:
                print("[FeedBack] Good rep :)\n")
            
            self.hip_fail = False
            self.perfect_tag[side]=False
            self.knee_fail = False

            self.completed[side] = False


    def invert_side(self, side):
        if side == 1:
            return 0
        else:
            return 1


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