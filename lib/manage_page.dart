import 'package:flutter/material.dart';
import 'device.dart';
import 'device_data.dart';
import 'edit_device_page.dart';
import 'category_settings.dart'; // Import the shared settings

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _GroupedDevicesPageState();
}

class _GroupedDevicesPageState extends State<ManagePage> {
  // Group devices by category (using the device.type property)
  Map<String, List<Device>> _groupDevices() {
    final Map<String, List<Device>> groups = {};
    for (final device in devices) {
      groups.putIfAbsent(device.type, () => []).add(device);
    }
    return groups;
  }

  @override
  void initState() {
    super.initState();
    // Ensure each device category has an entry in the global mapping.
    final existingCategories = devices.map((d) => d.type).toSet();
    final current = categorySettingsNotifier.value;
    for (final cat in existingCategories) {
      if (!current.containsKey(cat)) {
        current[cat] = {
          'color': Colors.grey,
          'icon': Icons.devices_other,
        };
      }
    }
    categorySettingsNotifier.value = Map.from(current);
  }

  void _editCategory(String oldCategory) async {
    final TextEditingController nameController =
        TextEditingController(text: oldCategory);
    // Local preset options:
    final List<Color> colorOptions = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal];
    final List<IconData> iconOptions = [Icons.phone_iphone, Icons.phone_android, Icons.laptop, Icons.devices_other];
    // Get current settings or default:
    final currentSettings = categorySettingsNotifier.value[oldCategory] ?? {'color': Colors.grey, 'icon': Icons.devices_other};
    Color selectedColor = currentSettings['color'];
    IconData selectedIcon = currentSettings['icon'];

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return AlertDialog(
              title: const Text('Edit Category'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Category Name'),
                    ),
                    const SizedBox(height: 16),
                    // Color Picker (simple row of options)
                    Row(
                      children: colorOptions.map((color) {
                        return GestureDetector(
                          onTap: () {
                            setStateSheet(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedColor == color ? Colors.black : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Icon Picker (simple row of options)
                    Row(
                      children: iconOptions.map((iconData) {
                        return GestureDetector(
                          onTap: () {
                            setStateSheet(() {
                              selectedIcon = iconData;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selectedIcon == iconData ? Colors.black12 : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(iconData, color: selectedIcon == iconData ? selectedColor : Colors.grey),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'name': nameController.text.trim(),
                        'color': selectedColor,
                        'icon': selectedIcon,
                      });
                    },
                    child: const Text('Save')),
              ],
            );
          },
        );
      },
    );

    if (result != null && result['name'] != null && result['name'] != '') {
      setState(() {
        // Check if the category name changed.
        if (result['name'] != oldCategory) {
          // Update each device in the group.
          for (final device in devices.where((d) => d.type == oldCategory)) {
            device.type = result['name'];
          }
          // Remove old mapping and add new one.
          final updated = Map<String, Map<String, dynamic>>.from(categorySettingsNotifier.value);
          updated.remove(oldCategory);
          updated[result['name']] = {
            'color': result['color'],
            'icon': result['icon'],
          };
          categorySettingsNotifier.value = updated;
        } else {
          // If only color/icon changed; update mapping for current category.
          final updated = Map<String, Map<String, dynamic>>.from(categorySettingsNotifier.value);
          updated[oldCategory] = {
            'color': result['color'],
            'icon': result['icon'],
          };
          categorySettingsNotifier.value = updated;
        }
      });
    }
  }

  void _editDevice(Device device) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDevicePage(device: device),
      ),
    );
    setState(() {}); // Refresh device list after editing
  }

  Widget _buildAvatar(String category, Device device) {
    final settings = categorySettingsNotifier.value[category] ?? {'color': Colors.blue[200], 'icon': device.icon};
    return CircleAvatar(
      backgroundColor: settings['color'] as Color?,
      child: Icon(
        settings['icon'] as IconData,
        color: Colors.white,
      ),
    );
  }

  Future<void> _refreshDevices() async {
    // Simulate fetching devices (update this to fetch your devices if needed)
    await Future.delayed(const Duration(seconds: 1));
    setState(() {}); // Update the UI with the latest device list.
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groupDevices();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices Overview'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDevices,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            children: groups.keys.map((category) {
              // Get settings for header display.
              final settings = categorySettingsNotifier.value[category] ??
                  {'color': Colors.grey, 'icon': Icons.devices_other};
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ExpansionTile(
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Row(
                    children: [
                      Icon(
                        settings['icon'],
                        color: settings['color'],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: settings['color'],
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _editCategory(category),
                      ),
                    ],
                  ),
                  children: groups[category]!.map((device) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Theme.of(context)
                            .cardColor, // Uses theme's cardColor instead of white.
                        child: ListTile(
                          leading: _buildAvatar(category, device),
                          title: Text(
                            device.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          subtitle: Text(
                            'OS: ${device.osVersion}\nSN: ${device.serialNumber}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          isThreeLine: false,
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editDevice(device),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}