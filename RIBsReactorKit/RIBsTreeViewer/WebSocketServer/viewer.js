var server = require('ws').Server;
var s = new server({ port: 8080 });

s.on('connection', function (ws) {
    ws.on('message', function (message) {
        console.log(message);
        s.clients.forEach(function (client) {
            client.send(message);
        });
    });
    ws.on('close', function () {
    });
});
