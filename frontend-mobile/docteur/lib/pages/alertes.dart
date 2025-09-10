import 'package:flutter/material.dart';

class AlertesPage extends StatefulWidget {
  const AlertesPage({super.key});

  @override
  State<AlertesPage> createState() => _AlertesPageState();
}

class _AlertesPageState extends State<AlertesPage> {
  final List<Map<String, dynamic>> bloodGroups = [
    {
      "group": "A+",
      "status": "Critique",
      "color": Colors.red,
      "isActive": true,
    },
    {
      "group": "A-",
      "status": "Stable",
      "color": Colors.green,
      "isActive": false,
    },
    {
      "group": "B+",
      "status": "Modéré",
      "color": Colors.orange,
      "isActive": false,
    },
    {
      "group": "B-",
      "status": "Critique",
      "color": Colors.red,
      "isActive": true,
    },
    {
      "group": "AB+",
      "status": "Stable",
      "color": Colors.green,
      "isActive": false,
    },
    {
      "group": "AB-",
      "status": "Modéré",
      "color": Colors.orange,
      "isActive": false,
    },
    {
      "group": "O+",
      "status": "Critique",
      "color": Colors.red,
      "isActive": true,
    },
    {
      "group": "O-",
      "status": "Stable",
      "color": Colors.green,
      "isActive": false,
    },
  ];

  void _toggleAlert(int index) {
    setState(() {
      bloodGroups[index]["isActive"] = !bloodGroups[index]["isActive"];
    });
  }

  void _sendAlert() {
    // Logique pour envoyer une alerte aux donneurs
    final activeGroups =
        bloodGroups
            .where((group) => group["isActive"] == true)
            .map((group) => group["group"])
            .toList();

    if (activeGroups.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Alerte envoyée pour les groupes sanguins : ${activeGroups.join(", ")}",
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Aucune alerte active à envoyer."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gestion des Alertes",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/homme-serieux.jpg"),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            // Bouton pour envoyer une alerte
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(screenWidth, 50),
              ),
              onPressed: _sendAlert,
              icon: const Icon(Icons.notifications, color: Colors.white),
              label: const Text(
                "Envoyer une alerte aux donneurs",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // Liste des groupes sanguins
            Expanded(
              child: ListView.builder(
                itemCount: bloodGroups.length,
                itemBuilder: (context, index) {
                  final group = bloodGroups[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: group["color"].withOpacity(0.2),
                        child: Text(
                          group["group"],
                          style: TextStyle(
                            color: group["color"],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        "Groupe ${group["group"]}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        group["status"],
                        style: TextStyle(color: group["color"]),
                      ),
                      trailing: Switch(
                        value: group["isActive"],
                        activeThumbColor: Colors.red,
                        onChanged: (value) {
                          _toggleAlert(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Onglet "Alertes" sélectionné
        onTap: (index) {
          // Navigation entre les onglets
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Rendez-vous",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: "Dossiers Médicaux",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.red),
            label: "Alertes",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
        ],
      ),
    );
  }
}
