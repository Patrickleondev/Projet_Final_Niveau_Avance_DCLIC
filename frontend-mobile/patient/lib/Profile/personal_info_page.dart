import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();

  // Champs modifiables
  String _fullName = "Ltk Mxz";
  String _email = "a96.paul96@gmail.com";
  String _phoneNumber = "+228 90 00 00 00";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Informations personnelles",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEditableField(
                icon: Icons.person,
                title: "Nom complet",
                initialValue: _fullName,
                onSaved: (value) {
                  _fullName = value ?? _fullName;
                },
              ),
              const Divider(height: 32, color: Colors.grey),
              _buildEditableField(
                icon: Icons.email,
                title: "Email",
                initialValue: _email,
                onSaved: (value) {
                  _email = value ?? _email;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un email valide.";
                  }
                  if (!RegExp(
                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                  ).hasMatch(value)) {
                    return "Format d'email invalide.";
                  }
                  return null;
                },
              ),
              const Divider(height: 32, color: Colors.grey),
              _buildEditableField(
                icon: Icons.phone,
                title: "Numéro de téléphone",
                initialValue: _phoneNumber,
                onSaved: (value) {
                  _phoneNumber = value ?? _phoneNumber;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un numéro de téléphone.";
                  }
                  if (!RegExp(r"^\+?[0-9\s]+$").hasMatch(value)) {
                    return "Format de numéro invalide.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Informations mises à jour avec succès !",
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Enregistrer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required IconData icon,
    required String title,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.deepOrange, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: initialValue,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onSaved: onSaved,
                validator: validator,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
