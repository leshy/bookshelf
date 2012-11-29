comm = require 'comm/clientside'


window.websocket = websocket = new comm.WebsocketClient realm: "web"
websocket.connect('http://localhost:3333')
window.books = books = new comm.RemoteCollection { name: 'book' }


books.connect websocket
