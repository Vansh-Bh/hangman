import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hangman/utils/alphabets.dart';

class Singleplayer extends StatefulWidget {
  const Singleplayer({Key? key}) : super(key: key);

  @override
  State<Singleplayer> createState() => _SingleplayerState();
}

class _SingleplayerState extends State<Singleplayer> {
  List<String>? words;
  String fetchedWord = "";
  List<String> guessedAlphabets = [];
  Set<String> correctGuesses = {};
  Set<String> incorrectGuesses = {};
  int lives = 0;
  List Images = [
    "assets/hangman_img1.jpg",
    "assets/hangman_img2.jpg",
    "assets/hangman_img3.jpg",
    "assets/hangman_img4.jpg",
    "assets/hangman_img5.jpg",
    "assets/hangman_img6.jpg",
    "assets/hangman_img7.jpg",
  ];

  dialog(String title) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Color(0xffae0001), fontSize: 30),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  width: 130,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.pop(context);
                      resetGame();
                    },
                    backgroundColor: Color(0xffae0001),
                    label: Text(
                      "Play Again",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  Future<void> _fetchWords() async {
    final response = await http
        .get(Uri.parse('https://random-word-api.herokuapp.com/word?length=5'));

    if (response.statusCode == 200) {
      List<dynamic> wordList = jsonDecode(response.body);
      setState(() {
        words = wordList.map((w) => w.toString().toUpperCase()).toList();
        fetchedWord = words!.isNotEmpty ? words![0] : "";
        print(fetchedWord);
      });
    } else {
      throw Exception('Failed to load words');
    }
  }

  void resetGame() {
    setState(() {
      lives = 0;
      guessedAlphabets.clear();
      correctGuesses.clear();
      incorrectGuesses.clear();
      _fetchWords();
    });
  }

  String wordChange() {
    String displayWord = "";
    if (fetchedWord.isNotEmpty) {
      for (int i = 0; i < fetchedWord.length; i++) {
        String char = fetchedWord[i];
        if (guessedAlphabets.contains(char)) {
          displayWord += char + " ";
        } else {
          displayWord += "_ ";
        }
      }
    }
    return displayWord;
  }

  void alphabetCheck(String alphabet) {
    if (fetchedWord.isNotEmpty) {
      setState(() {
        if (fetchedWord.contains(alphabet)) {
          guessedAlphabets.add(alphabet);
          correctGuesses.add(alphabet);
        } else {
          incorrectGuesses.add(alphabet);
          if (lives < 5) {
            lives += 1;
          } else {
            dialog("YOU LOST!!");
          }
        }
      });
    }
    bool isWon = true;
    for (int i = 0; i < fetchedWord.length; i++) {
      String char = fetchedWord[i];
      if (!guessedAlphabets.contains(char)) {
        setState(() {
          isWon = false;
        });
        break;
      }
    }
    if (isWon) {
      dialog("YOU WON!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffae0001),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          "Hangman",
          style: TextStyle(
            fontFamily: 'Press-Start-2P',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Image(image: AssetImage(Images[lives])),
            Text(
              'lives : ${(6 - lives).toString()}',
              style: const TextStyle(
                fontFamily: 'Press-Start-2P',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Text(
              wordChange(),
              style: const TextStyle(
                fontFamily: 'Press-Start-2P',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: alphabets.map((e) {
                Color buttonColor;
                if (correctGuesses.contains(e)) {
                  buttonColor = Colors.green;
                } else if (incorrectGuesses.contains(e)) {
                  buttonColor = Colors.grey;
                } else {
                  buttonColor = Colors.transparent;
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      alphabetCheck(e);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Center(
                        child: Text(
                          e,
                          style: TextStyle(
                            fontFamily: 'Press-Start-2P',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
