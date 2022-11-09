//GPIO control so the raspberry pi can control the switches
const gpio = require('onoff').Gpio;

//Controller bindings to gpio pins
let UP = new gpio(4, 'out');
let DOWN = new gpio(5, 'out');
let LEFT = new gpio(6, 'out');
let RIGHT = new gpio(7, 'out');
let DROP = new gpio(8, 'out');
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

function getip() {
    return new Promise((resolve, reject) => {
        const timer = setTimeout(() => {
            return { address: undefined, error: 'IP connection timed out!' };
        }, 3000);
        http.get({'host': 'api.ipify.org', 'port': 80, 'path': '/'}, function (res) {
            res.on('data', function(ip) {
                clearTimeout(timer);
                return { address: ip };
            });
        });
    });
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
//const firebase = require('firebase-admin');
const app = express()
const https = require('https');
const http = require('http'); //http is only for outbound api calls and should NEVER handle any client server data

//perpare app to handle incoming data
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
//create server with https certificates
const server = https.createServer({
    key: fs.readFileSync(__dirname + '/SSL/private.key', 'utf8'),
    cert: fs.readFileSync(__dirname + '/SSL/certificate.crt', 'utf8')
}, app);

//generic post handler
app.post('/', async function (req, res) {
    let params = req.body.params;
    res.send("");
    res.end();
});

//generic get handler
app.get('/', async function (req, res) {
    res.send("");
    res.end();
});

//get queue and current player
app.get('/queue', async function(req, res) {
    res.send(JSON.stringify({ list: queue, current: player }));
    res.end();
});

//report player info
app.post('/play', async function (req, res) {
    let params = req.body.params;
    res.send("");
    res.end();
});

//get play statistics
app.get('/statistics', async function (req, res) {
    res.send(JSON.stringify({}));
    res.end();
});

//get claw location (note that client side webserver ip is unreliable due to webproxy)
app.get('/location', async function (req, res) {
    res.send(await getip());
    res.end();
});
console.log(`Web API Initalization Done! Beginning Websocket Initalization...`);

//create websocket endpoint on the server
const wss = require('socket.io')(server, {
    cors: {
        origin: "*",
    }
});

//websocket client handler
wss.on('connection', async (ws) => {
    queue.push(ws.id);
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
        UP.writeSync(1);
    });
    ws.on('down', () => {
        DOWN.writeSync(1);
    });
    ws.on('left', () => {
        LEFT.writeSync(1);
    });
    ws.on('right', () => {
        RIGHT.writeSync(1);
    });
    ws.on('drop', async () => {
        DROP.writeSync(1);
        console.log(`[${ws.id}] - Dropped Claw! Game Over!`);
        await sleep(1000);
        DROP.writeSync(0);
        ws.close();
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

app.listen(9110); //Start webserver on port

console.log(`Websocket Initialization Done! Webserver started on port 9110!`);

