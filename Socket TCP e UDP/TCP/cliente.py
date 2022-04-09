import socket

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.connect(("192.168.100.2", 80))
server.send(str.encode("informação"))
dado = server.recv(2048)
print("Mensagem recebida:", dado.decode())