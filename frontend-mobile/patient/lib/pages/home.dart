import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'medical_record_page.dart';
import 'messaging.dart';
import 'meetingPage.dart';
import 'rappels_medicaments.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> pages = [
    DashboardPage(),
    MeetingPage(),
    MedicalRecordPage(),
    MedicationRemindersPage(),
    MessagingPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Rendez-vous",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_present),
            label: "Dossier Médical",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_outlined),
            label: "Rappels",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
        ],
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
