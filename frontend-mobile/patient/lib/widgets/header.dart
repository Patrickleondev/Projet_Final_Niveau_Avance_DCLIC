// import 'package:flutter/material.dart';

// class Header extends StatefulWidget {
//   const Header({super.key, required this.title});

//   final String title;

//   @override
//   State<Header> createState() => _HeaderState();
// }

// class _HeaderState extends State<Header> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 3), // Ombre légère
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Titre
//           Text(
//             widget.title,
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           // Notifications et Avatar
//           Row(
//             children: [
//               // Bouton de notification
//               IconButton(
//                 icon: const Icon(Icons.notifications),
//                 onPressed: () {
//                   print("Notification icon pressed");
//                 },
//               ),
//               // Avatar circulaire avec bouton
//               GestureDetector(
//                 onTap: () {
//                   print("Avatar pressed");
//                 },
//                 child: ClipOval(
//                   child: Image.asset(
//                     "assets/images/homme-serieux.jpg",
//                     width: 30,
//                     height: 30,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       // Gestion des erreurs si l'image n'est pas trouvée
//                       return const Icon(Icons.person, size: 30);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }