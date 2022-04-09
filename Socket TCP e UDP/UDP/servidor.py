import socket

server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server.bind("192.168.100.2", 80)
server.listen()

conexao, endereco = server.accept()

print("Servidor conectado em:", endereco)

while True: 
    dados, endereco = server.recvfrom(2048)
    if not dados:
        conexao.close()
        print("Conexão fechada.")
        break
    conexao.sendall(dados)
    server.sendto()