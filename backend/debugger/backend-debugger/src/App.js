import './App.css';
import React, { useEffect, useState } from 'react';
import io from 'socket.io-client';

function App() {
  const [socket, setSocket] = useState(null);
  const [isConnected, setConnected] = useState(false);

  useEffect(() => {
<<<<<<< HEAD
    const connection = io(`https://08b044152cf365.lhr.life/`);
=======
    const connection = io(`http://10.102.61.3`);
    connection.on('connect', () => {
      setSocket(connection);
      setConnected(true);
    });
>>>>>>> ada6c07dc5f938ab08cbacfffae9ef9afe159a5c
    connection.on('status', (details) => {
      alert(details);
    });
    connection.on('queue', (details) => {
      alert(details);
    });
    connection.on('disconnect', () => {
      setConnected(false);
    });
    setSocket(connection);
    return () => {
      connection.off('connect');
      connection.off('status');
      connection.off('queue');
      connection.off('disconnect');
      connection.close();
    }
  }, []);




  return (
    <div className="App">
      { isConnected ? 
      (
        <>
          <div className="game">
            <div className="upArrow" onMouseEnter={() => socket.emit("up")} onMouseLeave={() => socket.emit("clear")} />
            <div className="leftArrow inline" onMouseEnter={() => socket.emit("left")} onMouseLeave={() => socket.emit("clear")} />
            <div className="rightArrow inline" onMouseEnter={() => socket.emit("right")} onMouseLeave={() => socket.emit("clear")} />
            <div className="downArrow" onMouseEnter={() => socket.emit("down")} onMouseLeave={() => socket.emit("clear")} />
            <div className="dropButton" onMouseEnter={() => socket.emit("drop")} onMouseLeave={() => socket.emit("clear")} /> 
          </div>
        </>
      ) : (
        <>
          <div>Not Connected!</div>
        </>
      )}
    </div>
  );
}

export default App;
