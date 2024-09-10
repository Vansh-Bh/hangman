import 'package:flutter/material.dart';
import 'package:hangman/pages/game_fetcher.dart';

class PreviousGamesScreen extends StatefulWidget {
  @override
  _PreviousGamesScreenState createState() => _PreviousGamesScreenState();
}

class _PreviousGamesScreenState extends State<PreviousGamesScreen> {
  final GameService _gameService = GameService();
  List<dynamic> _games = [];

  @override
  void initState() {
    super.initState();
    _loadPreviousGames();
  }

  void _loadPreviousGames() async {
    List<dynamic> games = await _gameService.fetchPreviousGames();
    setState(() {
      _games = games;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Games'),
      ),
      body: _games.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _games.length,
              itemBuilder: (context, index) {
                final game = _games[index];
                return ListTile(
                  title: Text(
                      "${game['players'][0]["nickname"]} vs ${game['players'][1]['nickname']}"),
                  onTap: () {},
                );
              },
            ),
    );
  }
}
