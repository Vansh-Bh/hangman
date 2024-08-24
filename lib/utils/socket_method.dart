import 'package:flutter/material.dart';
import 'package:hangman/provider/game_state_provider.dart';
import 'package:hangman/utils/socket_client.dart';
import 'package:provider/provider.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;
  bool _isPlaying = false;

  void disconnect() {
    _socketClient.disconnect();
    _socketClient.close();
  }

  createGame(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('host-game', {
        'nickname': nickname,
      });
    }
  }

  joinGame(String gameId, String nickname) {
    if (nickname.isNotEmpty && gameId.isNotEmpty) {
      _socketClient.emit('join-game', {
        'nickname': nickname,
        'gameId': gameId,
      });
    }
  }

  updateGameListener(BuildContext context) {
    _socketClient.on('updateGame', (data) {
      final gameStateProvider =
          Provider.of<GameStateProvider>(context, listen: false)
              .updateGameState(
        id: data['_id'],
        players: data['players'],
        isJoin: data['isJoin'],
        isOver: data['isOver'],
      );
      if (data['_id'].isNotEmpty && !_isPlaying) {
        Navigator.pushNamed(context, '/game-screen');
        _isPlaying = true;
      }
    });
  }

  // startTimer(playerId, gameID) {
  //   _socketClient.emit(
  //     'timer',
  //     {
  //       'playerId': playerId,
  //       'gameID': gameID,
  //     },
  //   );
  // }

  notCorrectGameListener(BuildContext context) {
    _socketClient.on(
      'notCorrectGame',
      (data) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data),
        ),
      ),
    );
  }

  // updateTimer(BuildContext context) {
  //   final clientStateProvider =
  //       Provider.of<ClientStateProvider>(context, listen: false);
  //   _socketClient.on('timer', (data) {
  //     clientStateProvider.setClientState(data);
  //   });
  // }

  updateGame(BuildContext context) {
    _socketClient.on('updateGame', (data) {
      final gameStateProvider =
          Provider.of<GameStateProvider>(context, listen: false)
              .updateGameState(
        id: data['_id'],
        players: data['players'],
        isJoin: data['isJoin'],
        isOver: data['isOver'],
      );
    });
  }

  void gameLost(BuildContext context,
      void Function(BuildContext, String) showDialog, String text) {
    _socketClient.on(
      'lostGame',
      (_) {
        print("YOU LOST!!");
        showDialog(context, text);
      },
    );
  }
  void gameWon(BuildContext context,
      void Function(BuildContext, String) showDialog, String text) {
    _socketClient.on(
      'wonGame',
      (_) {
        print("YOU WON!!");
        showDialog(context, text);
      },
    );
  }

  void receiveWord(BuildContext context, Function(String) onWordReceived) {
    _socketClient.on('receiveWord', (word) {
      print('Received word: $word');
      onWordReceived(word);
    });
  }

  void sendWord(String gameId, String word) {
    print('Sending word: $word');
    _socketClient.emit('sendWord', {'gameId': gameId, 'word': word});
  }

  void sendSuccessfulGuess(String gameId) {
    print('sendSuccessfulGuess: $gameId');
    _socketClient.emit('successfulGuess', {'gameId': gameId});
  }

  void sendUnSuccessfulGuess(String gameId) {
    print('sendUnSuccessfulGuess: $gameId');
    _socketClient.emit('unsuccessfulGuess', {'gameId': gameId});
  }
}
