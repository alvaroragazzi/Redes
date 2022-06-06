from http.server import HTTPServer, BaseHTTPRequestHandler

class Server(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()

        self.wfile.write(bytes('''
            <html>
                <body>
                    <h1>Olá</h1>
                </body>
            </html>
        ''', "iso-8859-1"))

IP = "localhost"
PORT = 8080

server = HTTPServer((IP, PORT), Server)
print("Servidor inciado")
server.serve_forever()
