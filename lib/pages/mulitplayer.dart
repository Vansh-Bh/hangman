import 'package:flutter/material.dart';

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
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hangman",
              ),
            ],
          ),
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
                    onPressed: () {},
                    child: Text(
                      "Host Room",
                      style: TextStyle(
                        fontFamily: 'Press-Start-2P',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(minimumSize: Size(10, 50)),
                  ),
                ),
              ),
              SizedBox(
                width: 240,
                height: 80,
                child: FittedBox(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Join Room",
                      style: TextStyle(
                        fontFamily: 'Press-Start-2P',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(minimumSize: Size(10, 50)),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
