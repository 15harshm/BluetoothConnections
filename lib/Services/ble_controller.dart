import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  var scannedDevices = <ScanResult>[].obs;

  // Check and request permissions
  Future<void> checkAndRequestPermissions() async {
    var bluetoothScanStatus = await Permission.bluetoothScan.request();
    var bluetoothConnectStatus = await Permission.bluetoothConnect.request();
    var locationStatus = await Permission.locationWhenInUse.request();

    if (bluetoothScanStatus.isGranted &&
        bluetoothConnectStatus.isGranted &&
        locationStatus.isGranted) {
      print("All required permissions granted.");
    } else {
      print("Permissions not granted, scanning cannot proceed.");
    }
  }

  Future<void> ensureBluetoothAndLocation() async {
    var isBluetoothEnabled = await FlutterBluePlus.isOn;
    if (!isBluetoothEnabled) {
      await FlutterBluePlus.turnOn();
      print("Bluetooth was off, turning it on...");
    }

    if (!(await Permission.locationWhenInUse.serviceStatus.isEnabled)) {
      Get.snackbar(
        'Location Required',
        'Please enable location services to scan for BLE devices.',
        snackPosition: SnackPosition.BOTTOM,
      );
      await openAppSettings();
    }
  }

  Future<void> scanDevice() async {
    await checkAndRequestPermissions();
    await ensureBluetoothAndLocation();

    if (!(await Permission.locationWhenInUse.serviceStatus.isEnabled)) {
      print("Location services are still off, cannot scan.");
      return;
    }

    scannedDevices.clear();
    print("Starting scan...");
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 20));

    FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        if (!scannedDevices.any((device) => device.device.remoteId == result.device.remoteId)) {
          scannedDevices.add(result);
        }
      }
      update();
    });

    await Future.delayed(const Duration(seconds: 20));
    FlutterBluePlus.stopScan();
    print("Scanning stopped");
  }

  // Method to connect to a selected device
  Future<void> connectToDevice(BluetoothDevice device) async {
    print("Attempting to connect to device: ${device.platformName} (${device.remoteId})");

    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        // Retry connection up to 3 times
        print("Connection attempt #$attempt...");
        await Future.delayed(const Duration(seconds: 2)); // Short delay before each attempt

        await device.connect(timeout: const Duration(seconds: 60));
        print("Connection attempt initiated...");

        device.connectionState.listen((state) {
          if (state == BluetoothConnectionState.connected) {
            print("Device connected: ${device.platformName}");
          } else if (state == BluetoothConnectionState.disconnected) {
            print("Device disconnected: ${device.platformName}");
          }
        });
        break; // Exit loop if connection is successful
      } catch (e) {
        print("Connection attempt #$attempt failed: $e");

        if (attempt == 3) {
          print("Failed to connect after multiple attempts.");
          // Optional: Reset Bluetooth adapter if multiple attempts fail
          await resetBluetoothAdapter();
        }
      }
    }
  }
  Future<void> resetBluetoothAdapter() async {
    FlutterBluePlus.turnOff();
    await Future.delayed(Duration(seconds: 2)); // Wait briefly for adapter to reset
    FlutterBluePlus.turnOn();
  }

}
