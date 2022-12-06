//GPIO control so the raspberry pi can control the switches
const gpio = require('onoff').Gpio;

//Controller bindings to gpio pins
let UP = new gpio(24, 'out');
let DOWN = new gpio(5, 'out');
let LEFT = new gpio(27, 'out');
let RIGHT = new gpio(25, 'out');
let DROP = new gpio(26, 'out'); //Incorrect GPIO cause of weird network bug
console.log(`GPIO Setup Complete!`);

//Simple force sleep function
function sleep(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}

//Fast clear of inputs to clean up after a game
function clear() {
    UP.writeSync(0);
    DOWN.writeSync(0);
    LEFT.writeSync(0);
    RIGHT.writeSync(0);
    DROP.writeSync(0);
}
//Global placeholders to allow us to bypass some weird threading tactics
let queue = [];
let player = undefined;
console.log(`Globals Declared! Beginning Web Initialization...`);

//Here we start adding web functionality
const express = require('express');
const bodyParser = require('body-parser');
const uuid = require('uuid');
const cors = require('cors');
const fs = require('fs');
const app = express()
const https = require('https');
const http = require('http'); //http is only for outbound api calls and should NEVER handle any client server data
const credentials = { key: fs.readFileSync('./SSL/backend.key', 'utf8'), cert: fs.readFileSync('./SSL/backend.crt', 'utf8') }


//perpare app to handle incoming data
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors());
//create server with https certificates
const server = https.createServer(credentials, app);
const insecure_server = http.createServer(app);

app.get('/', function (req, res) {
    res.send(JSON.stringify({ status: "OK", message: "Welcome to the Claw Controller Backend!" }));
    res.end();
});

//get queue and current player
app.get('/queue', async function(req, res) {
    console.log('[!] - Queue Requested!');
    res.send(JSON.stringify({ list: queue, current: player }));
    res.end();
});

//get claw location (note that client side webserver ip is unreliable due to webproxy)
app.get('/location', async (req, res) => {
    console.log('[!] - Location Requested!');
    await http.get({'host': 'api.ipify.org', 'port': 80, 'path': '/'}, function (resp) {
        resp.on('data', function(ip)
        {
            res.send(JSON.stringify({ ip: `${ip}` }));
            res.end();
        });
    });
});
console.log(`Web API Initalization Done! Beginning Websocket Initalization...`);

//create websocket endpoint on the server
const wss = require('socket.io')(server, {
    cors: {
        origin: "*",
    }
});

const insecure_wss = require('socket.io')(insecure_server, {
    cors: {
        origin: "*",
    }
});

//websocket client handler
wss.on('connection', async (ws) => {
    queue.push(ws.id);
    //We need this incase the queue is empty, because if its empty, we have to send the status
    //before entering our wait loop, but player is only set after the wait, so we have to use
    //the queue if its empty.
    if (queue[0] == ws.id)
    {
        ws.emit('queue', JSON.stringify({ status: queue, current: queue[0] }));
    }
    else { ws.emit('queue', JSON.stringify({ status: queue, current: player })); }
    console.log(`[${ws.id}] - New Client ${ws.id}!`);
    while (queue[0] != ws.id)
    {
        wss.emit("queue", JSON.stringify({ status: queue, current: player }));
        await sleep(1000);
    }
    player = ws.id;
    console.log(`[${ws.id}] - Now Playing!`);
    ws.on('clear', () => {
        clear();
    });
    ws.on('up', () => {
		console.log(`[${ws.id}] -> Up`);
        UP.writeSync(1);
    });
    ws.on('down', () => {
		console.log(`[${ws.id}] -> Down`);
        DOWN.writeSync(1);
    });
    ws.on('left', () => {
		console.log(`[${ws.id}] -> Left`);
        LEFT.writeSync(1);
    });
    ws.on('right', () => {
		console.log(`[${ws.id}] -> Right`);
        RIGHT.writeSync(1);
    });
    ws.on('drop', async () => {
        DROP.writeSync(1);
        console.log(`[${ws.id}] - Dropped Claw! Game Over!`);
        await sleep(1000);
        DROP.writeSync(0);
        ws.disconnect();
        queue.splice(0, 1);
    });
    ws.on('disconnect', async () => {
        if (ws.id == player)
        {
            DROP.writeSync(1);
            console.log(`[${ws.id}] - Player Disconnected! Dropping Claw...`);
            await sleep(1000);
            DROP.writeSync(0);
            clear();
            queue.splice(0, 1);
        }
        else
        {
            console.log(`[${ws.id}] - Player Disconnected!`);
            queue.splice(queue.indexOf(ws.id), 1);
        }
    });
    ws.emit('status', "play");
});

insecure_wss.on('connection', async (ws) => {
    queue.push(ws.id);
    //We need this incase the queue is empty, because if its empty, we have to send the status
    //before entering our wait loop, but player is only set after the wait, so we have to use
    //the queue if its empty.
    if (queue[0] == ws.id)
    {
        ws.emit('queue', JSON.stringify({ status: queue, current: queue[0] }));
    }
    else { ws.emit('queue', JSON.stringify({ status: queue, current: player })); }
    console.log(`[${ws.id}] - New Client ${ws.id}!`);
    while (queue[0] != ws.id)
    {
        wss.emit("queue", JSON.stringify({ status: queue, current: player }));
        await sleep(1000);
    }
    player = ws.id;
    console.log(`[${ws.id}] - Now Playing!`);
    ws.on('clear', () => {
        clear();
    });
    ws.on('up', () => {
		console.log(`[${ws.id}] -> Up`);
        UP.writeSync(1);
    });
    ws.on('down', () => {
		console.log(`[${ws.id}] -> Down`);
        DOWN.writeSync(1);
    });
    ws.on('left', () => {
		console.log(`[${ws.id}] -> Left`);
        LEFT.writeSync(1);
    });
    ws.on('right', () => {
		console.log(`[${ws.id}] -> Right`);
        RIGHT.writeSync(1);
    });
    ws.on('drop', async () => {
        DROP.writeSync(1);
        console.log(`[${ws.id}] - Dropped Claw! Game Over!`);
        await sleep(1000);
        DROP.writeSync(0);
        ws.disconnect();
        queue.splice(0, 1);
    });
    ws.on('disconnect', async () => {
        if (ws.id == player)
        {
            DROP.writeSync(1);
            console.log(`[${ws.id}] - Player Disconnected! Dropping Claw...`);
            await sleep(1000);
            DROP.writeSync(0);
            clear();
            queue.splice(0, 1);
        }
        else
        {
            console.log(`[${ws.id}] - Player Disconnected!`);
            queue.splice(queue.indexOf(ws.id), 1);
        }
    });
    ws.emit('status', "play");
});

server.listen(443); //Start webserver on port
insecure_server.listen(80);

console.log(`Websocket Initialization Done! Webserver started on port 443/80!`);

