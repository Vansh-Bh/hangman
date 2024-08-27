import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangman/provider/game_state_provider.dart';
import 'package:hangman/utils/alphabets.dart';
import 'package:hangman/utils/socket_method.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods = SocketMethods();
  final TextEditingController _wordController = TextEditingController();
  List<String> guessedAlphabets = [];
  List<String> correctGuesses = [];
  List<String> incorrectGuesses = [];
  int lives = 0;
  String fetchedWord = '';
  bool isGameStarted = false;
  bool isSubmitButtonVisible = true;
  final Stopwatch _stopwatch = Stopwatch();
  int trophies = 0;

  @override
  void initState() {
    super.initState();
    _loadPoints();
    // _socketMethods.updateTimer(context);
    _socketMethods.updateGame(context);
    _socketMethods.receiveWord(context, _onWordReceived);
    _socketMethods.gameLost(context, _showDialog, "YOU LOST!!");
    _socketMethods.gameWon(context, _showDialog, "YOU WON!!");
  }

  void _onWordReceived(String word) {
    print('Word received in _onWordReceived: $word');
    setState(() {
      fetchedWord = word.toUpperCase();
      guessedAlphabets.clear();
      correctGuesses.clear();
      incorrectGuesses.clear();
      lives = 0;
      isSubmitButtonVisible = false;
      isGameStarted = true;
      _stopwatch.reset();
      _stopwatch.start();
    });
    print('Game started with word: $fetchedWord');
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

  void alphabetCheck(String alphabet, String gameId) {
    print('Alphabet checked: $alphabet');
    print(fetchedWord);
    if (fetchedWord.isNotEmpty) {
      setState(() {
        if (fetchedWord.contains(alphabet)) {
          guessedAlphabets.add(alphabet);
          correctGuesses.add(alphabet);
          print('Correct guess: $alphabet');
        } else {
          incorrectGuesses.add(alphabet);
          print('Incorrect guess: $alphabet');
          if (lives < 5) {
            lives += 1;
          } else {
            _stopwatch.stop();
            _updatePoints(-3);
            _socketMethods.sendUnSuccessfulGuess(gameId);
            dialog("YOU LOST!");
          }
        }
      });

      // print(guessedAlphabets.length);

      // if (guessedAlphabets.length == fetchedWord.length) {
      //   print("yes, successfulGuess");
      //   _socketMethods.sendSuccessfulGuess(gameId);
      // } else {
      //   print("no successfulGuess");
      // }
    }

    bool isWon = true;
    for (int i = 0; i < fetchedWord.length; i++) {
      String char = fetchedWord[i];
      if (!guessedAlphabets.contains(char)) {
        isWon = false;
        break;
      }
    }
    if (isWon) {
      _stopwatch.stop();
      _updatePoints(5);
      _socketMethods.sendSuccessfulGuess(gameId);
      dialog(
          "YOU GUESSED RIGHT!! Time: ${_stopwatch.elapsed.inSeconds} seconds");
    }
  }

  void _showDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              _socketMethods.disconnect();
              _resetGameState();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Home', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void dialog(String message) {
    print('Dialog shown: $message');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              _socketMethods.disconnect();
              _resetGameState();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Home', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _resetGameState() {
    setState(() {
      guessedAlphabets.clear();
      correctGuesses.clear();
      incorrectGuesses.clear();
      fetchedWord = '';
      lives = 0;
      isGameStarted = false;
      isSubmitButtonVisible = true;
      _stopwatch.reset();
    });
  }

  void _submitWord(BuildContext context, String gameId, String word) {
    _socketMethods.sendWord(gameId, word);
    setState(() {
      isSubmitButtonVisible = false;
    });
  }

  void _startGame() {
    setState(() {
      isGameStarted = true;
    });
  }

  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      trophies = prefs.getInt('trophies') ?? 0;
    });
  }

  Future<void> _updatePoints(int change) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      trophies += change;
      prefs.setInt('trophies', trophies);
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    // final clientStateProvider = Provider.of<ClientStateProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffae0001),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Hangman",
              style: TextStyle(
                fontFamily: 'Press-Start-2P',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              "Trophies: $trophies",
              style: const TextStyle(
                fontFamily: 'Press-Start-2P',
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              if (!isGameStarted && game.gameState['isJoin'])
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      TextField(
                        controller: _wordController,
                        decoration: InputDecoration(
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: 'Enter a 5-letter word',
                            hintStyle: const TextStyle(fontSize: 15)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        onPressed: () {
                          _submitWord(context, game.gameState['id'],
                              _wordController.text);
                        },
                        child: Text(isSubmitButtonVisible
                            ? 'Submit Word'
                            : 'Submitting...'),
                      ),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                          child: Text(
                            'Game Code: ${game.gameState['id']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                              text: game.gameState['id'],
                            )).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Game Code - ${game.gameState['id']} copied to clipboard!',
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      ])
                    ],
                  ),
                )
              else if (isGameStarted)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image(
                          image:
                              AssetImage('assets/hangman_img${lives + 1}.jpg'),
                        ),
                        Text(
                          'Lives: ${(6 - lives).toString()}',
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
                                  alphabetCheck(e, game.gameState['id']);
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
