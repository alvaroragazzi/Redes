import socket

IP = "localhost"
PORT = 8080

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server.bind((IP, PORT))
server.listen(1)

print(f"Servidor iniciado em http://{IP}:{PORT}")

http_response = ("HTTP/1.0 200 OK\n\nOlá").encode("iso-8859-1")

try:
    while True:    
        connection, client_address = server.accept()

        request = connection.recv(1024).decode()

        print(f"Requisição recebida:\n{request}")

        connection.sendall(http_response)
        connection.close()
except KeyboardInterrupt:
    print("Desligando servidor...")
    server.close()
