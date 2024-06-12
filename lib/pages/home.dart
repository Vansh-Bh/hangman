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
                  "Singleplayer",
                  style: TextStyle(
                      fontFamily: 'Press-Start-2P',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffae0001)),
                ),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(10, 50), backgroundColor: Colors.black),
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
                      color: Color(0xffae0001)),
                ),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(10, 50), backgroundColor: Colors.black),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
