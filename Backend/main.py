import asyncio
from websockets import serve
import cv2
import numpy as np

from framework import Framework # The framework for processing the frame
from curl import Curl # Test exercise 

fw = Framework()
ex = Curl()
fw.set_exercise(ex)

async def receive(websocket):
    async for data in websocket:

        # If the message is not a string, then it's a frame
        if type(data) != str:

            # Get image from bytes
            decoded_img = cv2.imdecode(np.frombuffer(data, np.uint8), -1)
            decoded_img = cv2.rotate(decoded_img, cv2.ROTATE_90_COUNTERCLOCKWISE) 

            fw.process_frame(decoded_img)
            cv2.waitKey(10)
        # If the message is not a frame...        
        else:
            # If it's a valid message...
            message = Message.decode(data)
            if message != None:

                # If it's statistics...
                if message.type == "STATS":
                    # Do some shit
                    pass

# Starts the websocket
async def main():
    async with serve(receive, port=5000):
        await asyncio.Future()

def send(message):
    print("message")
    pass

asyncio.run(main())