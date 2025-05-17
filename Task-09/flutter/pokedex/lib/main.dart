import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/home.dart';
import 'package:pokedex/register.dart';
import 'package:pokedex/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo section
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
                      child: Image.asset('assets/pokeball.png', width: 50, height: 50),
                      // Note: You'll need to add this image to your assets
                    ),
                  ),
                  SizedBox(width: 10),
                  Image.asset(
                    'assets/pokedex_logo.png',
                    width: 200,
                    height: 200,
                    // Note: You'll need to add this image to your assets
                  ),
                ],
              ),
              SizedBox(height: 60),

              TextField(
                controller: emailController,
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

              // Password field
              TextField(
                controller: passwordController,
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
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    String? result = await AuthService()
                        .signInWithEmailAndPassword(email, password);
                    if (result == "Success") {
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result ?? 'An error occurred')),
                      );
                    }
                  },

                  child: Text(
                    'LOGIN',
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

              // Register text

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New Trainer? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()),
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
