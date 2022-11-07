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

//Global placeholders to allow us to bypass some weird threading tactics
let order = [];
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
const wss = require('socket.io').listen(app);

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

//websocket client handler
wss.on('connection', async (ws) => {
    const id = ws.id;
    ws.send("");
});

app.listen(9110); //Start webserver on port

