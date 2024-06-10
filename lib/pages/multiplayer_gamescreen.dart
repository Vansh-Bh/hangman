import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangman/provider/client_state_provider.dart';
import 'package:hangman/provider/game_state_provider.dart';
import 'package:hangman/utils/socket_method.dart';
import 'package:hangman/widgets.dart/game_text_field.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateTimer(context);
    _socketMethods.updateGame(context);
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    final clientStateProvider = Provider.of<ClientStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
          child: Center(
              child: Column(children: [
        Chip(
          label: Text(
            clientStateProvider.clientState['timer']['msg'].toString(),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Text(
          clientStateProvider.clientState['timer']['countDown'].toString(),
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        game.gameState['isJoin']? ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: TextField(
            readOnly: true,
            onTap: () {
              Clipboard.setData(ClipboardData(
                text: game.gameState['id'],
              )).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Game Code copied to clickboard!'),
                  ),
                );
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              fillColor: const Color(
                0xffF5F5FA,
              ),
              hintText: 'Click to Copy Game Code',
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ): Container(),
      ]))),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(8),
        child: GameTextField(),
      ),
    );
  }
}
