import 'package:flutter/material.dart';
import 'device.dart';
import 'device_data.dart';
import 'create_page.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key});

  void _redirectToCreatePage(BuildContext context, Device template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePage(
          template: template, // Pass the selected template to the CreatePage
        ),
      ),
    );
  }

  // Dummy barcode scan method
  Future<void> _scanBarcode(BuildContext context) async {
    // TODO: integrate actual barcode scanning package here.
    // For now, simulate scanning and auto-fill data:
    Device scannedDevice = Device(
      name: 'Scanned Device',
      type: 'iOS',
      osVersion: 'iOS 17',
      serialNumber: 'SCANNED-12345',
      color: 'Black',
      storage: '256GB',
      icon: Icons.phone_iphone,
      status: 'Active',
      department: 'DEP1',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePage(template: scannedDevice),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final templates = [
      // iPhone Templates
      Device(
        name: 'iPhone 15',
        type: 'iOS',
        osVersion: 'iOS 17',
        serialNumber: 'Unknown',
        color: 'Black',
        storage: '128GB',
        icon: Icons.phone_iphone,
        status: 'Active',
        department: 'DEP1',
      ),
      Device(
        name: 'iPhone 16',
        type: 'iOS',
        osVersion: 'iOS 18',
        serialNumber: 'Unknown',
        color: 'White',
        storage: '256GB',
        icon: Icons.phone_iphone,
        status: 'Active',
        department: 'DEP1',
      ),
      // Android Templates
      Device(
        name: 'Galaxy A36',
        type: 'Android',
        osVersion: 'Android 15',
        serialNumber: 'Unknown',
        color: 'Blue',
        storage: '128GB',
        icon: Icons.phone_android,
        status: 'Active',
        department: 'DEP2',
      ),
      Device(
        name: 'Galaxy XCover 7',
        type: 'Android',
        osVersion: 'Android 14',
        serialNumber: 'Unknown',
        color: 'Black',
        storage: '64GB',
        icon: Icons.phone_android,
        status: 'Active',
        department: 'DEP3',
      ),
      Device(
        name: 'Galaxy A34',
        type: 'Android',
        osVersion: 'Android 14',
        serialNumber: 'Unknown',
        color: 'Green',
        storage: '128GB',
        icon: Icons.phone_android,
        status: 'Active',
        department: 'DEP2',
      ),
      // Windows Templates
      Device(
        name: 'ThinkPad X12 Detachable Gen 2',
        type: 'Windows',
        osVersion: 'Windows 11',
        serialNumber: 'Unknown',
        color: 'Black',
        storage: '256GB SSD',
        icon: Icons.laptop,
        status: 'Active',
        department: 'DEP4',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Template'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // For screens less than 600 pixels wide, use a ListView; otherwise use a GridView with 2 columns.
            if (constraints.maxWidth < 600) {
              return ListView.separated(
                itemCount: templates.length + 2,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == templates.length) {
                    // Option to create a custom device (List view version)
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreatePage(),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: SizedBox(
                          height: 100, // Adjust height as needed
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add_circle_outline,
                                    size: 48, color: Colors.blue),
                                SizedBox(height: 8),
                                Text('Create Custom Device',
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  if (index == templates.length + 1) {
                    // "Scan Barcode" card
                    return GestureDetector(
                      onTap: () => _scanBarcode(context),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: SizedBox(
                          height: 100,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.qr_code_scanner,
                                    size: 48, color: Colors.blue),
                                SizedBox(height: 8),
                                Text('Scan Barcode',
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
          
                  final template = templates[index];
                  return GestureDetector(
                    onTap: () => _redirectToCreatePage(context, template),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(template.icon, size: 48, color: Colors.blue),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    template.name,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Type: ${template.type}'),
                                  Text('OS: ${template.osVersion}'),
                                  Text('Storage: ${template.storage}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75, // Keep this value as now
                ),
                itemCount: templates.length + 2,
                itemBuilder: (context, index) {
                  if (index == templates.length) {
                    // Option to create a custom device (Grid view version)
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreatePage(),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_circle_outline,
                                  size: 48, color: Colors.blue),
                              SizedBox(height: 8),
                              Text('Create Custom Device',
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  if (index == templates.length + 1) {
                    // "Scan Barcode" card (Grid version)
                    return GestureDetector(
                      onTap: () => _scanBarcode(context),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.qr_code_scanner,
                                  size: 48, color: Colors.blue),
                              SizedBox(height: 8),
                              Text('Scan Barcode',
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
          
                  final template = templates[index];
                  return GestureDetector(
                    onTap: () => _redirectToCreatePage(context, template),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(template.icon, size: 48, color: Colors.blue),
                            const SizedBox(height: 16),
                            Text(
                              template.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text('Type: ${template.type}'),
                            Text('OS: ${template.osVersion}'),
                            Text('Storage: ${template.storage}'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}