from inspect import currentframe
from tracemalloc import start
import numpy as np
import mediapipe as mp
mp_pose = mp.solutions.pose

class Error:

    def __init__(self, id, critical, landmarks, frame = 0): 

        self.id = id
        self.landmarks = landmarks
        self.frame = frame 
        self.critical = critical

    def __str__(self) -> str:
        
        return "[FeedBack] id:" + str(self.id) + " |  lanndmarks: " + str(self.landmarks) + " |  frame: " + str(self.frame) + " |  critical: " + str(self.critical)  
  
 
   