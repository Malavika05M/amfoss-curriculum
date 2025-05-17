import 'package:flutter/material.dart';
import 'package:pokedexapp/home.dart';
import 'package:pokedexapp/trade.dart';
import 'package:pokedexapp/profile.dart';

int _selectedIndex = 0;

class MyPokemon extends StatefulWidget {
  const MyPokemon({super.key});

  @override
  State<MyPokemon> createState() => _PokemonCollectionPageState();
}

class _PokemonCollectionPageState extends State<MyPokemon> {
  final List<Map<String, dynamic>> _pokemonList = [
    {
      'id': '001',
      'name': 'Bulbasaur',
      'type': ['Grass', 'Poison'],
      'captured': true,
      'image': 'bulbasaur.png',
    },
    {
      'id': '004',
      'name': 'Charmander',
      'type': ['Fire'],
      'captured': true,
      'image': 'charmander.png',
    },
    {
      'id': '007',
      'name': 'Squirtle',
      'type': ['Water'],
      'captured': true,
      'image': 'squirtle.png',
    },
    {
      'id': '025',
      'name': 'Pikachu',
      'type': ['Electric'],
      'captured': true,
      'image': 'pikachu.png',
    },
    {
      'id': '133',
      'name': 'Eevee',
      'type': ['Normal'],
      'captured': true,
      'image': 'eevee.png',
    },
  ];

  String _searchQuery = '';
  String _selectedType = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredPokemon = _pokemonList.where((pokemon) {
      final matchesSearch = pokemon['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesType = _selectedType == 'All' ||
          pokemon['type'].contains(_selectedType);
      return matchesSearch && matchesType;
    }).toList();

    final typeList = [
      'All',
      ..._pokemonList
          .expand((pokemon) => pokemon['type'])
          .toSet()
          .toList()
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/pokeball.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            Image.asset(
              'assets/pokedex_logo.png',
              width: 120, 
              height: 50,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Pokémon...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedType,
                  dropdownColor: Colors.grey[900],
                  iconEnabledColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  items: typeList.map<DropdownMenuItem<String>>((dynamic value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.2,
              ),
              itemCount: filteredPokemon.length,
              itemBuilder: (context, index) {
                final pokemon = filteredPokemon[index];
                return _buildPokemonCard(pokemon);
              },
            ),
          ),
        ],
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

  Widget _buildPokemonCard(Map<String, dynamic> pokemon) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getTypeColor(pokemon['type'][0]),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '#${pokemon['id']}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                child: Image.asset(
                  'assets/images/${pokemon['image']}',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                pokemon['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: pokemon['type'].map<Widget>((type) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getTypeColor(type).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _getTypeColor(type),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.orange;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.yellow;
      case 'poison':
        return Colors.purple;
      case 'flying':
        return Colors.lightBlue;
      case 'psychic':
        return Colors.pink;
      case 'ice':
        return Colors.cyan;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.brown;
      case 'fairy':
        return Colors.pinkAccent;
      case 'normal':
        return Colors.grey;
      case 'fighting':
        return Colors.red;
      case 'ground':
        return Colors.orange[300]!;
      case 'rock':
        return Colors.brown[400]!;
      case 'bug':
        return Colors.lightGreen;
      case 'ghost':
        return Colors.deepPurple;
      case 'steel':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }
}

class PokemonSearch extends SearchDelegate {
  final List<Map<String, dynamic>> pokemonList;

  PokemonSearch(this.pokemonList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = pokemonList.where((pokemon) {
      return pokemon['name']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final pokemon = results[index];
        return ListTile(
          leading: Image.asset(
            'assets/images/${pokemon['image']}',
            width: 50,
            height: 50,
          ),
          title: Text(pokemon['name']),
          subtitle: Text('#${pokemon['id']}'),
          onTap: () {
            // Navigate to Pokémon details
          },
        );
      },
    );
  }
}
