// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';

// class HospitalsPage extends StatelessWidget {
//   const HospitalsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context); // Retour à la page précédente
//           },
//         ),
//         title: const Text(
//           "Hôpitaux",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Stack(
//         children: [
//           // Carte (placeholder pour une vraie carte)
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             color: const Color(
//               0xFFE8F4FF,
//             ), // Couleur de fond pour simuler une carte
//             child: Center(
//               child: Text(
//                 "Carte des hôpitaux (à intégrer avec Google Maps ou autre API)",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: screenHeight * 0.02,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//           ),
//           // Barre de recherche
//           Positioned(
//             top: screenHeight * 0.02,
//             left: screenWidth * 0.05,
//             right: screenWidth * 0.05,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.search, color: Colors.grey),
//                   SizedBox(width: screenWidth * 0.02),
//                   Expanded(
//                     child: TextField(
//                       cursorColor: Colors.deepOrange,
//                       decoration: const InputDecoration(
//                         hintText: "Rechercher un hôpital",
//                         border: InputBorder.none,
//                       ),
//                       onChanged: (value) {
//                         // Action pour rechercher un hôpital
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Contenu en bas
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(screenWidth * 0.05),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, -5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Nom de l'hôpital
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Hôpital Saint-Louis",
//                             style: TextStyle(
//                               fontSize: screenHeight * 0.025,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: screenHeight * 0.005),
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.location_on,
//                                 size: 16,
//                                 color: Colors.red,
//                               ),
//                               Text(
//                                 "2.3 km",
//                                 style: TextStyle(
//                                   fontSize: screenHeight * 0.018,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Text(
//                                 "• Ouvert 24/7",
//                                 style: TextStyle(
//                                   fontSize: screenHeight * 0.018,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       IconButton(
//                         icon: const Icon(
//                           Icons.favorite_border,
//                           color: Colors.red,
//                         ),
//                         onPressed: () {
//                           // Action pour ajouter aux favoris
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: screenHeight * 0.02),
//                   // Services disponibles
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _buildServiceIcon(
//                         icon: Icons.local_hospital,
//                         label: "Urgences",
//                         screenHeight: screenHeight,
//                       ),
//                       _buildServiceIcon(
//                         icon: Icons.medical_services,
//                         label: "Chirurgie",
//                         screenHeight: screenHeight,
//                       ),
//                       _buildServiceIcon(
//                         icon: Icons.child_care,
//                         label: "Pédiatrie",
//                         screenHeight: screenHeight,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: screenHeight * 0.03),
//                   // Bouton "Démarrer l'itinéraire"
//                   SizedBox(
//                     width: double.infinity,
//                     height: screenHeight * 0.06,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onPressed: () {
//                         // Action pour démarrer l'itinéraire
//                       },
//                       child: const Text(
//                         "Démarrer l'itinéraire",
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildServiceIcon({
//     required IconData icon,
//     required String label,
//     required double screenHeight,
//   }) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: screenHeight * 0.03,
//           backgroundColor: const Color(0xFFE8F4FF),
//           child: Icon(icon, color: Colors.blue, size: screenHeight * 0.03),
//         ),
//         SizedBox(height: screenHeight * 0.01),
//         Text(
//           label,
//           style: TextStyle(fontSize: screenHeight * 0.018, color: Colors.grey),
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:free_map/free_map.dart';
import '../services/maps_service.dart';

class HospitalsPage extends StatefulWidget {
  const HospitalsPage({super.key});

  @override
  State<HospitalsPage> createState() => _HospitalsPageState();
}

class _HospitalsPageState extends State<HospitalsPage> {
  FmData? _selectedAddress; // Adresse sélectionnée
  late final MapController _mapController; // Contrôleur de la carte
  final LatLng _initialLocation = const LatLng(
    48.8566,
    2.3522,
  ); // Paris par défaut
  final LatLng _hospitalLocation = const LatLng(
    48.8666,
    2.3333,
  ); // Exemple : Hôpital Lariboisière

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
        title: const Text(
          "Hôpitaux",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: FmSearchField(
              selectedValue: _selectedAddress,
              searchParams: const FmSearchParams(),
              onSelected: (data) {
                setState(() {
                  _selectedAddress = data;
                  if (data != null) {
                    _mapController.move(LatLng(data.lat, data.lng), 15.0);
                  }
                });
              },
              textFieldBuilder: (focusNode, controller, onChanged) {
                return TextFormField(
                  focusNode: focusNode,
                  controller: controller,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: "Rechercher un hôpital",
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon:
                        controller.text.trim().isEmpty || !focusNode.hasFocus
                            ? null
                            : IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: controller.clear,
                            ),
                  ),
                );
              },
            ),
          ),
          // Carte interactive
          Expanded(
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
              markers: [
                Marker(
                  point: _initialLocation,
                  child: const Icon(
                    Icons.location_on,
                    size: 40.0,
                    color: Colors.red,
                  ),
                ),
                Marker(
                  point: _hospitalLocation,
                  child: const Icon(
                    Icons.local_hospital,
                    size: 40.0,
                    color: Colors.blue,
                  ),
                ),
              ],
              polylineOptions: const FmPolylineOptions(
                strokeWidth: 3,
                color: Colors.blue,
              ),
            ),
          ),
          // Contenu en bas
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Adresse sélectionnée
                  Text(
                    "Adresse sélectionnée : ${_selectedAddress?.address ?? "Aucune"}",
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Bouton "Démarrer l'itinéraire"
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (_selectedAddress != null) {
                          // Ouvrir Google Maps avec l'adresse sélectionnée
                          final success = await MapsService.getDirectionsTo(
                            destination: _selectedAddress!.address,
                          );
                          
                          if (!success) {
                            // Fallback : ouvrir Google Maps avec l'hôpital par défaut
                            await MapsService.getDirectionsTo(
                              destination: "Hôpital Lariboisière, Paris",
                            );
                          }
                        } else {
                          // Si aucune adresse sélectionnée, ouvrir Google Maps avec l'hôpital par défaut
                          await MapsService.getDirectionsTo(
                            destination: "Hôpital Lariboisière, Paris",
                          );
                        }
                      },
                      child: const Text(
                        "Démarrer l'itinéraire",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
