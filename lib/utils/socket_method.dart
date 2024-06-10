import 'package:flutter/material.dart';
import 'package:hangman/pages/multiplayer_gamescreen.dart';
import 'package:hangman/provider/client_state_provider.dart';
import 'package:hangman/provider/game_state_provider.dart';
import 'package:hangman/utils/socket_client.dart';
import 'package:provider/provider.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;
  bool _isPlaying = false;

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
                  isOver: data['isOver']);
      if (data['_id'].isNotEmpty && !_isPlaying) {
        Navigator.pushNamed(context, '/game-screen');
        _isPlaying = true;
      }
    });
  }

  startTimer(playerId, gameID) {
    _socketClient.emit(
      'timer',
      {
        'playerId': playerId,
        'gameID': gameID,
      },
    );
  }

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

  updateTimer(BuildContext context) {
    final clientStateProvider =
        Provider.of<ClientStateProvider>(context, listen: false);
    _socketClient.on('timer', (data) {
      clientStateProvider.setClientState(data);
    });
  }

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
}
