import './App.css';
import React, { useEffect, useState } from 'react';
import io from 'socket.io-client';

function App() {
  const [socket, setSocket] = useState(null);
  useEffect(() => {
    const connection = io(`https://10.102.61.3:9110`);
    connection.on('status', (details) => {
      alert(details);
    });
    connection.on('queue', (details) => {
      alert(details);
    });
    setSocket(connection);
    return () => {
      connection.close();
    }
  }, [setSocket]);




  return (
    <div className="App">
      { socket ? 
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
