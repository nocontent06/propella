import 'package:flutter/material.dart';

final ValueNotifier<Map<String, Map<String, dynamic>>> categorySettingsNotifier =
    ValueNotifier<Map<String, Map<String, dynamic>>>({
  'iOS': {'icon': Icons.phone_iphone, 'color': Colors.blue},
  'Android': {'icon': Icons.phone_android, 'color': Colors.green},
  'Windows': {'icon': Icons.laptop, 'color': Colors.orange},
});