import json

import tensorflow as tf
import tensorflow_hub as hub
import numpy as np
import PIL.Image as Image
import keras.utils as image
import pandas as pd
import asyncio
import websockets
# from keras.preprocessing import image 
print("model started")
URL = 'https://tfhub.dev/google/aiy/vision/classifier/birds_V1/1'              
bird = hub.KerasLayer(URL, input_shape=(224,224,3))                 
bird.trainable=False 
model=tf.keras.Sequential([bird])
labels=pd.read_csv("aiy_birds_V1_labelmap.csv")
IMAGE_RES = 224                                                             
def preprocess(img_path):
    img = image.load_img(img_path, target_size=(IMAGE_RES, IMAGE_RES))  
    x = image.img_to_array(img)/255.0                                         
    x = np.expand_dims(x, axis=0)                                             
    return x 
output=model.predict(preprocess('img.jpg'))
prediction = np.argmax(tf.squeeze(output).numpy())+1
bird_name=labels["name"][prediction].split(" ")[0]
url=f"https://en.wikipedia.org/wiki/{bird_name}"
async def send_data():
  async with websockets.connect('wss://0hiutyz0c8.execute-api.us-east-1.amazonaws.com/production') as websocket:
    await websocket.send(json.dumps({"action":"message","message":url}))
asyncio.get_event_loop().run_until_complete(send_data())

print(url)