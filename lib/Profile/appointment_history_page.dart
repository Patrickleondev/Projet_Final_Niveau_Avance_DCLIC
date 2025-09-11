// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppointmentHistoryPage extends StatelessWidget {
  const AppointmentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> appointmentHistory = [
      {
        "date": "10 Avril 2025",
        "doctor": "Dr. Maxime DRE",
        "status": "Téléconsulté",
      },
      {
        "date": "05 Avril 2025",
        "doctor": "Dr. Ltk Mxz",
        "status": "En attente",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Historique des rendez-vous",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: appointmentHistory.length,
        itemBuilder: (context, index) {
          final appointment = appointmentHistory[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment["date"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appointment["doctor"]!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        appointment["status"]!,
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      appointment["status"]!,
                      style: TextStyle(
                        color: _getStatusColor(appointment["status"]!),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Téléconsulté":
        return Colors.green;
      case "En attente":
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }
}
