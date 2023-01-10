import cv2
import socket
from _thread import *

HOST_IP = '192.168.0.2'
HOST_PORT = 8995

# 주소 체계(address family)로 IPv4, 소켓 타입으로 TCP 사용합니다.
client_socket = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
client_socket.connect((HOST_IP, HOST_PORT))
client_socket.sendall('back-pannel'.encode())


# image path & name & extension
image_path = 'D:/github/photo_zone_system/windows/images/'
def image_output(img_path, img_name, img_extension):
    image = cv2.imread(img_path + img_name + img_extension)
    cv2.imshow('image', image)
    cv2.waitKey(1)

# 서버로부터 메세지를 받는 메소드
# 스레드로 구동 시켜, 메세지를 보내는 코드와 별개로 작동하도록 처리
def recv_data(client_socket) :
    # fullscreen output
    cv2.namedWindow('image', cv2.WINDOW_NORMAL)
    cv2.setWindowProperty('image', cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
    image_output(image_path, 'init_image', '.jpg')
    while True :
        data = client_socket.recv(1024)
        print("recive : ", data.decode())
        if data.decode() == '0':
            image_output(image_path, 'init_image', '.jpg')
        elif data.decode() == '1':
            image_output(image_path, 'test_image', '.jpg')

start_new_thread(recv_data, (client_socket,))
print ('>> Connect Server')

while True:
    message = input('')
    if message == 'quit':
        close_data = message
        break
    client_socket.send(message.encode())
client_socket.close()
cv2.destroyAllWindows()