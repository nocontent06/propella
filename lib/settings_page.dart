import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  
  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// A simple Profile Details page.
class ProfileDetailPage extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  
  const ProfileDetailPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Details')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  const NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('First Name'),
              subtitle: Text(firstName),
            ),
            ListTile(
              title: const Text('Last Name'),
              subtitle: Text(lastName),
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(email),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsPageState extends State<SettingsPage> {
  // Language chooser.
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];
  
  // Profile info.
  final String _firstName = 'John';
  final String _lastName = 'Doe';
  final String _email = 'john.doe@example.com';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card at the top (tappable to view details).
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileDetailPage(
                    firstName: _firstName,
                    lastName: _lastName,
                    email: _email,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          const NetworkImage('https://via.placeholder.com/150'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$_firstName $_lastName',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(_email,
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Dark Mode Toggle using the callback.
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: widget.isDarkMode,
            onChanged: (val) {
              widget.onThemeChanged(val);
            },
            secondary:
                Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          ),
          const SizedBox(height: 16),
          // Language chooser.
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Language',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              border: OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                isDense: true,
                onChanged: (newLang) {
                  setState(() {
                    _selectedLanguage = newLang!;
                  });
                },
                items: _languages.map((lang) {
                  return DropdownMenuItem(
                    value: lang,
                    child: Text(lang),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Other default settings.
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Handle notifications settings.
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Handle privacy settings.
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('Version 1.1.0 (1B1)'),
            onTap: () {
              // Show about details.
            },
          ),
        ],
      ),
    );
  }
}