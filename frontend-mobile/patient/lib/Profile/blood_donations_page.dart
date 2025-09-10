// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class BloodDonationsPage extends StatelessWidget {
  const BloodDonationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> bloodDonations = [
      {
        "date": "12 Mars 2025",
        "location": "Centre Médical Point E",
        "status": "Réussi",
      },
      {
        "date": "20 Janvier 2025",
        "location": "Hôpital Général de Lomé",
        "status": "Réussi",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mes dons de sang",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: bloodDonations.length,
        itemBuilder: (context, index) {
          final donation = bloodDonations[index];
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
                    donation["date"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    donation["location"]!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Réussi",
                      style: TextStyle(color: Colors.green, fontSize: 14),
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
}
