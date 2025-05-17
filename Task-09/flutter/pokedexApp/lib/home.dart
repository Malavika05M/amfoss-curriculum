import 'package:flutter/material.dart';
import 'package:pokedexapp/profile.dart';
import 'package:pokedexapp/trade.dart';
import 'package:pokedexapp/pokemon.dart';
import 'package:pokedexapp/detail.dart';

int _selectedIndex = 0;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _typeFilters = ['All', 'Fire', 'Water', 'Electric', 'Grass', 'Flying'];
  String _selectedType = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1019),
      appBar: AppBar(
        backgroundColor: Color(0xFFB71C1C),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // spread left and right
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset('assets/pokeball.png', width: 25, height: 25),
                  ),
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
            // Show username at the right side
            Text(
              'Welcome User',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1A2030),
                hintText: 'Search Pokémon...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Type filter
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _typeFilters.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    selected: _selectedType == _typeFilters[index],
                    label: Text(_typeFilters[index]),
                    labelStyle: TextStyle(
                      color: _selectedType == _typeFilters[index] ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Color(0xFF1A2030),
                    selectedColor: Color(0xFF1A55A9),
                    onSelected: (selected) {
                      setState(() {
                        _selectedType = _typeFilters[index];
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),

          // Pokemon grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: 10, // Replace with actual data length
              itemBuilder: (context, index) {
                // Get the right color based on Pokemon type
                Color cardColor = _getPokemonTypeColor(index);
                return GestureDetector(
                  onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PokemonDetailPage(), // Your detail page widget
                          ),
                        );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF1A2030),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Pokemon image with background
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: cardColor.withOpacity(0.3),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/pokeball.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error, color: Colors.red);
                              },
                            ),
                          ),
                        ),

                        // Pokemon info
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '#${(index + 1).toString().padLeft(3, '0')}',
                                    style: TextStyle(
                                      color: Color(0xFFFFD800),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.favorite_border,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                _getPokemonName(index),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _getPokemonType(index),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
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

  // Helper methods to get Pokemon data
  String _getPokemonName(int index) {
    List<String> names = [
      'Pikachu', 'Charizard', 'Bulbasaur', 'Squirtle', 'Jigglypuff',
      'Eevee', 'Mewtwo', 'Snorlax', 'Gyarados', 'Gengar'
    ];
    return names[index % names.length];
  }

  String _getPokemonType(int index) {
    List<String> types = [
      'Electric', 'Fire', 'Grass', 'Water', 'Normal',
      'Normal', 'Psychic', 'Normal', 'Water', 'Ghost'
    ];
    return types[index % types.length];
  }

  Color _getPokemonTypeColor(int index) {
    Map<String, Color> typeColors = {
      'Electric': Color(0xFFFFD800),
      'Fire': Color(0xFFFF5D5D),
      'Grass': Color(0xFF78C850),
      'Water': Color(0xFF6890F0),
      'Normal': Color(0xFFA8A878),
      'Psychic': Color(0xFFFF5584),
      'Ghost': Color(0xFF705898),
    };

    String type = _getPokemonType(index);
    return typeColors[type] ?? Color(0xFFA8A878);
  }
}
