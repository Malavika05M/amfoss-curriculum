import 'package:flutter/material.dart';
import 'package:pokedex/home.dart';
import 'package:pokedex/search.dart';
import 'package:pokedex/trade.dart';

int _selectedIndex = 0;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // App Bar with Profile Header
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 10.0,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.yellow[900]!,
                      Colors.red[700]!,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.red[900],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Malavika",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Pallet Town",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Profile Content
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Trainer Stats Card
                    _buildStatsCard(),

                    // Badges Section
                    _buildSectionTitle("GYM BADGES"),
                    _buildBadgesGrid(),

                    // Recent Activity
                    _buildSectionTitle("RECENT ACTIVITY"),
                    _buildActivityList(),

                    // Settings Button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.settings, size: 20),
                        label: const Text(
                          "TRAINER SETTINGS",
                          style: TextStyle(
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
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

  Widget _buildStatsCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.red[900]!, width: 2),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("142", "Pokémon"),
                _buildStatItem("8", "Badges"),
                _buildStatItem("24", "Trades"),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.68,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red[900]!),
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pokédex Completion: 68%",
                  style: TextStyle(
                    color: Colors.red[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Next: Dragonite",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red[900],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildBadgesGrid() {
    List<String> badgeImages = [
      "boulder",
      "cascade",
      "thunder",
      "rainbow",
      "soul",
      "marsh",
      "volcano",
      "earth"
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: badgeImages.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[900],
            border: Border.all(color: Colors.yellow[900]!, width: 2),
          ),
          child: Center(
            child: Text(
              "${index + 1}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityList() {
    final activities = [
      {"type": "trade", "title": "Traded Pikachu for Eevee", "time": "2h ago"},
      {"type": "catch", "title": "Caught a wild Dragonair", "time": "1d ago"},
      {"type": "battle", "title": "Defeated Gym Leader Misty", "time": "2d ago"},
      {"type": "evolution", "title": "Eevee evolved to Vaporeon", "time": "3d ago"},
    ];

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.yellow[900]!, width: 1),
      ),
      child: Column(
        children: activities.map((activity) {
          IconData icon;
          Color iconColor;

          switch (activity["type"]) {
            case "trade":
              icon = Icons.swap_horiz;
              iconColor = Colors.blue;
              break;
            case "catch":
              icon = Icons.catching_pokemon;
              iconColor = Colors.green;
              break;
            case "battle":
              icon = Icons.sports_martial_arts;
              iconColor = Colors.red;
              break;
            case "evolution":
              icon = Icons.auto_awesome;
              iconColor = Colors.purple;
              break;
            default:
              icon = Icons.notifications;
              iconColor = Colors.yellow;
          }

          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            title: Text(
              activity["title"]!,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Text(
              activity["time"]!,
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          );
        }).toList(),
      ),
    );
  }
}
