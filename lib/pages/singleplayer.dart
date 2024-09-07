import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hangman/utils/alphabets.dart';
import 'package:lottie/lottie.dart';

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
  bool isLoading = true; // Track loading state

  List<String> images = [
    "assets/hangman_img1.png",
    "assets/hangman_img2.png",
    "assets/hangman_img3.png",
    "assets/hangman_img4.png",
    "assets/hangman_img5.png",
    "assets/hangman_img6.png",
    "assets/hangman_img7.png",
  ];

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
        isLoading = false; // Update loading state
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
      isLoading = true; // Set loading state to true
    });
    _fetchWords(); // Fetch new words
  }

  String wordChange() {
    String displayWord = "";
    if (fetchedWord.isNotEmpty) {
      for (int i = 0; i < fetchedWord.length; i++) {
        String char = fetchedWord[i];
        if (guessedAlphabets.contains(char)) {
          displayWord += "$char ";
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
          if (lives < 6) {
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

  void dialog(String title) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            height: 220,
            width: 300,
            decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.grey[400]!)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(color: Color(0xffae0001), fontSize: 30),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 130,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.pop(context);
                          resetGame();
                        },
                        backgroundColor: const Color(0xffae0001),
                        label: const Text(
                          "Play Again",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 130,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        },
                        backgroundColor: const Color(0xffae0001),
                        label: const Text(
                          "Home",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (title == "YOU LOST!!") Text('The word was $fetchedWord')
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: isLoading
            ? Lottie.asset(
                'assets/animations/loading_2.json')
            : Column(
                children: [
                  Image.asset(images[lives],
                      height: MediaQuery.sizeOf(context).height * 0.4,
                      fit: BoxFit.cover),
                  Text(
                    'Lives : ${(6 - lives).toString()}',
                    style: const TextStyle(
                      fontFamily: 'Press-Start-2P',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    wordChange(),
                    style: const TextStyle(
                      fontFamily: 'Press-Start-2P',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  GridView.count(
                    crossAxisCount: 7,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                                style: const TextStyle(
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
