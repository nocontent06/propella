import 'package:flutter/material.dart';
import 'device.dart';
import 'device_data.dart';
import 'category_settings.dart'; // For shared categories, if needed

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
            title: Text(
              device.name,
              style: const TextStyle(fontSize: 16),
              maxLines: 1, // Prevents overflow by limiting to one line
              overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${device.type}'),
                Text('Status: ${device.status}'),
              ],
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true, // Allows the modal to adjust dynamically
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

  // Controllers for text fields.
  late TextEditingController _nameController;
  late TextEditingController _osController;
  late TextEditingController _snController;
  late TextEditingController _colorController;
  late TextEditingController _storageController;
  late TextEditingController _departmentController;
  final TextEditingController _customCategoryController = TextEditingController();
  final TextEditingController _customStatusController = TextEditingController();

  // Dropdown selections.
  String? _selectedCategory;
  String? _selectedStatus;
  bool _isCustomCategory = false;
  bool _isCustomStatus = false;

  // Icon selection.
  IconData? _selectedIcon;

  // Predefined values.
  final List<String> _defaultStatuses = ['Active', 'Inactive'];
  // Use shared categories from categorySettingsNotifier if available.
  List<String> get _defaultCategories {
    // If no category exists, use these defaults.
    if (categorySettingsNotifier.value.isEmpty) {
      return [];
    }
    return categorySettingsNotifier.value.keys.toList();
  }

  // List of icon options.
  final List<IconData> _iconOptions = [
    Icons.phone_iphone,
    Icons.phone_android,
    Icons.laptop,
    Icons.devices_other
  ];

  // Add these inside _CreatePageState class
  Color _customCategoryColor = Colors.grey;
  IconData _customCategoryIcon = Icons.devices_other;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with template values if provided.
    _nameController = TextEditingController(text: widget.template?.name ?? '');
    _osController = TextEditingController(text: widget.template?.osVersion ?? '');
    _snController = TextEditingController(text: widget.template?.serialNumber ?? '');
    _colorController = TextEditingController(text: widget.template?.color ?? '');
    _storageController = TextEditingController(text: widget.template?.storage ?? '');
    _departmentController = TextEditingController(text: widget.template?.department ?? '');

    // Setup the device type.
    final templateType = widget.template?.type ?? '';
    if (templateType.isNotEmpty && !_defaultCategories.contains(templateType)) {
      // If the brand (templateType) isn’t available, set to the custom value.
      _selectedCategory = 'Custom';
      _customCategoryController.text = templateType;
      _isCustomCategory = true; // Unhide the custom field.
    } else {
      _selectedCategory = templateType.isNotEmpty
          ? templateType
          : (_defaultCategories.isEmpty ? 'Custom' : _defaultCategories.first);
      _isCustomCategory = _selectedCategory == 'Custom';
    }
    _selectedStatus = widget.template?.status ?? _defaultStatuses.first;
    _selectedIcon = widget.template?.icon ?? Icons.devices_other;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _osController.dispose();
    _snController.dispose();
    _colorController.dispose();
    _storageController.dispose();
    _departmentController.dispose();
    _customCategoryController.dispose();
    _customStatusController.dispose();
    super.dispose();
  }

  Future<void> _pickIcon() async {
    // Show a dialog for icon selection.
    final IconData? chosenIcon = await showDialog<IconData>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Icon'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              children: _iconOptions.map((iconData) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context, iconData),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(iconData, size: 32, color: _selectedIcon == iconData ? Colors.blue : Colors.black54),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    if (chosenIcon != null) {
      setState(() {
        _selectedIcon = chosenIcon;
      });
    }
  }

  Future<void> _pickCustomCategoryIcon() async {
    final IconData? chosenIcon = await showDialog<IconData>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Category Icon'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              children: _iconOptions.map((iconData) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context, iconData),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      iconData,
                      size: 32,
                      color: _customCategoryIcon == iconData ? Colors.blue : Colors.black54,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    if (chosenIcon != null) {
      setState(() {
        _customCategoryIcon = chosenIcon;
      });
    }
  }

  Future<void> _pickCustomCategoryColor() async {
    final Color? chosenColor = await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Category Color'),
          content: SizedBox(
            width: double.maxFinite,
            child: Wrap(
              spacing: 8,
              children: [
                Colors.grey,
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.orange,
                Colors.purple
              ].map((color) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context, color),
                  child: Container(
                    width: 40,
                    height: 40,
                    color: color,
                    margin: const EdgeInsets.all(4),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    if (chosenColor != null) {
      setState(() {
        _customCategoryColor = chosenColor;
      });
    }
  }

  void _saveDevice() {
    if (_formKey.currentState!.validate()) {
      // Use custom category if selected.
      final deviceCategory = _isCustomCategory
          ? _customCategoryController.text.trim()
          : _selectedCategory ?? 'Unknown';
      // Use custom status if selected.
      final deviceStatus = _isCustomStatus
          ? _customStatusController.text.trim()
          : _selectedStatus ?? 'Unknown';

      final newDevice = Device(
        name: _nameController.text.trim(),
        type: deviceCategory,
        osVersion: _osController.text.trim(),
        serialNumber: _snController.text.trim(),
        color: _colorController.text.trim(),
        storage: _storageController.text.trim(),
        icon: _selectedIcon ?? Icons.devices_other,
        status: deviceStatus,
        department: _departmentController.text.trim(),
      );

      // If it's a new category, add/update the shared category settings.
      if (_isCustomCategory) {
        final newCategory = _customCategoryController.text.trim();
        final currentSettings = categorySettingsNotifier.value;
        categorySettingsNotifier.value = {
          ...currentSettings,
          newCategory: {
            'icon': _customCategoryIcon,
            'color': _customCategoryColor,
          },
        };
      }

      setState(() {
        devices.add(newDevice); // Add the new device to the global list
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Device "${newDevice.name}" has been created!'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTemplate = widget.template != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isTemplate ? 'Create from Template' : 'Create Custom Device'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1. Name (Required)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name *'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              // 2. Type (Category) Dropdown with "Create new category"
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Device Type *'),
                items: [
                  ..._defaultCategories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))),
                  const DropdownMenuItem(value: 'Custom', child: Text('Create New Category')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    _isCustomCategory = value == 'Custom';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please select a device type';
                  if (value == 'Custom' && _customCategoryController.text.trim().isEmpty) {
                    return 'Please enter a device type';
                  }
                  return null;
                },
              ),
              if (_isCustomCategory)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _customCategoryController,
                      decoration: const InputDecoration(labelText: 'New Device Type *'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter a device type' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Category Icon:'),
                        const SizedBox(width: 12),
                        Icon(_customCategoryIcon, size: 32),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _pickCustomCategoryIcon,
                          child: const Text('Change Icon'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Category Color:'),
                        const SizedBox(width: 12),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _customCategoryColor,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _pickCustomCategoryColor,
                          child: const Text('Change Color'),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              // 3. OS (Required)
              TextFormField(
                controller: _osController,
                decoration: const InputDecoration(labelText: 'Operating System *'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the OS version' : null,
              ),
              const SizedBox(height: 16),
              // 4. Serial Number (Required)
              TextFormField(
                controller: _snController,
                decoration: const InputDecoration(labelText: 'Serial Number *'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a serial number' : null,
              ),
              const SizedBox(height: 16),
              // 5. Color (Optional)
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Color'),
              ),
              const SizedBox(height: 16),
              // 6. Storage (Optional)
              TextFormField(
                controller: _storageController,
                decoration: const InputDecoration(labelText: 'Storage'),
              ),
              const SizedBox(height: 16),
              // 7. Icon (Required) with an icon picker button
              Row(
                children: [
                  const Text('Icon *:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  Icon(_selectedIcon ?? Icons.devices_other, size: 32),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _pickIcon,
                    child: const Text('Choose Icon'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 8. Status Dropdown with "Create new status"
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status *'),
                items: [
                  ..._defaultStatuses.map((s) => DropdownMenuItem(value: s, child: Text(s))),
                  const DropdownMenuItem(value: 'Custom', child: Text('Create New Status')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                    _isCustomStatus = value == 'Custom';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please select a status';
                  if (value == 'Custom' && _customStatusController.text.trim().isEmpty) {
                    return 'Please enter a status';
                  }
                  return null;
                },
              ),
              if (_isCustomStatus)
                TextFormField(
                  controller: _customStatusController,
                  decoration: const InputDecoration(labelText: 'New Status *'),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a status' : null,
                ),
              const SizedBox(height: 16),
              // 9. Department (Required)
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'Department *'),
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