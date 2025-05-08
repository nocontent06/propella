import 'package:flutter/material.dart';

class Device {
  String name;
  String type;
  String osVersion;
  String serialNumber;
  String color;
  String storage;
  String? imei;
  String? processor;
  String? ram;
  IconData icon;
  String status;
  String department;

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