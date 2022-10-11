import asyncio
from websockets import serve
import cv2, base64
import numpy as np
import requests
import time

port = 5000

cv2.namedWindow("test")

async def recieve(websocket):
    count = 0
    start = time.time()
    async for message in websocket:
        decoded = cv2.imdecode(np.frombuffer(message, np.uint8), -1)
        decoded = cv2.rotate(decoded, cv2.ROTATE_180) 

        cv2.imshow("test", decoded)
        cv2.waitKey(10)

        x = requests.put("http://localhost:8393/rep", data={"repCount": count})
        print(x.content.decode())
        count += 1
        print(f"Time: {time.time() - start}")

async def main():
    async with serve(recieve, port=port):
        await asyncio.Future()

asyncio.run(main())