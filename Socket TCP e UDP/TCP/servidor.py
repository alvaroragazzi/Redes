import socket

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(("192.168.100.2", 80))
server.listen()

print("Aguardando conexão...")

conexao, endereco = server.accept()

print("Conectado em", endereco)

while True:
    dados = conexao.recv(2048)
    if not dados:
        conexao.close()
        print("Conexão fechada.")
        break
    conexao.sendall(dados)