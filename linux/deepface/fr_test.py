from deepface import DeepFace
import cv2
import socket
from _thread import *

HOST_IP = '192.168.0.29'
HOST_PORT = 8995

client_socket = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
client_socket.connect((HOST_IP, HOST_PORT))
client_socket.sendall('face-recognition'.encode())

image_path = "linux/deepface/image.jpg"
webcam = cv2.VideoCapture(0)

if not webcam.isOpened():
    print("Could not open webcam")
    exit()
        
while webcam.isOpened():
    status, frame = webcam.read()
    
    if status:
        cv2.imwrite(image_path, frame)
        demography = DeepFace.analyze(image_path)
        send_data = f"{demography['dominant_emotion']} {demography['age']} {demography['dominant_gender']}"
        client_socket.send(send_data.encode())
        print(send_data)
        x, y, w, h = demography['region'].values()
        # print(x, y, w, h)

        if x != 0 and y != 0:
            cv2.rectangle(frame, [x, y], [x + w, y + h], (0, 0, 255), 3)
        cv2.imshow("image", frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

while True:
    message = input('')
    if message == 'quit':
        close_data = message
        break
    client_socket.send(message.encode())
webcam.release()
cv2.destroyAllWindows()