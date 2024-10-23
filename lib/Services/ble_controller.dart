import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  var scannedDevices = <ScanResult>[].obs;

  // Check if Bluetooth and Location services are enabled and prompt the user
  Future<void> checkAndRequestPermissions() async {
    // Request permissions for Bluetooth and Location
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
    // Ensure Bluetooth is on
    var isBluetoothEnabled = await FlutterBluePlus.isOn;
    if (!isBluetoothEnabled) {
      // Ask the user to turn on Bluetooth
      await FlutterBluePlus.turnOn();
      print("Bluetooth was off, turning it on...");
    }

    // Ensure Location is enabled
    if (!(await Permission.locationWhenInUse.serviceStatus.isEnabled)) {
      // Location services are off, guide user to enable it
      Get.snackbar(
        'Location Required',
        'Please enable location services to scan for BLE devices.',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Optionally, open the location settings
      await openAppSettings();
    }
  }

  Future<void> scanDevice() async {
    // First check and request necessary permissions
    await checkAndRequestPermissions();

    // Ensure Bluetooth and Location services are enabled
    await ensureBluetoothAndLocation();

    // Recheck the location service after potential user action
    if (!(await Permission.locationWhenInUse.serviceStatus.isEnabled)) {
      print("Location services are still off, cannot scan.");
      return;
    }

    // Clear previously scanned devices
    scannedDevices.clear();
    print("Starting scan...");

    // Start scanning with a timeout of 20 seconds
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 20));

    // Listen to scan results
    FlutterBluePlus.scanResults.listen((results) {
      print("Scan results received: ${results.length} devices found.");
      for (var result in results) {
        print("Device: ${result.device.name} - ${result.device.id}");

        // Add only unique devices
        if (!scannedDevices.any((device) => device.device.id == result.device.id)) {
          scannedDevices.add(result);
        }
      }
      update(); // Notify UI about the change
    });

    await Future.delayed(const Duration(seconds: 20));

    // Stop the scan
    FlutterBluePlus.stopScan();
    print("Scanning stopped");
  }
}
