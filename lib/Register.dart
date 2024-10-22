import 'package:flutter/material.dart';
import 'package:sample_logins/Login.dart';
import 'package:sample_logins/Services/database_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool secureText = true;
  bool confirmSecureText = true;
  String? _username = '';
  String? _password = '';
  String? _confirmPassword = '';
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Register",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                  hintText: "Set new password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        secureText = !secureText;
                      });
                    },
                    icon: Icon(
                      secureText ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF42A5F5)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                obscureText: secureText,
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _confirmPassword = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Confirm new password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        confirmSecureText = !confirmSecureText;
                      });
                    },
                    icon: Icon(
                      confirmSecureText ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF42A5F5)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                obscureText: confirmSecureText,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_username!.isNotEmpty &&
                      _password!.isNotEmpty &&
                      _password == _confirmPassword) {
                    _databaseService.addUser(_username!, _password!);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                    // Add a success message or redirect here
                  } else {
                    showInvalidCredentialsDialog(context);
                  }
                },
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.blue[400],
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
          title: Text('Register Error'),
          content: Text(
            'Invalid username or password. Ensure passwords match and fields are filled.',
          ),
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
