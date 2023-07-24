from livereload import Server

import os.path
from flask import Flask
from flask_autoindex import AutoIndex

app = Flask(__name__)
AutoIndex(app, browse_root=os.path.curdir)

server = Server(app)
server.watch('*.html')
server.serve()
