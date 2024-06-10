import 'package:flutter/material.dart';
import 'package:hangman/pages/mulitplayer.dart';
import 'package:hangman/pages/singleplayer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              Image.asset('assets/hangman.jpg'),
              SizedBox(
                width: 240,
                height: 80,
                child: FittedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Singleplayer()),
                      );
                    },
                    child: Text(
                      "Offline",
                      style: TextStyle(
                        fontFamily: 'Press-Start-2P',
                        fontSize: 30,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Multiplayer()),
                      );
                    },
                    child: Text(
                      "Multiplayer",
                      style: TextStyle(
                        fontFamily: 'Press-Start-2P',
                        fontSize: 19,
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
