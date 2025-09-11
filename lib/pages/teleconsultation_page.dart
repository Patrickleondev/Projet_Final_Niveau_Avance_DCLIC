import 'package:flutter/material.dart';

class TeleconsultationPage extends StatelessWidget {
  final String doctorName;
  final String doctorSpecialty;
  final String doctorAvatar;
  final String nurseAvatar;
  final bool isVideoCall;

  const TeleconsultationPage({
    super.key,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorAvatar,
    required this.nurseAvatar,
    required this.isVideoCall,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isVideoCall ? "Appel Vidéo" : "Appel Audio"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Images du docteur et de l'infirmière
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(nurseAvatar),
                radius: 40,
              ),
              CircleAvatar(
                backgroundImage: AssetImage(doctorAvatar),
                radius: 40,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Informations du docteur
          Text(
            doctorName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            doctorSpecialty,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Spacer(),
          // Icône de l'appel
          Icon(
            isVideoCall ? Icons.videocam : Icons.call,
            size: 100,
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          // Bouton pour terminer l'appel
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Fin de l'appel
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
            ),
            child: const Icon(Icons.call_end, color: Colors.white),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
