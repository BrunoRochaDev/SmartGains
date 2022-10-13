import asyncio
from websockets import serve
import cv2
import numpy as np

from framework import Framework # The framework for processing the frame
from curl import Curl # Test exercise 

# Buffer for messages to send
messages = []

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

        # Send all pending messages
        while len(messages) != 0:
            await websocket.send(messages.pop().encode())

def send(msg):
    messages.append(msg)

fw = Framework()
fw.message_callback = send
ex = Curl()
fw.set_exercise(ex)

# Starts the websocket
async def main():
    async with serve(receive, port=5000):
        await asyncio.Future()

asyncio.run(main())