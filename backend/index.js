//GPIO control so the raspberry pi can control the switches
const gpio = require('onoff').Gpio;

//Controller bindings to gpio pins
let UP = new gpio(4, 'out');
let DOWN = new gpio(5, 'out');
let LEFT = new gpio(6, 'out');
let RIGHT = new gpio(7, 'out');
let DROP = new gpio(8, 'out');

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

//Here we start adding web functionality
const express = require('express');
const bodyParser = require('body-parser');
const uuid = require('uuid');
const cors = require('cors');
const firebase = require('firebase-admin');
const app = express()
const https = require('https');

//perpare app to handle incoming data
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
//create server with https certificates
const server = https.createServer({
    key: undefined,
    ca: undefined,
    cert: undefined
}, app);
//create websocket endpoint on the server
const wss = require('socket.io').listen(app, { cors: { origin: '*' }});

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

app.get('/queue', async function(req, res) {
    res.send(JSON.stringify({ list: queue, current: player }));
    res.end();
});

//websocket client handler
wss.on('connection', async (ws) => {
    queue.push(ws.id);
    while (queue[0] != ws.id)
    {
        wss.emit("queue", JSON.stringify({ status: queue, current: player }));
        await sleep(1000);
    }
    player = ws.id;
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
        await sleep(1000);
        DROP.writeSync(0);
        ws.close();
        queue.splice(0, 1);
    });
    ws.on('disconnect', async () => {
        if (ws.id == player)
        {
            DROP.writeSync(1);
            await sleep(1000);
            DROP.writeSync(0);
            clear();
            queue.splice(0, 1);
        }
        else
        {
            queue.splice(queue.indexOf(ws.id), 1);
        }
    });
    ws.emit('status', "play");
});

app.listen(9110); //Start webserver on port

