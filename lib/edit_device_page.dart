import 'package:flutter/material.dart';
import 'device.dart';

class EditDevicePage extends StatefulWidget {
  final Device device;

  const EditDevicePage({super.key, required this.device});

  @override
  State<EditDevicePage> createState() => _EditDevicePageState();
}

class _EditDevicePageState extends State<EditDevicePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController osController;
  late TextEditingController serialController;
  late TextEditingController colorController;
  late TextEditingController storageController;
  late TextEditingController statusController;
  late TextEditingController departmentController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.device.name);
    typeController = TextEditingController(text: widget.device.type);
    osController = TextEditingController(text: widget.device.osVersion);
    serialController = TextEditingController(text: widget.device.serialNumber);
    colorController = TextEditingController(text: widget.device.color);
    storageController = TextEditingController(text: widget.device.storage);
    statusController = TextEditingController(text: widget.device.status);
    departmentController = TextEditingController(text: widget.device.department);
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    osController.dispose();
    serialController.dispose();
    colorController.dispose();
    storageController.dispose();
    statusController.dispose();
    departmentController.dispose();
    super.dispose();
  }

  void _saveDevice() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        widget.device.name = nameController.text.trim();
        widget.device.type = typeController.text.trim();
        widget.device.osVersion = osController.text.trim();
        widget.device.serialNumber = serialController.text.trim();
        widget.device.color = colorController.text.trim();
        widget.device.storage = storageController.text.trim();
        widget.device.status = statusController.text.trim();
        widget.device.department = departmentController.text.trim();
      });
      Navigator.pop(context, widget.device);
    }
  }

  Widget _buildField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Required' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Device'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildField('Device Name', nameController),
                const SizedBox(height: 12),
                _buildField('Category', typeController),
                const SizedBox(height: 12),
                _buildField('OS Version', osController),
                const SizedBox(height: 12),
                _buildField('Serial Number', serialController),
                const SizedBox(height: 12),
                _buildField('Color', colorController),
                const SizedBox(height: 12),
                _buildField('Storage', storageController),
                const SizedBox(height: 12),
                _buildField('Status', statusController),
                const SizedBox(height: 12),
                _buildField('Department', departmentController),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveDevice,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}