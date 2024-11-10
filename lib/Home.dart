import 'package:flutter/material.dart';
import 'package:sample_logins/Login.dart';
import 'package:sample_logins/Services/SocketService.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SocketService socketService = SocketService(); // Initialize SocketService

  @override
  void initState() {
    super.initState();
    socketService.initializeSocket(); // Initialize socket connection
  }

  // Function to send signal using SocketService
  void sendSignal(String direction) {
    socketService.socket.emit('signal', direction);
    print('Sent signal: $direction');
  }

  @override
  void dispose() {
    socketService.socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Center(child: Text("Dashboard", style: TextStyle(color: Colors.white))),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => sendSignal("left"),
              child: const Text("Send Left Signal"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => sendSignal("right"),
              child: const Text("Send Right Signal"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => sendSignal("forward"),
              child: const Text("Send Forward Signal"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => sendSignal("backwards"),
              child: const Text("Send Backwards Signal"),
            ),
          ],
        ),
      ),
    );
  }
}
