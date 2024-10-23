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
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(data.device.name.isEmpty ? 'Unknown Device' : data.device.name),
                              subtitle: Text(data.device.id.id),
                              trailing: Text(data.rssi.toString()),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No Device Found"));
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
