import socket

server = server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server.connect(("192.168.100.2", 80))
server.send(str.encode("informação"))
dado = server.recvfrom(2048)
print("Mensagem recebida:", dado.decode())