var WebSocketServer = require('ws').Server;
var wss = new WebSocketServer({ port: 5000 });
console.log('yt-sync websocket opened on port 5000');

wss.on('connection', function connection(sender) {
    var obj = { kind: "Connection", url: "", play: false, seek: 0.0 };
    sender.send(JSON.stringify(obj));
    console.log("Client Connected: ", Date.now().toString());

    sender.on('message', function incoming(message) {
        console.log(message);
        wss.clients.forEach(function each(client) {
            if (client !== sender) {
                client.send(message);
            }
        });
    });
});
