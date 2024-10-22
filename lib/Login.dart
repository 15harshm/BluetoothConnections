import 'package:flutter/material.dart';
import 'package:sample_logins/Register.dart';
import 'package:sample_logins/Services/database_service.dart';
import 'Home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool secureText = true; // Secure text toggle
  final DatabaseService _databaseService = DatabaseService.instance;
  String? _username;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Login",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView( // Scroll fix
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset('assets/images/carimg.jpg'),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF42A5F5)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        secureText = !secureText; // Secure text toggle fix
                      });
                    },
                    icon: Icon(
                      secureText ? Icons.visibility_off : Icons.visibility, // Icon changes based on secureText value
                    ),
                  ),
                  hintText: "Enter your password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF42A5F5)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                obscureText: secureText, // Password field respects secureText value
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_username != null && _password != null) {
                    bool isAuthenticated = await _databaseService.authenticateUser(_username!, _password!);

                    if (isAuthenticated) {
                      print(isAuthenticated);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                    } else {
                      showInvalidCredentialsDialog(context);
                    }
                  } else {
                    showInvalidCredentialsDialog(context);
                  }
                  _databaseService.getUsers();

                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.blue[400],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 2.0,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Text("If you are a new user "),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));

                },
                child: Text(
                  "Register here",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showInvalidCredentialsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text('Invalid username or password. Please try again.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
