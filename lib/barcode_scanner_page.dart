import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'create_page.dart';
import 'device.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _isScanning = true;
  final MobileScannerController _controller = MobileScannerController();

  Future<void> _processBarcode(String code) async {
    // Using the free UPCItemDB API endpoint.
    final url = Uri.parse('https://api.upcitemdb.com/prod/trial/lookup?upc=$code');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Check if the API returned OK and at least one item.
        if (data['code'] == 'OK' && (data['total'] ?? 0) > 0) {
          final item = data['items'][0];
          // If a title exists, build a template and redirect.
          if (item['title'] != null && item['title'].toString().trim().isNotEmpty) {
            // Construct a device template from the API info.
            final deviceTemplate = Device(
              name: item['title'] ?? '',
              // Use the brand from the API response:
              type: item['brand'] ?? 'Unknown',
              osVersion: '', // Not provided by the API.
              serialNumber: code, // Using the barcode as serial.
              color: '',
              storage: '',
              icon: Icons.phone_android, // Or choose a representative icon.
              status: 'Active',
              department: '',
            );
            // Replace the current page with the CreatePage using pushReplacement.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePage(template: deviceTemplate),
              ),
            );
          } else {
            _showError('No valid product title found for barcode: $code');
          }
        } else {
          _showError('No product found for barcode: $code');
        }
      } else {
        _showError('Failed to get product info (status: ${response.statusCode}).');
      }
    } catch (error) {
      _showError('Error occurred: $error');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isScanning = true;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: MobileScanner(
        controller: _controller,
        onDetect: (BarcodeCapture capture) {
          if (!_isScanning) return;
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null) {
              setState(() {
                _isScanning = false;
              });
              _processBarcode(code);
            }
          }
        },
      ),
    );
  }
}