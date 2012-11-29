/**
 * Module dependencies.
 */
var mongoserver = "localhost"
var mongoport = 27017
var mongodbname = "bookshelf"
var name = "bookshelf"

var express = require('express');
var app = module.exports = express.createServer();
var sys = require('sys');
var mongo = require('mongodb');
var BSON = mongo.BSONPure

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'ejs');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/static'));
});

// mongodb 

var db = new mongo.Db(mongodbname,new mongo.Server(mongoserver,mongoport, {}), {});

db.open( function (err) {
    if (err) {
	console.log("mongodb connection failed: " + err.stack );	
	return
    }
    console.log("connected to mongodb server")

    db.collection("users", function (err,collection) {
	db.users = collection
    })
});

// Routes

app.post ('*', function (req, res, next) {
    console.log (" - " + req.method + " " + req.url + " " )
    next()
})

app.get ('*', function (req, res, next) {
    console.log (" - " + req.method + " " + req.url + " " )
    next()
})

app.get('/', function(req, res){
	res.render('index', { title: name })
});

if (!module.parent) {
  app.listen(8000);
  console.log("Express server listening");
}



