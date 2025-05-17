import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokedex/home.dart';
import 'package:pokedex/search.dart';
import 'package:pokedex/trade.dart';
import 'package:pokedex/profile.dart';
import 'package:pokedex/pokemon_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonDetailPage extends StatefulWidget {
  final String pokemonId;

  const PokemonDetailPage({Key? key, required this.pokemonId}) : super(key: key);

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  int _selectedIndex = 0;
  bool isInCollection = false;
  bool isLoading = true;
  Map<String, dynamic> pokemonDetails = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadPokemonDetails();
    _checkIfInCollection();
  }

  Future<void> _loadPokemonDetails() async {
    setState(() => isLoading = true);
    try {
      final details = await PokemonService.fetchPokemonDetails(widget.pokemonId);
      setState(() {
        pokemonDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading Pokémon details: $e'))
      );
    }
  }

  Future<void> _checkIfInCollection() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('collection')
            .doc(widget.pokemonId)
            .get();

        setState(() {
          isInCollection = doc.exists;
        });
      }
    } catch (e) {
      print('Error checking collection: $e');
    }
  }

  Future<void> _toggleCollection() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (isInCollection) {
          // Remove from collection
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('collection')
              .doc(widget.pokemonId)
              .delete();
        } else {
          // Add to collection
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('collection')
              .doc(widget.pokemonId)
              .set({
            'pokemonId': widget.pokemonId,
            'name': pokemonDetails['name'] ?? '',
            'added': FieldValue.serverTimestamp(),
          });
        }

        setState(() {
          isInCollection = !isInCollection;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isInCollection
                ? 'Added to your collection!'
                : 'Removed from your collection'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating collection: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1019),
      appBar: AppBar(
        backgroundColor: Color(0xFFB71C1C),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/pokeball.png',
              width: 30,
              height: 30,
            ),
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
            icon: Icon(
              isInCollection ? Icons.favorite : Icons.favorite_border,
              color: isInCollection ? Colors.pink : Colors.white,
            ),
            onPressed: _toggleCollection,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStats(),
                  SizedBox(height: 24),
                  _buildAbilities(),
                  SizedBox(height: 24),
                  _buildMoves(),
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
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyPokemon()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TradePage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
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

  Widget _buildHeader() {
    final types = pokemonDetails['types'] != null
        ? List<String>.from(pokemonDetails['types'].map((t) => t['type']['name']))
        : ['normal'];
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
              child: CachedNetworkImage(
                imageUrl: PokemonService.getImageUrl(widget.pokemonId),
                width: 150,
                height: 150,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Pokemon ID and Name
          Text(
            '#${widget.pokemonId.padLeft(3, '0')}',
            style: TextStyle(
              color: Color(0xFFFFD800),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            (pokemonDetails['name'] ?? 'Unknown').toUpperCase(),
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
              _buildInfoItem(
                'HEIGHT',
                '${(pokemonDetails['height'] ?? 0) / 10} m',
              ),
              _buildInfoItem(
                'WEIGHT',
                '${(pokemonDetails['weight'] ?? 0) / 10} kg',
              ),
              _buildInfoItem(
                'BASE EXP',
                '${pokemonDetails['base_experience'] ?? 0}',
              ),
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

  Widget _buildStats() {
    final stats = pokemonDetails['stats'] as List? ?? [];

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
          final statName = stat['stat']['name'].toString().toUpperCase().replaceAll('-', ' ');
          final statValue = stat['base_stat'] as int;
          final percentage = statValue / 255; // Max stat value is 255

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

  Widget _buildAbilities() {
    final abilities = pokemonDetails['abilities'] as List? ?? [];

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
          final abilityName = ability['ability']['name']
              .toString()
              .toUpperCase()
              .replaceAll('-', ' ');
          final isHidden = ability['is_hidden'] as bool;

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
                    padding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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


  Widget _buildMoves() {
    final moves = (pokemonDetails['moves'] as List? ?? [])
        .take(10) // Limit to first 10 moves
        .map((m) => m['move']['name'].toString().toUpperCase().replaceAll('-', ' '))
        .toList();

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
        if ((pokemonDetails['moves'] as List? ?? []).length > 10)
          Center(
            child: Text(
              '+ ${(pokemonDetails['moves'] as List).length - 10} more moves',
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
      'psychic': Color(0xFFFF5584),
      'ghost': Color(0xFF705898),
      'flying': Color(0xFFA890F0),
      'dark': Color(0xFF705848),
      'dragon': Color(0xFF7038F8),
      'bug': Color(0xFFA8B820),
      'fighting': Color(0xFFC03028),
      'ice': Color(0xFF98D8D8),
      'poison': Color(0xFFA040A0),
      'rock': Color(0xFFB8A038),
      'ground': Color(0xFFE0C068),
      'steel': Color(0xFFB8B8D0),
      'fairy': Color(0xFFEE99AC),
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