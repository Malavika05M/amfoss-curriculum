import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5001/api'; 
  static Future<Map<String, dynamic>> registerUser({
    required String username,
    required String name,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'name': name,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getPokemonCards() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon_cards'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getPokemonDetails(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$name'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> addToPokelist({
    required String username,
    required int pokemonId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pokelist/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'pokemonId': pokemonId,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> removeFromPokelist({
    required String username,
    required int pokemonId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pokelist/remove'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'pokemonId': pokemonId,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getPokelist(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/pokelist/$username'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> tradePokemon({
    required String username,
    required String receiver,
    required int pokemon,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/trade'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'receiver': receiver,
        'pokemon': pokemon,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<String> getPokemonImage(int pokemonId) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon_image/$pokemonId'));
    if (response.statusCode == 200) {
      return 'http://10.0.2.2:5001/pokemon_image/$pokemonId';
    } else {
      throw Exception('Failed to load image');
    }
  }

  static Future<Map<String, dynamic>> getPokemonByName(String pokemonName) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$pokemonName'));
    return jsonDecode(response.body);
  }
}