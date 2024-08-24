import 'package:flutter/material.dart';
import 'package:hangman/pages/join_room.dart';

class Multiplayer extends StatefulWidget {
  const Multiplayer({super.key});

  @override
  State<Multiplayer> createState() => _MultiplayerState();
}

class _MultiplayerState extends State<Multiplayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text('Hangman',
              style: TextStyle(
                fontFamily: 'Press-Start-2P',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 240,
                height: 80,
                child: FittedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/host-room');
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(10, 50),
                        backgroundColor: Colors.black),
                    child: const Text(
                      "Host Room",
                      style: TextStyle(
                          fontFamily: 'Press-Start-2P',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffae0001)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 240,
                height: 80,
                child: FittedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const JoinRoom()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(10, 50),
                        backgroundColor: Colors.black),
                    child: const Text(
                      "Join Room",
                      style: TextStyle(
                          fontFamily: 'Press-Start-2P',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffae0001)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
