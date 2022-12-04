const express = require('express');
const https = require('https');
const http = require('http');
const io = require('socket.io');
const cors = require('cors');
const fs = require('fs');
const { Socket } = require('socket.io-client');

const privateKey = fs.readFileSync('../SSL/backend.key', 'utf8');
const certificate = fs.readFileSync('../SSL/backend.crt', 'utf8');
const credentials = { key: privateKey, cert: certificate };
const app = express();
app.use(cors());

const server = https.createServer(credentials, app);
const insecure = http.createServer(app);

let queue = [];
let player = "";

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

wss.on('connection', async (socket) => {
    queue.push(socket.id);
    //We need this incase the queue is empty, because if its empty, we have to send the status
    //before entering our wait loop, but player is only set after the wait, so we have to use
    //the queue if its empty.
    if (queue[0] == socket.id)
    {
        socket.emit('queue', JSON.stringify({ status: queue, current: queue[0] }));
    }
    else { socket.emit('queue', JSON.stringify({ status: queue, current: player })); }
    console.log(`[${socket.id}] - New Client ${socket.id}!`);
    while (queue[0] != socket.id)
    {
        wss.emit('queue', JSON.stringify({ status: queue, current: player }));
        print(JSON.stringify({ status: queue, current: player }));
        await sleep(1000);
    }
    player = socket.id;
    console.log(`[${socket.id}] - Now Playing!`);
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
        if (socket.id == player)
        {
            console.log(`[${socket.id}] - Playing entity disconnected!, Auto drop claw here`);
            await sleep(1000);
            queue.splice(0, 1);
        }
        else
        {
            console.log(`[${socket.id}] - Non playing entity disconnected!`);
            queue.splice(queue.indexOf(socket.id), 1);
        }
    });
    ws.emit('status', "player");
});

ws.on('connection', async (socket) => {
    queue.push(socket.id);
    //We need this incase the queue is empty, because if its empty, we have to send the status
    //before entering our wait loop, but player is only set after the wait, so we have to use
    //the queue if its empty.
    if (queue[0] == socket.id)
    {
        socket.emit('queue', JSON.stringify({ status: queue, current: queue[0] }));
    }
    else { socket.emit('queue', JSON.stringify({ status: queue, current: player })); }
    while (queue[0] != socket.id)
    {
        socket.emit('queue', JSON.stringify({ status: queue, current: player }));
        print(JSON.stringify({ status: queue, current: player }));
        await sleep(1000);
    }
    player = socket.id;
    console.log(`[${socket.id}] - Now Playing!`);
    socket.on('clear', () => {
        console.log(`[DBG] - Controls Cleared {${player}}`);
    });
    socket.on('up', () => {
        console.log(`[DBG] - Control UP {${player}}`);
    });
    socket.on('down', () => {
        console.log(`[DBG] - Control DOWN {${player}}`);
    });
    socket.on('left', () => {
        console.log(`[DBG] - Control LEFT {${player}}`);
    });
    socket.on('right', () => {
        console.log(`[DBG] - Control RIGHT {${player}}`);
    });
    socket.on('drop', async () => {
        console.log(`[DBG] - Control DROP {${player}}`);
        await sleep(1000);
        socket.disconnect();
        queue.splice(0, 1);
        console.log(`[DBG] - Player ${socket.id} Game Over!`);
    });
    socket.on('dbg', (message) => {
        console.log(`[DBG] - Client Packet: "${message}"`);
    });
    socket.on('disconnect', async () => {
        if (socket.id == player)
        {
            console.log(`[${socket.id}] - Playing entity disconnected!, Auto drop claw here`);
            await sleep(1000);
            queue.splice(0, 1);
        }
        else
        {
            console.log(`[${socket.id}] - Non playing entity disconnected!`);
            queue.splice(queue.indexOf(socket.id), 1);
        }
    });
    socket.emit('status', "player");
});

server.listen(443);
insecure.listen(80);

console.log(`Webserver Started on 443 and 80!`);