import 'package:flutter/material.dart';
import 'device.dart';
import 'device_data.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return ListTile(
            leading: Icon(device.icon),
            title: Text(device.name),
            subtitle: Text('Type: ${device.type}\nStatus: ${device.status}'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _DeviceDetailSheet(device: device),
              );
            },
          );
        },
      ),
    );
  }
}

class _DeviceDetailSheet extends StatelessWidget {
  final Device device;
  const _DeviceDetailSheet({required this.device});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          device.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text('Type: ${device.type}'),
        Text('OS Version: ${device.osVersion}'),
        Text('Serial Number: ${device.serialNumber}'),
        Text('Color: ${device.color}'),
        Text('Storage: ${device.storage}'),
        if (device.imei != null) Text('IMEI: ${device.imei}'),
        if (device.processor != null) Text('Processor: ${device.processor}'),
        if (device.ram != null) Text('RAM: ${device.ram}'),
        Text('Status: ${device.status}'),
      ],
    );
  }
}

class CreatePage extends StatefulWidget {
  final Device? template; // Optional template parameter

  const CreatePage({super.key, this.template});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _serialNumberController = TextEditingController();
  final _departmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      _serialNumberController.text = 'Unknown'; // Default serial number
      _departmentController.text = widget.template!.department ?? 'Unknown';
    }
  }

  void _saveDevice() {
    if (_formKey.currentState!.validate()) {
      final newDevice = Device(
        name: widget.template?.name ?? 'Custom Device',
        type: widget.template?.type ?? 'Unknown',
        osVersion: widget.template?.osVersion ?? 'Unknown',
        serialNumber: _serialNumberController.text,
        color: widget.template?.color ?? 'Unknown',
        storage: widget.template?.storage ?? 'Unknown',
        icon: widget.template?.icon ?? Icons.devices_other,
        status: 'Active',
        department: _departmentController.text,
      );

      setState(() {
        devices.add(newDevice); // Add the new device to the global list
      });

      // Show a Snackbar notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Device "${newDevice.name}" has been created!'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      Navigator.pop(context); // Go back to the previous page
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTemplate = widget.template != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isTemplate ? 'Create from Template' : 'Create New Device'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (isTemplate)
                TextFormField(
                  initialValue: widget.template!.name,
                  decoration: const InputDecoration(labelText: 'Device Name'),
                  readOnly: true,
                ),
              if (isTemplate)
                TextFormField(
                  initialValue: widget.template!.type,
                  decoration: const InputDecoration(labelText: 'Device Type'),
                  readOnly: true,
                ),
              TextFormField(
                controller: _serialNumberController,
                decoration: const InputDecoration(labelText: 'Serial Number'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a serial number' : null,
              ),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'Department'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a department' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveDevice,
                child: const Text('Save Device'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}