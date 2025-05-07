import 'package:flutter/material.dart';
import 'device.dart';
import 'device_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Chart config: order and visibility
  List<String> _chartOrder = ['type', 'status', 'department'];
  Map<String, bool> _chartVisibility = {
    'type': true,
    'status': true,
    'department': true,
  };

  Future<void> _refreshCharts() async {
    // Simulate a delay for refreshing (e.g., fetching data from a server)
    await Future.delayed(const Duration(seconds: 1));

    // Update the state to refresh the charts
    setState(() {});
  }

  List<Map<String, dynamic>> get _typeCategories => [
    {
      'name': 'iOS Devices',
      'count': devices.where((d) => d.type == 'iOS').length,
      'color': Colors.blue,
      'icon': Icons.phone_iphone,
    },
    {
      'name': 'Android Devices',
      'count': devices.where((d) => d.type == 'Android').length,
      'color': Colors.green,
      'icon': Icons.phone_android,
    },
    {
      'name': 'Windows Devices',
      'count': devices.where((d) => d.type == 'Windows').length,
      'color': Colors.orange,
      'icon': Icons.laptop,
    },
  ];

  List<Map<String, dynamic>> get _statusCategories {
    final statuses = devices.map((d) => d.status ?? 'Unknown').where((s) => s != null).toSet().toList();
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal];
    return List.generate(statuses.length, (i) {
      return {
        'name': statuses[i] ?? 'Unknown',
        'count': devices.where((d) => (d.status ?? 'Unknown') == statuses[i]).length,
        'color': colors[i % colors.length],
        'icon': Icons.assignment_turned_in,
      };
    });
  }

  List<Map<String, dynamic>> get _departmentCategories {
    final departments = devices.map((d) => d.department ?? 'Unknown').where((d) => d != null).toSet().toList();
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal];
    return List.generate(departments.length, (i) {
      return {
        'name': departments[i] ?? 'Unknown',
        'count': devices.where((d) => (d.department ?? 'Unknown') == departments[i]).length,
        'color': colors[i % colors.length],
        'icon': Icons.apartment,
      };
    });
  }

  void _showChartMenu() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Charts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  ..._chartOrder.map((chart) => Row(
                    children: [
                      Checkbox(
                        value: _chartVisibility[chart],
                        onChanged: (val) {
                          setStateSheet(() => _chartVisibility[chart] = val!);
                          setState(() => _chartVisibility[chart] = val!);
                        },
                      ),
                      Expanded(child: Text(_chartTitle(chart))),
                      IconButton(
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: () {
                          final idx = _chartOrder.indexOf(chart);
                          if (idx > 0) {
                            setStateSheet(() {
                              final tmp = _chartOrder[idx - 1];
                              _chartOrder[idx - 1] = _chartOrder[idx];
                              _chartOrder[idx] = tmp;
                            });
                            setState(() {
                              final tmp = _chartOrder[idx - 1];
                              _chartOrder[idx - 1] = _chartOrder[idx];
                              _chartOrder[idx] = tmp;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: () {
                          final idx = _chartOrder.indexOf(chart);
                          if (idx < _chartOrder.length - 1) {
                            setStateSheet(() {
                              final tmp = _chartOrder[idx + 1];
                              _chartOrder[idx + 1] = _chartOrder[idx];
                              _chartOrder[idx] = tmp;
                            });
                            setState(() {
                              final tmp = _chartOrder[idx + 1];
                              _chartOrder[idx + 1] = _chartOrder[idx];
                              _chartOrder[idx] = tmp;
                            });
                          }
                        },
                      ),
                    ],
                  )),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _chartTitle(String key) {
    switch (key) {
      case 'type':
        return 'Device Type';
      case 'status':
        return 'Status';
      case 'department':
        return 'Department';
      default:
        return key;
    }
  }

  Widget _buildChart(String key) {
    switch (key) {
      case 'type':
        return _ChartCard(title: 'Device Distribution', categories: _typeCategories, devices: devices);
      case 'status':
        return _ChartCard(title: 'Status Distribution', categories: _statusCategories, devices: devices);
      case 'department':
        return _ChartCard(title: 'Department Distribution', categories: _departmentCategories, devices: devices);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCharts, // Manual refresh button
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCharts, // Pull-to-refresh functionality
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Ensure scrollable even if content is small
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._chartOrder.where((key) => _chartVisibility[key] == true).map(_buildChart),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> categories;
  final List<Device> devices;
  const _ChartCard({required this.title, required this.categories, required this.devices});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: _DeviceBarChart(categories: categories, devices: devices),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final List<Device> devices;
  const _DeviceBarChart({required this.categories, required this.devices});

  @override
  Widget build(BuildContext context) {
    final total = categories.fold<int>(0, (sum, c) => sum + c['count'] as int);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: categories.map((category) {
        final percent = ((category['count'] / total) * 100).round();
        final barHeight = 120.0 * (category['count'] / (total == 0 ? 1 : total));
        return GestureDetector(
          onTap: () {
            String? filterKey;
            String? filterValue;
            if (category['icon'] == Icons.phone_iphone || category['icon'] == Icons.phone_android || category['icon'] == Icons.laptop) {
              filterKey = 'type';
              filterValue = category['name'].toString().replaceAll(' Devices', '');
            } else if (category['icon'] == Icons.assignment_turned_in) {
              filterKey = 'status';
              filterValue = category['name'];
            } else if (category['icon'] == Icons.apartment) {
              filterKey = 'department';
              filterValue = category['name'];
            }
            final filtered = devices.where((d) {
              if (filterKey == 'type') {
                return d.type == filterValue;
              } else if (filterKey == 'status') {
                return d.status == filterValue;
              } else if (filterKey == 'department') {
                return d.department == filterValue;
              }
              return false;
            }).toList();
            showModalBottomSheet(
              context: context,
              builder: (context) => _DeviceOverviewSheet(
                devices: filtered,
                title: category['name'], // Pass the clicked category name as the title
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$percent%',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 32,
                height: barHeight,
                decoration: BoxDecoration(
                  color: category['color'],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                category['icon'],
                color: category['color'],
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                category['name'].toString().replaceAll(' Devices', ''),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _DeviceOverviewSheet extends StatelessWidget {
  final List<Device> devices;
  final String title; // Add a title parameter

  const _DeviceOverviewSheet({required this.devices, required this.title}); // Update constructor

  @override
  Widget build(BuildContext context) {
    final typeColor = devices.isNotEmpty ? _typeColor(devices.first.type) : Colors.blue;
    final typeIcon = devices.isNotEmpty ? _typeIcon(devices.first.type) : Icons.devices_other;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: typeColor.withOpacity(0.15),
                  child: Icon(typeIcon, color: typeColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title, // Use the dynamic title here
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: typeColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: devices.length,
              separatorBuilder: (context, i) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final device = devices[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: typeColor.withOpacity(0.12),
                      child: Icon(device.icon, color: typeColor),
                    ),
                    title: Text(device.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Inv. Number: ${device.serialNumber}'),
                        Text('Status: ${device.status}'),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => _DeviceDetailSheet(device: device),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        isScrollControlled: true,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'iOS':
        return Colors.blue;
      case 'Android':
        return Colors.green;
      case 'Windows':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'iOS':
        return Icons.phone_iphone;
      case 'Android':
        return Icons.phone_android;
      case 'Windows':
        return Icons.laptop;
      default:
        return Icons.devices_other;
    }
  }
}

class _DeviceDetailSheet extends StatelessWidget {
  final Device device;
  const _DeviceDetailSheet({required this.device});

  String? _typeImage(String type) {
    switch (type) {
      case 'iOS':
        return 'lib/img/apple.png';
      case 'Android':
        return 'lib/img/android.png';
      case 'Windows':
        return 'lib/img/windows10.png';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = <Map<String, String?>>[
      {'label': 'Type', 'value': device.type},
      {'label': 'OS Version', 'value': device.osVersion},
      {'label': 'Serial Number', 'value': device.serialNumber},
      {'label': 'Color', 'value': device.color},
      {'label': 'Storage', 'value': device.storage},
      if (device.imei != null) {'label': 'IMEI', 'value': device.imei},
      if (device.processor != null) {'label': 'Processor', 'value': device.processor},
      if (device.ram != null) {'label': 'RAM', 'value': device.ram},
      {'label': 'Status', 'value': device.status},
      {'label': 'Department', 'value': device.department},
    ];
    final typeImg = _typeImage(device.type);
    return SafeArea(
      child: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (typeImg != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          height: 32,
                          width: 32,
                          child: Image.asset(typeImg, fit: BoxFit.contain),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        device.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...details.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Text(
                        '${item['label']}:',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item['value'] ?? '',
                          style: const TextStyle(color: Colors.black54),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}