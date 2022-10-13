import asyncio
from websockets import serve
import cv2
import numpy as np

from framework import Framework # The framework for processing the frame

from protocol import Message

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
                # If it's setting a new exercise...
                if message.type == "EXERCISE":
                    print(f"'{message.exercise}' exercise selected.")
                    fw.set_exercise(message.create_object())

        # Send all pending messages
        while len(messages) != 0:
            await websocket.send(messages.pop().encode())

def send(msg):
    messages.append(msg)

fw = Framework()
fw.message_callback = send

# Starts the websocket
async def main():
    async with serve(receive, port=5000):
        await asyncio.Future()

asyncio.run(main())