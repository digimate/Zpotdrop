/**
 * Created by Nhieu Nguyen on 11/10/2015.
 */


// Author: Sergio Castaño Arteaga
// Email: sergio.castano.arteaga@gmail.com

(function(){

    var debug = false;

    // ***************************************************************************
    // Socket.io events
    // ***************************************************************************

    var socket = io.connect('http://zpotdrop.dev:8888');
    var hash = null;
    // Connection established
    socket.on('connected', function (data) {
        //console.log(data);

        // Get users connected to mainroom
        //socket.emit('getUsersInRoom', {'room':'MainRoom'});

        //subscribe user to all rooms
        /*socket.emit('subscribe', {
            'username': getCurrentUserHash(),
            'rooms':getRoomsName()
        });*/
    });

    // Disconnected from server
    socket.on('disconnect', function (data) {
        var info = {'room':'MainRoom', 'username':'ServerBot', 'msg':'----- Lost connection to server -----'};
        //addMessage(info);
    });

    // Reconnected to server
    socket.on('reconnect', function (data) {
        //subscribe user to all rooms
        socket.emit('subscribe', {
            'username': getCurrentUserHash(),
            'rooms':getRoomsName()
        });

        var info = {'room':'MainRoom', 'username':'ServerBot', 'msg':'----- Reconnected to server -----'};
        //addMessage(info);
    });

    // Subscription to room confirmed
    socket.on('subscriptionConfirmed', function(data) {
        //update latestmessage
        //updateLatestMessage(getRoomsName());
    });

    // Unsubscription to room confirmed
    socket.on('unsubscriptionConfirmed', function(data) {
        // Remove room space in interface
        if (roomExists(data.room)) {
            removeRoom(data.room);
        }
    });

    // User joins room
    socket.on('userJoinsRoom', function(data) {
        console.log("userJoinsRoom: %s", JSON.stringify(data));
        // Log join in conversation
        //addMessage(data);
    });

    // User leaves room
    socket.on('userLeavesRoom', function(data) {
        console.log("userLeavesRoom: %s", JSON.stringify(data));
        // Log leave in conversation
        //addMessage(data);
    });

    // Message received
    socket.on('newMessage', function (data) {
        //console.log("newMessage: %s", JSON.stringify(data));
        //addMessage(data);
        //addLatestMessage(data);
        //makeNotSeenRoomChat(data);
        //update latestmessage
        //updateLatestMessage([data.room]);

        console.log("newMessage: %s", JSON.stringify(data));
        addMessage(data);

        // Scroll down room messages
        var room_messages = '#'+data.room+' #room_messages';
        $(room_messages).animate({
            scrollTop: $(room_messages).height()
        }, 300);

    });

    // Message received
    socket.on('latestMessage', function (data) {
        console.log("newMessage: %s", data);
        addLatestMessage(JSON.parse(data));
    });

    //get chat message list
    socket.on('chatHistoryMessage', function (data) {
        var messages = jQuery.parseJSON(data);
        messages.reverse();
        var $chatbox = $('#body_room_message_' + getCurrentRoom() + ' .body-chat');
        for (var i = 0; i < messages.length; i++) {
            var type = 'other';
            //Check if message from this user or not
            if(messages[i].username == hash){
                type = 'own';
            }

            // Create element
            $chatbox.append("<div class='w-message " + type + "-mes'><span>"+ messages[i].msg +"</span></div>");
        };
        // Scroll to bop
        if($chatbox[0]){
            $chatbox.animate({
                scrollTop: $chatbox[0].scrollHeight
            }, "fast");
        }
    });

    // ***************************************************************************
    // Templates and helpers
    // ***************************************************************************
    var templates = {};
    var getTemplate = function(path, callback) {
        var source;
        var template;

        // Check first if we've the template cached
        if (_.has(templates, path)) {
            if (callback) callback(templates[path]);
            // If not we get and compile it
        } else {
            $.ajax({
                url: path,
                success: function(data) {
                    source = data;
                    template = Handlebars.compile(source);
                    // Store compiled template in cache
                    templates[path] = template;
                    if (callback) callback(template);
                }
            });
        }
    }

    // Add room
    var addRoom = function(room) {
        getTemplate('js/templates/room.handlebars', function(template) {
            $('#rooms').append(template({'room':room}));

            // Toogle to created room
            var newroomtab = '[href="#'+room+'"]';
            $(newroomtab).click();

            // Get users connected to room
            socket.emit('getUsersInRoom', {'room':room});
        });
    };

    // Remove room
    var removeRoom = function(room) {
        var room_id = "#"+room;
        $(room_id).remove();
    };

    // Add message to room
    var addMessage = function(msg) {
        /*var type = 'other';
        //Check if message from this user or not
        if(msg.username == hash){
            type = 'own';
        }
        var $chatbox = $('#body_room_message_' + msg.room + ' .body-chat');

        // Create element
        $chatbox.append("<div class='w-message " + type + "-mes'><span>"+ msg.msg +"</span></div>");

        // Scroll and clear text
        if($chatbox[0]){
            $chatbox.animate({
                scrollTop: $chatbox[0].scrollHeight
            }, "fast");
        }*/
        getTemplate('js/templates/message.handlebars', function(template) {
         var room_messages = '#'+msg.room+' #room_messages';
         $(room_messages).append(template(msg));
         });
    };

    // Check if room exists
    var roomExists = function(room) {
        var room_selector = '#'+room;
        if ($(room_selector).length) {
            return true;
        } else {
            return false;
        }
    };

    // Get current room
    var getCurrentRoom = function() {
        /*var bodyTagCurrentActive = $('#accordion-chat .body-room-message.in');
        var textID = bodyTagCurrentActive.attr('id');
        var ID = null;
        if (textID) {
            ID = textID.split('_').pop();
        }
        return ID;*/

        /*var ID = $('li[id$="_tab"][class="active"]').attr('id');
        return ID.replace('_tab', '');*/
        console.log($('li[id$="_tab"][class="active"]').attr('data-id'));
        return $('li[id$="_tab"][class="active"]').attr('data-id');
    };

    // Get room name from input field
    var getRoomsName = function() {
        var ids = $('.w-room-message').map(function(){
            return this.id.split('_').pop();
        }).get();
        return ids;
    };

    // Get hash authenticated users
    var getCurrentUserHash = function() {
        hash = USER_HASH;
        return hash;
    };

    // Get message text from input field
    var getMessageText = function() {
        var text = $('#message_text').val();
        return text;
    };

    /**
     * Add latest message
     * @param {string} roomID   [hash]
     * @param {string} message  [latest chat content]
     */
    var addLatestMessage = function(msg){
        //alert(msg);
        var heading = $('#heading_room_message_' + msg.room);
        // Create element
        var latestMessage = heading.find('.latest-message');
        latestMessage.text(msg.msg);
        var latestMessageTime = heading.find('.w-time');
        var timeAgo = jQuery.timeago(msg.date);
        latestMessageTime.text(timeAgo);
    }

    var updateLatestMessage = function(roomArray){
        //get latest message
        socket.emit('getLatestMessage', {
            'rooms':roomArray
        });
    }
    /**
     * Make unread chat room
     * @param {string} roomID   [hash]
     */
    var makeNotSeenRoomChat = function(msg) {
        var currentIDActiveRoomChat = getCurrentRoom();

        if (currentIDActiveRoomChat != msg.room){
            $('#heading_room_message_' + msg.room + ' a.heading-room-message').addClass('not-seen');
            //make the badge ++
        }
    }



    // Add room tab
    var addRoomTab = function(room, roomName) {
        getTemplate('js/templates/room_tab.handlebars', function(template) {
            $('#rooms_tabs').append(template({'room':room, 'roomName':roomName}));
        });
    };

    // ***************************************************************************
    // Events
    // ***************************************************************************
    //On open chat
    $('#accordion-chat').on('shown.bs.collapse', '.w-room-message', function() {
        //call to get history message
        socket.emit('getChatHistoryMessage', {'room':getCurrentRoom()});
    });
    // Send new message
    $('#accordion-chat').delegate('.btn-submit-new-chat', 'click', function(eventObject){
        eventObject.preventDefault();
        var idRoomChat      = getCurrentRoom()
        var $chatTextarea   = $('#body_room_message_' + idRoomChat).find('.new-chatbox');

        if ($('#message_text').val() != "") {
            socket.emit('newMessage', {
                'room': getCurrentRoom(),
                'msg':getMessageText()
            });

            addMessage({
                'room': getCurrentRoom(),
                'username': hash,
                'msg':getMessageText()
            });
            addLatestMessage({
                'room': getCurrentRoom(),
                'username': hash,
                'msg':getMessageText(),
                'date': new Date()
            });
            $chatTextarea.val('');
        }
    });

    // Join new room
    $('#b_join_room').click(function(eventObject) {
        eventObject.preventDefault();
        socket.emit('subscribe', {'rooms':[getRoomsName()]});
    });

    // Leave current room
    $('#b_leave_room').click(function(eventObject) {
        eventObject.preventDefault();
        var currentRoom = getCurrentRoom();
        if (currentRoom != 'MainRoom') {
            socket.emit('unsubscribe', {'rooms':[getCurrentRoom()]});

            // Toogle to MainRoom
            $('[href="#MainRoom"]').click();
        } else {
            console.log('Cannot leave MainRoom, sorry');
        }
    });


    function createRoomId($userId1, $userId2) {
        if ($userId1 < $userId2) {
            return $userId1 + '_' + $userId2;
        }
        return $userId2 + '_' + $userId1;
    }


    $(".user-chat").click(function(e){
        var roomName = $(this).text();
        var roomId = createRoomId(USER_HASH, $(this).attr('id'));
        if (roomExists(roomId) == false) {
            addRoomTab(roomId, roomName);
            addRoom(roomId);
            socket.emit('subscribe', {'username':USERNAME,'user_id':USER_HASH,'rooms':[roomId]});
        }
    });

    // Send new message
    $('#b_send_message').click(function(eventObject) {
        eventObject.preventDefault();
        var msgText = getMessageText();
        if (msgText != "") {
            getTemplate('js/templates/message.handlebars', function(template) {
                var room_messages = '#'+getCurrentRoom()+' #room_messages';
                $(room_messages).append(template({'username':USERNAME,'msg':msgText}));
            });
            socket.emit('newMessage', {'room':getCurrentRoom(), 'msg':msgText});
        }
        $('#message_text').val("");
    });

})();





// ***************************************************************************
// Templates and helpers
// ***************************************************************************
/*
var templates = {};
var getTemplate = function(path, callback) {
    var source;
    var template;

    // Check first if we've the template cached
    if (_.has(templates, path)) {
        if (callback) callback(templates[path]);
        // If not we get and compile it
    } else {
        $.ajax({
            url: path,
            success: function(data) {
                source = data;
                template = Handlebars.compile(source);
                // Store compiled template in cache
                templates[path] = template;
                if (callback) callback(template);
            }
        });
    }
}
*/

