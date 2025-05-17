import 'package:flutter/material.dart';
import 'package:pokedexapp/home.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1019),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset('assets/pokeball.png', width: 45, height: 45),
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset(
                      'assets/pokedex_logo.png',
                      width: 200,
                      height: 200,
                    ),
                  ],
                ),

                SizedBox(height: 40),
                Text(
                  'Create New Trainer Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),

                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFD800),
                    hintText: 'Username',
                    hintStyle: TextStyle(
                      color: Color(0xFF0A1019),
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  style: TextStyle(
                    color: Color(0xFF0A1019),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFD800),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: Color(0xFF0A1019),
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  style: TextStyle(
                    color: Color(0xFF0A1019),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFD800),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Color(0xFF0A1019),
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  style: TextStyle(
                    color: Color(0xFF0A1019),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFD800),
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(
                      color: Color(0xFF0A1019),
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  style: TextStyle(
                    color: Color(0xFF0A1019),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: Text(
                      'REGISTER',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1A55A9),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already a Trainer? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Navigate back to login
                      },
                      child: Text(
                        'Login Here',
                        style: TextStyle(
                          color: Color(0xFFFFD800),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
