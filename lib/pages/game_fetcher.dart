import 'dart:convert';
import 'package:http/http.dart' as http;

class GameService {
  final String baseUrl = 'https://hangman-g0n5.onrender.com'; 

  Future<List<dynamic>> fetchPreviousGames() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/previous-games'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load previous games');
      }
    } catch (e) {
      print('Error fetching previous games: $e');
      return [];
    }
  }
}
