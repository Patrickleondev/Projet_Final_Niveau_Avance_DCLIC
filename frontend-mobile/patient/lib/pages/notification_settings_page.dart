import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _medicationReminders = true;
  bool _appointmentReminders = true;
  bool _medicalResults = true;
  bool _generalNotifications = true;
  bool _emailNotifications = false;
  bool _pushNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _medicationReminders = prefs.getBool('medication_reminders') ?? true;
      _appointmentReminders = prefs.getBool('appointment_reminders') ?? true;
      _medicalResults = prefs.getBool('medical_results') ?? true;
      _generalNotifications = prefs.getBool('general_notifications') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? false;
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Paramètres de notifications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section Notifications Push
          _buildSectionCard(
            title: "Notifications Push",
            children: [
              _buildSwitchTile(
                title: "Notifications push",
                subtitle: "Recevoir des notifications sur votre appareil",
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                  _saveSetting('push_notifications', value);
                },
              ),
              _buildSwitchTile(
                title: "Rappels de médicaments",
                subtitle: "Notifications pour la prise de médicaments",
                value: _medicationReminders,
                onChanged: (value) {
                  setState(() {
                    _medicationReminders = value;
                  });
                  _saveSetting('medication_reminders', value);
                },
              ),
              _buildSwitchTile(
                title: "Rappels de rendez-vous",
                subtitle: "Notifications avant vos rendez-vous",
                value: _appointmentReminders,
                onChanged: (value) {
                  setState(() {
                    _appointmentReminders = value;
                  });
                  _saveSetting('appointment_reminders', value);
                },
              ),
              _buildSwitchTile(
                title: "Résultats médicaux",
                subtitle: "Notifications pour les nouveaux résultats",
                value: _medicalResults,
                onChanged: (value) {
                  setState(() {
                    _medicalResults = value;
                  });
                  _saveSetting('medical_results', value);
                },
              ),
              _buildSwitchTile(
                title: "Notifications générales",
                subtitle: "Actualités et mises à jour de l'application",
                value: _generalNotifications,
                onChanged: (value) {
                  setState(() {
                    _generalNotifications = value;
                  });
                  _saveSetting('general_notifications', value);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Section Notifications Email
          _buildSectionCard(
            title: "Notifications Email",
            children: [
              _buildSwitchTile(
                title: "Notifications par email",
                subtitle: "Recevoir des notifications par email",
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                  _saveSetting('email_notifications', value);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Section Actions
          _buildSectionCard(
            title: "Actions",
            children: [
              ListTile(
                leading: const Icon(Icons.clear_all, color: Colors.orange),
                title: const Text("Marquer toutes comme lues"),
                subtitle: const Text("Marquer toutes les notifications comme lues"),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Toutes les notifications ont été marquées comme lues'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_sweep, color: Colors.red),
                title: const Text("Supprimer toutes les notifications"),
                subtitle: const Text("Effacer l'historique des notifications"),
                onTap: () {
                  _showDeleteConfirmation();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.deepOrange,
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer toutes les notifications'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer toutes les notifications ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Toutes les notifications ont été supprimées'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
