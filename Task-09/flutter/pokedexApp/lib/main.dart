import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pokedexapp/register.dart';
import 'package:pokedexapp/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF0A1019),
        scaffoldBackgroundColor: Color(0xFF0A1019),
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String username = _usernameController.text;
    final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://http://10.0.2.2:5001/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          // Navigate to HomePage if login is successful
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          _showError('Invalid credentials!');
        }
      } else {
        _showError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo section with Flexible widgets to avoid overflow
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/pokeball.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    flex: 2,
                    child: Image.asset(
                      'assets/pokedex_logo.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              // Email field
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
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                style: TextStyle(
                  color: Color(0xFF0A1019),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // Password field
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
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
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
              // Register text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New Trainer? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Register Here',
                      style: TextStyle(
                        color: Color(0xFFFFD800),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


