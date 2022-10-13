# This file is just a placeholder.

import cv2
from curl import Curl 
from squat import Squat

# The framework for processing the frame
from framework import Framework
fw = Framework()
ex = Squat()
fw.set_exercise(ex)

cap = cv2.VideoCapture(0)
while cap.isOpened():
    ret, frame = cap.read()
    
    fw.process_frame(frame)

    # Needs this otherwise application freezes 
    if cv2.waitKey(10) & 0xFF == ord('q'):
        break
        
cap.release()
cv2.destroyAllWindows()