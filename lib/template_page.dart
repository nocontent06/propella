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
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3 / 4,
          ),
          itemCount: templates.length + 1,
          itemBuilder: (context, index) {
            if (index == templates.length) {
              // Option to create a custom device
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_circle_outline, size: 48, color: Colors.blue),
                        SizedBox(height: 8),
                        Text('Create Custom Device', textAlign: TextAlign.center),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(template.icon, size: 48, color: Colors.blue),
                      const SizedBox(height: 16),
                      Text(
                        template.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }
}