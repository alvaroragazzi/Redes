import threading
import socket
import json
import struct
from datetime import datetime
 
thread = threading.Event()
 
def decode(json):
    return json.loads(json.decode())
 
def encode(username, message):
    return json.dumps({
        "dt": datetime.now().isoformat(),
        "msg": message,
        "autor": username,
    }).encode()
 
def server():
    print("Iniciando servidor")

    sock = socket.socket(
        socket.AF_INET,
        socket.SOCK_DGRAM,
        socket.IPPROTO_UDP
    )

    sock.settimeout(0.5)

    sock.setsockopt(
        socket.SOL_SOCKET,
        socket.SO_REUSEADDR,
        1
    )

    sock.setsockopt(
        socket.IPPROTO_IP,
        socket.IP_ADD_MEMBERSHIP,
        struct.pack(
            "4sl",
            socket.inet_aton("224.1.1.1"),
            socket.INADDR_ANY,
        )
    )

    sock.bind(("224.1.1.1", 5007))
 
    while not thread.is_set():
        try:
            dados = decode(sock.recv(10240))
            data = datetime.fromisoformat(dados["dt"])
            print(f"{dados['autor']} | {data.strftime('%H:%M')}: {dados['msg']}")
        except TimeoutError:
            pass
 
sock = socket.socket(
    socket.AF_INET,
    socket.SOCK_DGRAM,
    socket.IPPROTO_UDP
)
 
sock.setsockopt(
    socket.IPPROTO_IP,
    socket.IP_MULTICAST_TTL,
    2
)
 
server_thread = threading.Thread(target = server)
 
usuario = input("Usuário: ")

server_thread.start()
 
try:
    while True:
        mensagem = input("Mensagem: ")
        sock.sendto(encode(usuario, mensagem), ("224.1.1.1", 5007))
except KeyboardInterrupt:
    print("Desligando servidor")
    thread.set()
    server_thread.join()
