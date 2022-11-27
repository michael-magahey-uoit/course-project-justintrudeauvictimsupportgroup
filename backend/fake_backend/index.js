const express = require('express');
const https = require('https');
const http = require('http');
const io = require('socket.io');
const cors = require('cors');
const fs = require('fs');

const privateKey = fs.readFileSync('../SSL/backend.key', 'utf8');
const certificate = fs.readFileSync('../SSL/backend.crt', 'utf8');
const credentials = { key: privateKey, cert: certificate };
const app = express();
app.use(cors());

const server = https.createServer(credentials, app);
const insecure = http.createServer(app);

let queue = [];
let player = undefined;

function sleep(ms) { 
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    })
}

const wss = io(server, {
    cors: {
        origin: '*',
    },
});

const ws = io(insecure, {
    cors: {
        origin: '*',
    },
});

app.get('/', async (req, res) => {
    res.send("Site Working!");
    res.end();
});

app.get('/queue', async (req, res) => {
    console.log('[!] - Queue Requested!');
    res.send(JSON.stringify({ status: queue, current: player }));
    res.end();
});

wss.on('connection', async (socket) => {
    queue.push(ws.id);
    console.log(`[${ws.id}] - New Client ${ws.id}!`);
    while (queue[0] != ws.id)
    {
        wss.emit('queue', JSON.stringify({ status: queue, current: player }));
        await sleep(1000);
    }
    player = ws.id;
    console.log(`[${ws.id}] - Now Playing!`);
    ws.on('clear', () => {
        console.log(`[DBG] - Controls Cleared {${player}}`);
    });
    ws.on('up', () => {
        console.log(`[DBG] - Control UP {${player}}`);
    });
    ws.on('down', () => {
        console.log(`[DBG] - Control DOWN {${player}}`);
    });
    ws.on('left', () => {
        console.log(`[DBG] - Control LEFT {${player}}`);
    });
    ws.on('right', () => {
        console.log(`[DBG] - Control RIGHT {${player}}`);
    });
    ws.on('drop', () => {
        console.log(`[DBG] - Control DROP {${player}}`);
    });
    ws.on('disconnect', async () => {
        if (ws.id == player)
        {
            console.log(`[${ws.id}] - Playing entity disconnected!, Auto drop claw here`);
            await sleep(1000);
            queue.splice(0, 1);
        }
        else
        {
            console.log(`[${ws.id}] - Non playing entity disconnected!`);
            queue.splice(queue.indexOf(ws.id), 1);
        }
    });
    ws.emit('status', "player");
});

ws.on('connection', async (socket) => {
    queue.push(socket.id);
    console.log(`[${socket.id}] - New Client ${socket.id}!`);
    while (queue[0] != socket.id)
    {
        wss.emit('queue', JSON.stringify({ status: queue, current: player }));
        await sleep(1000);
    }
    player = socket.id;
    console.log(`[${ws.id}] - Now Playing!`);
    ws.on('clear', () => {
        console.log(`[DBG] - Controls Cleared {${player}}`);
    });
    ws.on('up', () => {
        console.log(`[DBG] - Control UP {${player}}`);
    });
    ws.on('down', () => {
        console.log(`[DBG] - Control DOWN {${player}}`);
    });
    ws.on('left', () => {
        console.log(`[DBG] - Control LEFT {${player}}`);
    });
    ws.on('right', () => {
        console.log(`[DBG] - Control RIGHT {${player}}`);
    });
    ws.on('drop', () => {
        console.log(`[DBG] - Control DROP {${player}}`);
    });
    ws.on('dbg', (message) => {
        console.log(`[DBG] - Client Packet: "${message}"`);
    });
    ws.on('disconnect', async () => {
        if (ws.id == player)
        {
            console.log(`[${ws.id}] - Playing entity disconnected!, Auto drop claw here`);
            await sleep(1000);
            queue.splice(0, 1);
        }
        else
        {
            console.log(`[${ws.id}] - Non playing entity disconnected!`);
            queue.splice(queue.indexOf(ws.id), 1);
        }
    });
    ws.emit('status', "player");
});

server.listen(443);
insecure.listen(80);

console.log(`Webserver Started on 443 and 80!`);