import 'package:flutter/material.dart';
import 'package:hangman/models/game_state.dart';

class GameStateProvider extends ChangeNotifier {
  GameState _gameState = GameState(
    id: '',
    players: [],
    isJoin: true,
    isOver: false,
  );

  Map<String, dynamic> get gameState => _gameState.toJson();

  void updateGameState({
    required id,
    required players,
    required isJoin,
    required isOver,
  }) {
    _gameState = GameState(
      id: id,
      players: players,
      isJoin: isJoin,
      isOver: isOver,
    );
    notifyListeners();
  }
}