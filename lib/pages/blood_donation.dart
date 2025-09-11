import 'package:flutter/material.dart';
import 'package:free_map/free_map.dart';

import 'notification_page.dart';
import '/Profile/profile.dart';

class BloodDonationPage extends StatefulWidget {
  const BloodDonationPage({super.key});

  @override
  State<BloodDonationPage> createState() => _BloodDonationPageState();
}

class _BloodDonationPageState extends State<BloodDonationPage> {
  FmData? _selectedAddress; // Adresse sélectionnée
  late final MapController _mapController; // Contrôleur de la carte
  final LatLng _initialLocation = const LatLng(
    48.8566,
    2.3522,
  ); // Paris par défaut
  final List<LatLng> _donationCenters = [
    const LatLng(48.8566, 2.3522), // Exemple : Centre 1
    const LatLng(48.8666, 2.3333), // Exemple : Centre 2
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Text(
              "Don de Sang",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
                );
              },
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/homme-serieux.jpg"),
                radius: 20,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              // Besoin urgent de sang
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5E5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bloodtype, color: Colors.red),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          "Besoins urgents de sang",
                          style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Urgence : Pénurie de sang de groupe O+",
                      style: TextStyle(
                        fontSize: screenHeight * 0.018,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.05,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Action pour voir les centres proches
                        },
                        child: const Text(
                          "Voir les centres proches",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Carte interactive
              Text(
                "Carte interactive",
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                height: screenHeight * 0.4,
                child: FmMap(
                  mapController: _mapController,
                  mapOptions: MapOptions(
                    initialZoom: 15,
                    initialCenter: _initialLocation,
                    minZoom: 10,
                    maxZoom: 18,
                    onTap: (tapPosition, point) async {
                      final address = await FmService().getAddress(
                        lat: point.latitude,
                        lng: point.longitude,
                      );
                      setState(() {
                        _selectedAddress = address;
                      });
                    },
                  ),
                  markers:
                      _donationCenters
                          .map(
                            (center) => Marker(
                              point: center,
                              child: const Icon(
                                Icons.local_hospital,
                                size: 40.0,
                                color: Colors.red,
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Liste des centres
              Text(
                "Liste des centres",
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildHospitalCard(
                context,
                name: "Hôpital Saint-Louis",
                address: "1 Avenue de Veyito, 9600",
                distance: "2.3 km",
                bloodGroup: "Groupe O+ requis",
                onDonate: () {
                  // Action pour enregistrer le don
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildHospitalCard(
                context,
                name: "Hôpital Krios",
                address: "46 Rue Litiki Binzin",
                distance: "3.8 km",
                bloodGroup: "Groupe A- requis",
                onDonate: () {
                  // Action pour enregistrer le don
                },
              ),
              SizedBox(height: screenHeight * 0.03),
              // Historique des dons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Historique de mes dons",
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Action pour voir tout l'historique
                    },
                    child: Text(
                      "Voir tout l'historique",
                      style: TextStyle(
                        fontSize: screenHeight * 0.018,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildDonationHistory(
                hospital: "Hôpital Krios",
                date: "15 janvier 2025",
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildDonationHistory(
                hospital: "Hôpital Kankan",
                date: "3 décembre 2024",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHospitalCard(
    BuildContext context, {
    required String name,
    required String address,
    required String distance,
    required String bloodGroup,
    required VoidCallback onDonate,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(address, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(distance, style: const TextStyle(color: Colors.grey)),
              Text(bloodGroup, style: const TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onDonate,
              child: const Text(
                "Donner ici",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationHistory({
    required String hospital,
    required String date,
  }) {
    return Row(
      children: [
        const Icon(Icons.bloodtype, color: Colors.red),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hospital, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(date, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
