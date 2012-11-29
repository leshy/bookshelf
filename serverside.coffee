comm = require 'comm/serverside'
mongodb = require 'mongodb'
express = require 'express'
async = require 'async'

# db

db = new mongodb.Db('bookshelf', new mongodb.Server('localhost', 27017), {safe: true})
books = new comm.MongoCollectionNode { db: db, collection: 'book' }

db.open -> true

# web

app = express.createServer()

app.configure -> 
    app.set('views', __dirname + '/views')
    app.set('view engine', 'ejs')
    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(app.router)
    app.use(express.static(__dirname + '/static'))

app.get '/', (req,res) -> res.render 'index', { title: "bookshelf" }

app.listen 3333

websocket = new comm.WebsocketServer realm: "web", express: app
websocket.listen()

core = new comm.MsgNode()
core.pass()

core.subscribe true, (msg,reply,next,transmit) ->
    console.log "GOT",msg
    reply.end()

books.connect core

http = new comm.HttpServer realm: "web", express: app, root: '/rest/'
rest = new comm.Rest root: '/rest/apiv1/'

rest.connect http
core.connect rest
core.connect websocket


