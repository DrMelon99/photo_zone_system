import socket
from _thread import *

# server PORT
HOST_PORT = 8995

# 서버에 접속한 클라이언트 목록
client_sockets = []

# 접속한 클라이언트마다 새로운 쓰레드가 생성되어 통신
def threaded(client_socket, addr):
    print('>> Connected by :', addr[0], ':', addr[1])

    # 클라이언트가 접속을 끊을 때 까지 반복
    while True:
        try:
            # 데이터 수신 대기
            data = client_socket.recv(1024)

            if not data:
                print('>> Disconnected by ' + addr[0], ':', addr[1])
                break
            print('>> Received from ' + addr[0], ':', addr[1], data.decode())

            # 서버에 접속한 클라이언트들에게 채팅 보내기
            for client in client_sockets :
                # 메세지를 보낸 본인을 제외한 서버에 접속한 클라이언트에게 메세지 보내기
                if client != client_socket :
                    client.send(data)

        except ConnectionResetError as e:
            print('>> Disconnected by ' + addr[0], ':', addr[1])
            break

    if client_socket in client_sockets :
        client_sockets.remove(client_socket)
        print('remove client list : ',len(client_sockets))

    client_socket.close()

# 서버 소켓 생성
print('>> Server Start')
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_socket.bind(('', HOST_PORT))
server_socket.listen()

# 클라이언트 접속 시 accept 함수에서 새로운 소켓 리턴
# 새로운 Thread에서 해당 리턴받은 소켓으로 통신
try:
    while True:
        print('>> Wait')
        client_socket, addr = server_socket.accept()        
        client_sockets.append(client_socket)
        start_new_thread(threaded, (client_socket, addr))
        print("connects : ", len(client_sockets))

except Exception as e :
    print (f'Error : {e}')

finally:
    server_socket.close()