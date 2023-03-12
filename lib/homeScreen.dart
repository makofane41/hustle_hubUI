import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hustle_hub/dashboardScreen.dart';
import 'package:hustle_hub/forgottenPassword.dart';
import 'package:hustle_hub/signupScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('https://prod-api.hustleshub.com/user/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );
    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ),
      );

      //Navigator.pushReplacementNamed(context, '/dashboard', arguments: token);
    } else {
      final message = jsonDecode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Text(
            "Welcome to HustleHub",
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: "Email",
              hintStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.email, color: Colors.white),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.lock, color: Colors.white),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),

    SizedBox(width: 20.0),
    ElevatedButton(
    onPressed: () {
    // Perform Google login
    },
    child: Row(
    children: [
    Icon(Icons.login, color: Colors.blue),
    SizedBox(width: 10.0),
    Text(
    "Login with Google",
    style: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
    ),
    ),
    ],
    ),
    style: ElevatedButton.styleFrom(
    primary: Colors.white,
    padding: EdgeInsets.symmetric(
    horizontal: 30.0, vertical: 15.0),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0),
    ),
    ),
    ),
    ],
    ),
    SizedBox(height: 20.0),
    TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgottePassword(),
        ),
      );
    // Navigate to forgot password screen
    },
    child: Text(
    "Forgot password?",
    style: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    ),
    SizedBox(height: 20.0),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text(
    "Don't have an account?",
    style: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
      SizedBox(width: 10.0),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationScreen()),
          );
        },
        child: Text(
          "Sign up",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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




