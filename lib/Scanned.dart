import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
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
                  child: StreamBuilder<List<ScanResult>>(
                    stream: controller.scanResults,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length, // Define item count here
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];
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
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        return const Center(child: Text("No Device Found"));
                      }
                    },
                  ),
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
