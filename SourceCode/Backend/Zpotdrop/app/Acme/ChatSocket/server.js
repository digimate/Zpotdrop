// Author: Pisun2
// Email: pisun2@gmail.com

// ***************************************************************************
// General
// ***************************************************************************

var conf = {
    port: 8888,
    host: 'zpotdrop.dev',
    debug: false,
    dbPort: 6379,
    dbHost: '127.0.0.1',
    dbOptions: {detect_buffers: true},
    onlineUsers: 'onlineUsers:',
    users: 'users:',
    rooms: 'rooms:',
    messages: ':messages',
    latestMsg: ':latestMsg:'
};

// External dependencies
var express = require('express'),
    http = require('http'),
    socketio = require('socket.io'),
    events = require('events'),
    _ = require('underscore'),
    redis = require('redis'),
    sanitize = require('validator').sanitize;

// HTTP Server configuration & launch
var app = express(),
    server = http.createServer(app),
    io = socketio.listen(server);
server.listen(conf.port);

// Express app configuration
app.configure(function() {
    app.use(express.bodyParser());
    app.use(express.static(__dirname + '/static'));
});

// Socket.io store configuration
var RedisStore = require('socket.io/lib/stores/redis'),
    pub = redis.createClient(conf.dbPort, conf.dbHost, conf.dbOptions),
    sub = redis.createClient(conf.dbPort, conf.dbHost, conf.dbOptions),
    db = redis.createClient(conf.dbPort, conf.dbHost, conf.dbOptions);
io.set('store', new RedisStore({
    redisPub: pub,
    redisSub: sub,
    redisClient: db
}));
io.set('log level', 1);

// Logger configuration
var logger = new events.EventEmitter();
logger.on('newEvent', function(event, data) {
    // Console log
    console.log('%s: %s', event, JSON.stringify(data));
    // Persistent log storage too?
    // TODO
});

// ***************************************************************************
// Express routes helpers
// ***************************************************************************

// Only authenticated users should be able to use protected methods
var requireAuthentication = function(req, res, next) {
    // TODO
    next();
};

// Sanitize message to avoid security problems
var sanitizeMessage = function(req, res, next) {
    if (req.body.msg) {
        req.sanitizedMessage = sanitize(req.body.msg).xss();
        next();
    } else {
        res.send(400, "No message provided");
    }
};

// Send a message to all active rooms
var sendBroadcast = function(text) {
    _.each(_.keys(io.sockets.manager.rooms), function(room) {
        room = room.substr(1); // Forward slash before room name (socket.io)
        // Don't send messages to default "" room
        if (room) {
            var message = {'room':room, 'username':'ServerBot', 'msg':text, 'date':new Date()};
            io.sockets.in(room).emit('newMessage', message);
        }
    });
    logger.emit('newEvent', 'newBroadcastMessage', {'msg':text});
};

//get all users in rooms
var usersInRoom = function(room){
    var usersInRoom = [];
    var socketsInRoom = io.sockets.clients(room);
    for (var i=0; i<socketsInRoom.length; i++) {
        db.hgetall(conf.onlineUsers + socketsInRoom[i].id, function(err, obj) {
            usersInRoom.push({'room':room, 'username':obj.username, 'id':obj.socketID});
            // When we've finished with the last one, notify user
            if (usersInRoom.length == socketsInRoom.length) {
                return usersInRoom;
            }
        });
    }
}
// ***************************************************************************
// Express routes
// ***************************************************************************

// Welcome message
app.get('/', function(req, res) {
    res.send(200, "Welcome to chat server");
});

// Broadcast message to all connected users
app.post('/api/broadcast/', requireAuthentication, sanitizeMessage, function(req, res) {
    sendBroadcast(req.sanitizedMessage);
    res.send(201, "Message sent to all rooms");
});

// ***************************************************************************
// Socket.io events
// ***************************************************************************
io.sockets.on('connection', function(socket) {

    // Welcome message on connection
    socket.emit('connected', 'Welcome to the chat server');
    logger.emit('newEvent', 'userConnected', {'socket':socket.id});

    // Store user data in db without hash user - email
    db.hset([conf.onlineUsers + socket.id, 'connectionDate', new Date()], redis.print);
    db.hset([conf.onlineUsers + socket.id, 'socketID', socket.id], redis.print);

    // User wants to subscribe to [data.rooms]
    socket.on('subscribe', function(data) {
        // Get user info from db
        db.hget([conf.onlineUsers + socket.id, 'username'], function(err, username) {
            //Set hash
            db.hset([conf.onlineUsers + socket.id, 'username', data.username], redis.print);

            // Subscribe user to chosen rooms
            _.each(data.rooms, function(room) {
                //room = room.replace(" ","");
                socket.join(room);
                logger.emit('newEvent', 'userJoinsRoom', {'socket':socket.id, 'username':data.username, 'user_id':data.user_id, 'room':room});

                // Confirm subscription to user
                socket.emit('subscriptionConfirmed', {'room': room});

                // Notify subscription to all users in room
                var message = {'room':room, 'username':data.username,'user_id':data.user_id, 'msg':'----- Joined the room -----', 'id':socket.id};
                io.sockets.in(room).emit('userJoinsRoom', message);
            });
        });
    });

    // User wants to unsubscribe from [data.rooms]
    socket.on('unsubscribe', function(data) {
        // Get user info from db
        db.hget([conf.onlineUsers + socket.id, 'username'], function(err, username) {

            // Unsubscribe user from chosen rooms
            _.each(data.rooms, function(room) {
                if (room != conf.mainroom) {
                    socket.leave(room);
                    logger.emit('newEvent', 'userLeavesRoom', {'socket':socket.id, 'username':username, 'room':room});

                    // Confirm unsubscription to user
                    socket.emit('unsubscriptionConfirmed', {'room': room});

                    // Notify unsubscription to all users in room
                    //var message = {'room':room, 'username':username, 'msg':'----- Left the room -----', 'id': socket.id};
                    //io.sockets.in(room).emit('userLeavesRoom', message);
                }
            });
        });
    });

    // User wants to know what rooms he has joined
    socket.on('getRooms', function(data) {
        socket.emit('roomsReceived', io.sockets.manager.roomClients[socket.id]);
        logger.emit('newEvent', 'userGetsRooms', {'socket':socket.id});
    });

    // Get users in given room
    socket.on('getUsersInRoom', function(data) {
        var usersInRoom = [];
        var socketsInRoom = io.sockets.clients(data.room);
        for (var i=0; i<socketsInRoom.length; i++) {
            db.hgetall(conf.onlineUsers + socketsInRoom[i].id, function(err, obj) {
                usersInRoom.push({'room':data.room, 'username':obj.username, 'id':obj.socketID});
                // When we've finished with the last one, notify user
                if (usersInRoom.length == socketsInRoom.length) {
                    socket.emit('usersInRoom', {'users':usersInRoom});
                }
            });
        }
    });

    // New message sent to group
    socket.on('newMessage', function(data) {
        console.log('==================send message to server: %s', JSON.stringify(data));

        db.hgetall(conf.onlineUsers + socket.id, function(err, obj) {
            if (err) return logger.emit('newEvent', 'error', err);

            // Check if user is subscribed to room before sending his message
            if (_.has(io.sockets.manager.roomClients[socket.id], "/"+data.room)) {
                var message = {
                    'room':data.room,
                    'user_id':obj.user_id,
                    'username':obj.username,
                    'msg':data.msg,
                    'date':new Date(),
                    'isRead':false
                };
                db.lpush(conf.rooms + data.room + conf.messages, JSON.stringify(message),
                    function(e, r){
                        // Send message to room
                        socket.broadcast.in(data.room).emit('newMessage', message);
                        logger.emit('newEvent', 'newMessage', message);

                        //Check and save latest message for users in room
                        var usersRooms = usersInRoom(data.room);
                        _.each(usersRooms, function(user) {
                            //insert latest message
                            db.hset([conf.rooms + data.room + conf.latestMsg + user.user_id, 'room', data.room], redis.print);
                            db.hset([conf.rooms + data.room + conf.latestMsg + user.user_id, 'user_id', user.user_id], redis.print);
                            db.hset([conf.rooms + data.room + conf.latestMsg + user.user_id, 'username', user.username], redis.print);
                            db.hset([conf.rooms + data.room + conf.latestMsg + user.user_id, 'msg', data.msg], redis.print);
                            db.hset([conf.rooms + data.room + conf.latestMsg + user.user_id, 'date', new Date()], redis.print);
                            db.hset([conf.rooms + data.room + conf.latestMsg + user.user_id, 'isRead', false], redis.print);
                        });
                    });
            }
        });
    });

    //Get chat history
    socket.on('getChatHistoryMessage', function(data){
        db.lrange(conf.rooms + data.room + conf.messages, 0, 20, function(err, messages){
            socket.emit('chatHistoryMessage', '['+messages+']');
        });
    })

    //Get latest message of room
    socket.on('getLatestMessage', function(data){
        logger.emit('newEvent', 'latestMessage:Rooms', JSON.stringify(data.rooms));
        //for each to get room data.rooms
        _.each(data.rooms, function(room) {
            db.lindex(conf.rooms + room + conf.messages, 0, function(err, message){
                socket.emit('latestMessage', message);
                logger.emit('newEvent', 'latestMessage', message);
            });
        });
    })

    // Clean up on disconnect
    socket.on('disconnect', function() {
        // Get current rooms of user
        var rooms = _.clone(io.sockets.manager.roomClients[socket.id]);

        // Get user info from db
        db.hgetall(conf.onlineUsers + socket.id, function(err, obj) {
            if (err) return logger.emit('newEvent', 'error', err);
            logger.emit('newEvent', 'userDisconnected', {'socket':socket.id, 'username':obj.username});

            // Notify all users who belong to the same rooms that this one
            _.each(_.keys(rooms), function(room) {
                room = room.substr(1); // Forward slash before room name (socket.io)
                if (room) {
                    var message = {'room':room, 'username':obj.username, 'msg':'----- Left the room -----', 'id':obj.socketID};
                    io.sockets.in(room).emit('userLeavesRoom', message);
                }
            });
        });

        // Delete user from db
        db.del(conf.onlineUsers + socket.id, redis.print);
    });
});

// Automatic message generation (for testing purposes)
if (conf.debug) {
    setInterval(function() {
        var text = 'Testing rooms';
        sendBroadcast(text);
    }, 60000);
}
