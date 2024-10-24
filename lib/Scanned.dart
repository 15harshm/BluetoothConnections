import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample_logins/Services/ble_controller.dart';

class Scanned extends StatefulWidget {
  const Scanned({super.key});

  @override
  State<Scanned> createState() => _ScannedState();
}

class _ScannedState extends State<Scanned> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner"),
        centerTitle: true,
      ),
      body: GetBuilder<BleController>(
        init: BleController(),
        builder: (controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Obx(() {
                    if (controller.scannedDevices.isNotEmpty) {
                      return ListView.builder(
                        itemCount: controller.scannedDevices.length,
                        itemBuilder: (context, index) {
                          final data = controller.scannedDevices[index];

                          // Check advertisement data or fall back to the device ID
                          String deviceName = data.advertisementData.localName.isNotEmpty
                              ? data.advertisementData.localName
                              : (data.device.name.isNotEmpty ? data.device.name : 'Unnamed Device');

                          if (deviceName == 'Unnamed Device') {
                            // Use the ID if no name is provided
                            deviceName = 'Device ${data.device.id.id}';
                          }

                          return Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(deviceName),
                              subtitle: Text("ID: ${data.device.id.id}"),
                              trailing: Text("RSSI: ${data.rssi}"),

                              // Connect to the device when tapped
                              onTap: () async {
                                print("Connecting to device: $deviceName");
                                await controller.connectToDevice(data.device);
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No Devices Found"));
                    }
                  }),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => controller.scanDevice(),
                  child: const Text("Scan"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
