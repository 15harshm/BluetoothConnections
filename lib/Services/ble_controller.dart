import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  var scannedDevices = <ScanResult>[].obs;

  // Method to handle Bluetooth device connection
  Future<void> connectToDevice(BluetoothDevice device) async {
    print("Attempting to connect to device: ${device.name} (${device.id})");

    try {
      // Check if the device is already connected
      var connectionState = await device.state.first;
      if (connectionState == BluetoothDeviceState.connected) {
        print("Device already connected: ${device.name}");
        return;
      }

      // Attempt to connect to the device with a longer timeout
      await device.connect(timeout: const Duration(seconds: 30));
      print("Connection attempt initiated...");

      // Listen for connection state changes
      device.state.listen((connectionState) {
        if (connectionState == BluetoothDeviceState.connecting) {
          print("Device connecting: ${device.name}");
        } else if (connectionState == BluetoothDeviceState.connected) {
          print("Device connected: ${device.name}");
        } else if (connectionState == BluetoothDeviceState.disconnected) {
          print("Device disconnected: ${device.name}");
        } else if (connectionState == BluetoothDeviceState.disconnecting) {
          print("Device is disconnecting: ${device.name}");
        }
      });
    } catch (e) {
      print("Failed to connect: $e");
    }
  }

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
      if (bluetoothScanStatus.isPermanentlyDenied || locationStatus.isPermanentlyDenied) {
        await openAppSettings();
      }
      return;
    }
  }

  Future<void> ensureBluetoothAndLocation() async {
    var isBluetoothEnabled = await FlutterBluePlus.isOn;
    if (!isBluetoothEnabled) {
      await FlutterBluePlus.turnOn();
      print("Bluetooth was off, turning it on...");
    }

    var locationServiceEnabled = await Permission.locationWhenInUse.serviceStatus.isEnabled;
    if (!locationServiceEnabled) {
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

    scannedDevices.clear();
    print("Starting scan...");

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) {
      print("Scan results received: ${results.length} devices found.");
      for (var result in results) {
        print("Device: ${result.device.name} - ${result.device.id}");
        if (!scannedDevices.any((device) => device.device.id == result.device.id)) {
          scannedDevices.add(result);
        }
      }
      update(); // Notify UI about the change
    });

    await Future.delayed(const Duration(seconds: 10));
    FlutterBluePlus.stopScan();
    print("Scanning stopped");
  }
}
