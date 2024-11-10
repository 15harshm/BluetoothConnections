import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void initializeSocket() {
    // Connect to the Raspberry Pi's IP address and port 3000
    socket = IO.io('http://<raspberry-pi-ip>:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Handle connection events
    socket.onConnect((_) {
      print('Connected to Raspberry Pi server');

      // Example: Send a signal to the Raspberry Pi
      socket.emit('signal', 'Hello from Flutter');
    });

    // Listen for messages from the Raspberry Pi
    socket.on('response', (data) {
      print('Received response from Raspberry Pi: $data');
    });

    // Handle disconnect events
    socket.onDisconnect((_) => print('Disconnected from Raspberry Pi server'));
  }
}
