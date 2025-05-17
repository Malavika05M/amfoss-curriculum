import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  // Fetch list of Pokémon (with pagination)
  static Future<List<Map<String, dynamic>>> fetchPokemonList({int limit = 20, int offset = 0}) async {
    final response = await http.get(Uri.parse('$_baseUrl/pokemon?limit=$limit&offset=$offset'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    }
    throw Exception('Failed to load Pokémon list');
  }

  // Fetch details for a single Pokémon
  static Future<Map<String, dynamic>> fetchPokemonDetails(String nameOrId) async {
    final response = await http.get(Uri.parse('$_baseUrl/pokemon/$nameOrId'));
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    }
    throw Exception('Failed to load Pokémon details');
  }

  // OPTIONAL: You don't really need this second method if fetchPokemonDetails already does the job.
  static Future<Map<String, dynamic>> fetchPokemon(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/pokemon/$id'));
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    }
    throw Exception('Failed to load Pokémon');
  }

  // Get image URL for a Pokémon
  static String getImageUrl(String id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }
}

