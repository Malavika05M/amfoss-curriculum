import 'package:flutter/material.dart';
import 'package:pokedexapp/home.dart';
import 'package:pokedexapp/pokemon.dart';
import 'package:pokedexapp/trade.dart';
import 'package:pokedexapp/profile.dart';

int _selectedIndex = 0;
class PokemonDetailPage extends StatefulWidget {
  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  @override
  Widget build(BuildContext context) {
    // Placeholder data
    final pokemonName = "Pikachu";
    final pokemonId = "025";
    final pokemonTypes = ["electric"];
    final pokemonHeight = "0.4 m";
    final pokemonWeight = "6.0 kg";
    final pokemonExp = "112";
    final pokemonStats = [
      {"name": "HP", "value": 35},
      {"name": "ATTACK", "value": 55},
      {"name": "DEFENSE", "value": 40},
      {"name": "SP. ATK", "value": 50},
      {"name": "SP. DEF", "value": 50},
      {"name": "SPEED", "value": 90},
    ];
    final pokemonAbilities = [
      {"name": "STATIC", "is_hidden": false},
      {"name": "LIGHTNING ROD", "is_hidden": true},
    ];
    final pokemonMoves = [
      "Thunderbolt", "Quick Attack", "Iron Tail",
      "Electro Ball", "Thunder", "Agility"
    ];

    return Scaffold(
      backgroundColor: Color(0xFF0A1019),
      appBar: AppBar(
        backgroundColor: Color(0xFFB71C1C),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.catching_pokemon, size: 30),
            SizedBox(width: 10),
            Text(
              'PokeDex',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.pink),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(
                pokemonName,
                pokemonId,
                pokemonTypes,
                pokemonHeight,
                pokemonWeight,
                pokemonExp
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStats(pokemonStats),
                  SizedBox(height: 24),
                  _buildAbilities(pokemonAbilities),
                  SizedBox(height: 24),
                  _buildMoves(pokemonMoves),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A2030),
        selectedItemColor: const Color(0xFFFFD800),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Navigation based on index
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()), // your HomePage
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyPokemon()), // your Pokemon page
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TradePage()), // your Trade page
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()), // your Profile page
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon),
            label: 'Pokémon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_card_sharp),
            label: 'Trade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      String name,
      String id,
      List<String> types,
      String height,
      String weight,
      String exp
      ) {
    final primaryType = types.first;
    final typeColor = _getPokemonTypeColor(primaryType);

    return Container(
      color: typeColor.withOpacity(0.3),
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Pokemon Image with background
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(Icons.catching_pokemon, size: 150, color: typeColor),
            ),
          ),
          SizedBox(height: 20),

          // Pokemon ID and Name
          Text(
            '#$id',
            style: TextStyle(
              color: Color(0xFFFFD800),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            name.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          SizedBox(height: 16),

          // Type chips
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: types.map((type) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getPokemonTypeColor(type),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // Basic info
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('HEIGHT', height),
              _buildInfoItem('WEIGHT', weight),
              _buildInfoItem('BASE EXP', exp),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildStats(List<Map<String, dynamic>> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Base Stats',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 16),
        ...stats.map((stat) {
          final statName = stat["name"];
          final statValue = stat["value"] as int;
          final percentage = statValue / 255;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      statName,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      statValue.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: Color(0xFF1A2030),
                    valueColor: AlwaysStoppedAnimation<Color>(_getStatColor(statValue)),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAbilities(List<Map<String, dynamic>> abilities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Abilities',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 16),
        ...abilities.map((ability) {
          final abilityName = ability["name"];
          final isHidden = ability["is_hidden"] as bool;

          return Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF1A2030),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  abilityName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isHidden)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'HIDDEN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMoves(List<String> moves) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Moves',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: moves.map((move) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF1A2030),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFF3A4050)),
              ),
              child: Text(
                move,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16),
        Center(
          child: Text(
            'Pokemon',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Color _getPokemonTypeColor(String type) {
    final typeColors = {
      'electric': Color(0xFFFFD800),
      'fire': Color(0xFFFF5D5D),
      'grass': Color(0xFF78C850),
      'water': Color(0xFF6890F0),
      'normal': Color(0xFFA8A878),
    };
    return typeColors[type.toLowerCase()] ?? Color(0xFFA8A878);
  }

  Color _getStatColor(int value) {
    if (value < 50) return Colors.red;
    if (value < 90) return Colors.orange;
    if (value < 130) return Colors.yellow;
    return Colors.green;
  }
}