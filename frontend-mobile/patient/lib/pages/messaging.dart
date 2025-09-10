import 'package:flutter/material.dart';
// Import de la page Dashboard
import 'chat_page.dart';

class MessagingPage extends StatelessWidget {
  const MessagingPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // Liste des conversations (données simulées)
    final List<Map<String, String>> conversations = [
      {
        "name": "Dr. Ltk Mxz",
        "message": "Votre ordonnance est prête.",
        "time": "10:45",
        "avatar": "assets/images/homme-serieux.jpg",
      },
      {
        "name": "Dr. Paul LeChien",
        "message": "Les résultats de vos analyses sont disponibles.",
        "time": "Hier",
        "avatar": "assets/images/homme-serieux.jpg",
      },
      {
        "name": "Dr. Fernando POO",
        "message": "Confirmez votre RDV pour demain à 14h30.",
        "time": "Lun",
        "avatar": "assets/images/homme-serieux.jpg",
      },
      {
        "name": "Dr. Aristide DeRio",
        "message": "Merci de votre visite aujourd'hui.",
        "time": "28 jan",
        "avatar": "assets/images/homme-serieux.jpg",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Retourne à la page précédente (Dashboard)
          },
        ),
        title: const Text(
          "Messagerie",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Action pour rechercher une conversation
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return ListTile(
            leading: CircleAvatar(
              radius: screenHeight * 0.03,
              backgroundImage: AssetImage(conversation["avatar"]!),
            ),
            title: Text(
              conversation["name"]!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              conversation["message"]!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: Text(
              conversation["time"]!,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ChatPage(
                        doctorName: conversation["name"]!,
                        doctorAvatar: conversation["avatar"]!,
                      ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showDoctorSelectionDialog(context, conversations);
        },
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Nouveau message",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showDoctorSelectionDialog(
    BuildContext context,
    List<Map<String, String>> doctors,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choisir un docteur"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(doctor["avatar"]!),
                  ),
                  title: Text(doctor["name"]!),
                  onTap: () {
                    Navigator.pop(context); // Fermer la boîte de dialogue
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ChatPage(
                              doctorName: doctor["name"]!,
                              doctorAvatar: doctor["avatar"]!,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
          ],
        );
      },
    );
  }
}
