//TODO: add functionality
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';

class ClawMovement{
  moveForward(){
    print("Foward"); //Debugging, remove later
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
    //TODO: add one for if they win
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
              TextButton(
                  onPressed: (){
                    SystemNavigator.pop();
                  },
                  child: const Text("No")
              ),
            ],
          );
        }
    );
  }
}