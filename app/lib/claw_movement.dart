//TODO: add functionality
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final channel = WebSocketChannel.connect(
  Uri.parse('')
);

class ClawMovement{
  moveForward(){
    print("Foward"); //Debugging, remove later

    IO.Socket socket = IO.io('http://localhost:443',
        OptionBuilder()
            .setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('aaaaaaaaaaaaah');
    });
  }

  moveBackwards(){
    print("Backward"); //Debugging, remove later
  }

  moveRight(){
    print("Right"); //Debugging, remove later
  }

  moveLeft(){
    print("Left"); //Debugging, remove later
  }

  drop(BuildContext context){
    print("Drop"); //Debugging, remove later
    //TODO: add one for if they win and wait to find if they actually won
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: const Text("Good try!!!"),
            content: const Text("Would you like to try again?"),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text("Yes")
              ),
              // If user doesn't want to play again returns them
              // to the home page
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text("No")
              ),
            ],
          );
        }
    );
  }
}