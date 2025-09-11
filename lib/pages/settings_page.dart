import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'Français';
  String _selectedTheme = 'Système';
  bool _biometricAuth = false;
  bool _autoSync = true;
  bool _dataUsage = false;

  final List<String> _languages = ['Français', 'English', 'العربية'];
  final List<String> _themes = ['Système', 'Clair', 'Sombre'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'Français';
      _selectedTheme = prefs.getString('theme') ?? 'Système';
      _biometricAuth = prefs.getBool('biometric_auth') ?? false;
      _autoSync = prefs.getBool('auto_sync') ?? true;
      _dataUsage = prefs.getBool('data_usage') ?? false;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Paramètres",
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
          // Section Apparence
          _buildSectionCard(
            title: "Apparence",
            children: [
              _buildDropdownTile(
                title: "Langue",
                subtitle: "Choisir la langue de l'application",
                value: _selectedLanguage,
                items: _languages,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  _saveSetting('language', value);
                },
              ),
              _buildDropdownTile(
                title: "Thème",
                subtitle: "Choisir le thème de l'application",
                value: _selectedTheme,
                items: _themes,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value!;
                  });
                  _saveSetting('theme', value);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Section Sécurité
          _buildSectionCard(
            title: "Sécurité",
            children: [
              _buildSwitchTile(
                title: "Authentification biométrique",
                subtitle: "Utiliser l'empreinte digitale ou Face ID",
                value: _biometricAuth,
                onChanged: (value) {
                  setState(() {
                    _biometricAuth = value;
                  });
                  _saveSetting('biometric_auth', value);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Section Données
          _buildSectionCard(
            title: "Données",
            children: [
              _buildSwitchTile(
                title: "Synchronisation automatique",
                subtitle: "Synchroniser automatiquement vos données",
                value: _autoSync,
                onChanged: (value) {
                  setState(() {
                    _autoSync = value;
                  });
                  _saveSetting('auto_sync', value);
                },
              ),
              _buildSwitchTile(
                title: "Utilisation des données mobiles",
                subtitle: "Permettre la synchronisation via les données mobiles",
                value: _dataUsage,
                onChanged: (value) {
                  setState(() {
                    _dataUsage = value;
                  });
                  _saveSetting('data_usage', value);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Section Stockage
          _buildSectionCard(
            title: "Stockage",
            children: [
              ListTile(
                leading: const Icon(Icons.storage, color: Colors.blue),
                title: const Text("Espace utilisé"),
                subtitle: const Text("2.3 MB"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showStorageInfo();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_sweep, color: Colors.orange),
                title: const Text("Nettoyer le cache"),
                subtitle: const Text("Libérer de l'espace de stockage"),
                onTap: () {
                  _clearCache();
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Section À propos
          _buildSectionCard(
            title: "À propos",
            children: [
              ListTile(
                leading: const Icon(Icons.info, color: Colors.green),
                title: const Text("Version de l'application"),
                subtitle: const Text("1.0.0"),
              ),
              ListTile(
                leading: const Icon(Icons.update, color: Colors.purple),
                title: const Text("Vérifier les mises à jour"),
                subtitle: const Text("Rechercher de nouvelles versions"),
                onTap: () {
                  _checkForUpdates();
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

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    );
  }

  void _showStorageInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informations de stockage'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Documents médicaux: 1.2 MB'),
            Text('Images: 0.8 MB'),
            Text('Cache: 0.3 MB'),
            SizedBox(height: 16),
            Text('Total: 2.3 MB'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nettoyer le cache'),
        content: const Text('Êtes-vous sûr de vouloir nettoyer le cache ?'),
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
                  content: Text('Cache nettoyé avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Nettoyer'),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recherche de mises à jour...'),
        backgroundColor: Colors.blue,
      ),
    );
    
    // Simuler la vérification
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous utilisez la dernière version'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}
