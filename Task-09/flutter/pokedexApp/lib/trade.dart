import 'package:flutter/material.dart';
import 'package:pokedexapp/home.dart';
import 'package:pokedexapp/pokemon.dart';
import 'package:pokedexapp/profile.dart';

int _selectedIndex = 0;

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {

  @override
  Widget build(BuildContext context) {
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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red, width: 3),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TRADE CARD',
                        style: TextStyle(
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red[900],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ACTIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPokemonCard('Pikachu', '025'),
                      const Icon(
                        Icons.swap_horiz,
                        size: 40,
                        color: Colors.red,
                      ),
                      _buildPokemonCard('Eevee', '133'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Trade Details
                  _buildDetailRow('Trade ID:', '#PKX-2023-0482'),
                  _buildDetailRow('Status:', 'Pending Approval'),
                  _buildDetailRow('Initiated:', '2 hours ago'),
                  _buildDetailRow('Expires in:', '22 hours'),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton('Accept', Icons.check, Colors.green),
                      _buildActionButton('Reject', Icons.close, Colors.red),
                      _buildActionButton('Chat', Icons.chat, Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recent Trades Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'RECENT TRADES',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildRecentTradeItem('Bulbasaur', 'Charmander', 'Completed'),
                  _buildRecentTradeItem('Squirtle', 'Pidgey', 'Failed'),
                  _buildRecentTradeItem('Jigglypuff', 'Meowth', 'Completed'),
                  _buildRecentTradeItem('Abra', 'Machop', 'Pending'),
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

  Widget _buildPokemonCard(String name, String number) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 8), // <-- Moved outside of Container
        Text(
          name,
          style: TextStyle(
            color: Colors.red[900],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: Icon(icon, size: 18),
      label: Text(text),
    );
  }

  Widget _buildRecentTradeItem(String pokemon1, String pokemon2, String status) {
    Color statusColor = Colors.grey;
    if (status == 'Completed') statusColor = Colors.green;
    if (status == 'Failed') statusColor = Colors.red;

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.swap_horiz, color: Colors.white),
        title: Text(
          '$pokemon1 ↔ $pokemon2',
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            status,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
