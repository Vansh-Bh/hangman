import 'package:flutter/material.dart';
import 'package:hangman/provider/game_state_provider.dart';
import 'package:hangman/utils/socket_client.dart';
import 'package:hangman/utils/socket_method.dart';
import 'package:hangman/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class GameTextField extends StatefulWidget {
  final VoidCallback onStartPressed;

  const GameTextField({required this.onStartPressed, Key? key})
      : super(key: key);

  @override
  State<GameTextField> createState() => _GameTextFieldState();
}

class _GameTextFieldState extends State<GameTextField> {
  final SocketMethods _socketMethods = SocketMethods();
  Map<String, dynamic>? playerMe;
  bool isBtn = true;
  late GameStateProvider? game;

  @override
  void initState() {
    super.initState();
    game = Provider.of<GameStateProvider>(context, listen: false);
    findPlayerMe(game!);
  }

  void findPlayerMe(GameStateProvider game) {
    for (var player in game.gameState['players']) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        setState(() {
          playerMe = player;
        });
        break;
      }
    }
  }

  void handleStart(GameStateProvider game) {
    if (playerMe != null) {
      _socketMethods.startTimer(playerMe!['_id'], game.gameState['id']);
      widget.onStartPressed();
      setState(() {
        isBtn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<GameStateProvider>(context);

    return playerMe != null && playerMe!['isPartyLeader'] == true && isBtn
        ? CustomButton(text: "START", onTap: () => handleStart(gameData!))
        : Container();
  }
}
