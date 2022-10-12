import asyncio
from websockets import serve
import cv2
import numpy as np
import json



async def recieve(websocket):
    count = 1
    repCount = 0
    cv2.namedWindow("test")

    async for message in websocket:

        # frames
        if type(message) != str:

            # get image from bytes
            decoded = cv2.imdecode(np.frombuffer(message, np.uint8), -1)
            decoded = cv2.rotate(decoded, cv2.ROTATE_180) 

            # show image
            cv2.imshow("test", decoded)
            cv2.waitKey(10)

            data = {}

            # if finished set
            if count % 56 == 0:

                # do some shit

                data = {'message': 'finished', 'gifs': "there are no gifs available"}

            # if finished rep
            elif count % 10 == 0:

                # do some shit

                repCount += 1
                data = {'message': 'repCount', 'repCount': repCount}

            # send message
            if "message" in data.keys():
                print(f"Sending Message: {data}")
                await websocket.send(json.dumps(data))

            count += 1

        # messages like get statistics        
        else:
            json_message = json.loads(message)

            # normal message
            if "message" in json_message.keys():

                # statistics
                if json_message["message"] == "statistics":

                    # do some shit

                    # send statistics
                    data = {'message': 'statistics'}
                    print(f"Sending Message: {data}")
                    await websocket.send(json.dumps(data))


async def main():
    async with serve(recieve, port=5000):
        await asyncio.Future()

asyncio.run(main())



"""
messages:
    - repCount      = {'message': 'repCount', 'repCount': <repCount>}
    - finishSet     = {'message': 'finished', 'gifs': <gifs>}
    - statistics    = {'message': 'statistics'}
"""