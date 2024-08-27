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
    _socketMethods.updateGame(context);
    _socketMethods.receiveWord(context, _onWordReceived);
    _socketMethods.gameLost(context, _showDialog, "YOU LOST!!");
    _socketMethods.gameWon(context, _showDialog, "YOU WON!!");
  }

  void _onWordReceived(String word) {
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
    setState(() {
      if (fetchedWord.contains(alphabet)) {
        guessedAlphabets.add(alphabet);
        correctGuesses.add(alphabet);
      } else {
        incorrectGuesses.add(alphabet);
        if (lives < 5) {
          lives += 1;
        } else {
          _stopwatch.stop();
          _updatePoints(-3);
          _socketMethods.sendUnsuccessfulGuess(gameId);
          dialog("YOU LOST!");
        }
      }
    });

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
        title: Text(text, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              _socketMethods.disconnect();
              _resetGameState();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Home', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void dialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(message, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              _socketMethods.disconnect();
              _resetGameState();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Home', style: TextStyle(color: Colors.white)),
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

    return Scaffold(
      backgroundColor: const Color(0xff212121),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Hangman",
              style: TextStyle(
                fontFamily: 'Press-Start-2P',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              "Trophies: $trophies",
              style: const TextStyle(
                fontFamily: 'Press-Start-2P',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isGameStarted && game.gameState['isJoin'])
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${game.gameState['players'].isNotEmpty ? game.gameState['players'][0]['nickname'] : 'Player1'} vs ',
                                  style: const TextStyle(
                                    fontFamily: 'Press-Start-2P',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  game.gameState['players'].length > 1 &&
                                          game.gameState['players'][1] != null
                                      ? game.gameState['players'][1]['nickname']
                                      : 'Player2',
                                  style: const TextStyle(
                                    fontFamily: 'Press-Start-2P',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextField(
                          controller: _wordController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[800],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: 'Enter a 5-letter word',
                            hintStyle: const TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(Icons.text_fields,
                                color: Colors.white70),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            _submitWord(context, game.gameState['id'],
                                _wordController.text);
                          },
                          child: Text(isSubmitButtonVisible
                              ? 'Submit Word'
                              : 'Submitting...'),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Game Code: ${game.gameState['id']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, color: Colors.white),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                        text: game.gameState['id']))
                                    .then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Game Code - ${game.gameState['id']} copied to clipboard!',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              else if (isGameStarted)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.all(16.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/hangman_img${lives + 1}.png',
                              height: MediaQuery.sizeOf(context).height * 0.3,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          'Lives: ${(6 - lives).toString()}',
                          style: const TextStyle(
                            fontFamily: 'Press-Start-2P',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 35),
                        Text(
                          wordChange(),
                          style: const TextStyle(
                            fontFamily: 'Press-Start-2P',
                            fontSize: 24,
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
                              buttonColor = Colors.red;
                            } else {
                              buttonColor = Colors.grey[800]!;
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  alphabetCheck(e, game.gameState['id']);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: buttonColor,
                                    borderRadius: BorderRadius.circular(12.0),
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
