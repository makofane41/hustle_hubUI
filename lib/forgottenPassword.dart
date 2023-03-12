import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgottePassword extends StatefulWidget {
  @override
  _ForgottePasswordState createState() => _ForgottePasswordState();
}

class _ForgottePasswordState extends State<ForgottePassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String _resultMessage = '';
  RegExp _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    final email = _emailController.text.trim();
    final url = Uri.parse('https://prod-api.hustleshub.com/user/req/forgotpass/');
    final body = {'email': email};
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(url, headers: headers, body: jsonEncode(body));

    setState(() {
      _isLoading = false;
      if (response.statusCode == 200) {
        _resultMessage = 'Password reset email sent to $email';
      } else {
        _resultMessage = 'Failed to reset password. Status code: ${response.statusCode}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forgot Password',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Center(
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                          _submitForm();
                        }
                      },
                    child: Text('Reset Password'),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(_resultMessage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
