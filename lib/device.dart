import 'package:flutter/material.dart';

class Device {
  final String name;
  final String type;
  final String osVersion;
  final String serialNumber;
  final String color;
  final String storage;
  final String? imei;
  final String? processor;
  final String? ram;
  final IconData icon;
  final String status;
  final String department;

  Device({
    required this.name,
    required this.type,
    required this.osVersion,
    required this.serialNumber,
    required this.color,
    required this.storage,
    this.imei,
    this.processor,
    this.ram,
    required this.icon,
    this.status = 'Active',
    this.department = 'DEP1',
  });
} 