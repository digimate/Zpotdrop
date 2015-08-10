var io = require('socket.io')(7076);

io.on('connection', function (socket) {
    console.log("On connecting");
    var redisUser = require('redis').createClient();
    socket.on("groupme", function(data){
        socket.join("groupme");
        if (typeof data == "string")
            data = JSON.parse(data);
        console.log("New user listening:" + data.group);
        var response = JSON.parse('{"id":70,"content":"I am chatting","created_at":"2015-07-14T20:51:03+0700","owner":{"id":6,"dob":"1994-02-21T00:00:00+0700","hash":"8tbuetndb442","rates":3,"reviews":10,"professional":"videographer","speciality":"fashion,docu","profile_image":"\/mediafile\/users\/8tbuetndb442\/reviewfile.jpg","gender":2,"ethnicity":"other","collar":45,"chest":74,"waist":97,"shirt_size":2,"shoe_size":39,"suit_size":4,"hair_color":"light blonde","eye_color":"blue","height":186,"hips":87,"dress_size":5,"bust":146},"group":145}');
        io.sockets.in("groupme").emit("groupme", response);
    })
    socket.on("join", function (data) {
        if (typeof data == "string")
            data = JSON.parse(data);
        console.log("New user listening:" + data.group);
        redisUser.subscribe("group_" + data.group);
        redisUser.on("message", function (channel, jsonData) {
            console.log(jsonData);
            console.log(channel);
            io.sockets.in(channel).emit(channel, jsonData);
        });
        socket.join("group_" + data.group);
    })
    socket.on("join_group", function (group) {
        redisUser.subscribe('group_' + group);
        redisUser.on("message", function (channel, jsonData) {
            var data = JSON.parse(jsonData);
            console.log(data.action);
            console.log(channel);
            io.to(channel).emit("message", data);
        })
    })

    socket.on("disconnect", function () {
        redisUser.quit();
    })
    //
    socket.on('logged', function (msg) {
        redisUser.subscribe('users_' + msg);
        socket.join('users_' + msg);
        console.log(msg);
        console.log('join room');
        redisUser.on('message', function (channel, jsondata) {
            //socket.join(channel);
            //console.log(channel);
            var data = JSON.parse(jsondata);
            console.log(data.action);
            //socket.broadcast.to(channel).emit(data.action, data);
            io.sockets.in(channel).emit(data.action, data);
        });

        socket.on('disconnect', function () {
            console.log('disconnect ' + msg);
            socket.leave('users_' + msg);
            redisUser.unsubscribe("group_" + msg);
            redisUser.quit();
        })
    });
});