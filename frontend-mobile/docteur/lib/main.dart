import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/home.dart';
import 'pages/rendez_vous.dart';
import 'pages/patient_liste.dart';
import 'pages/profile_page.dart';
import 'services/firebase_auth_service.dart';
import 'services/notification_service.dart';
import 'services/profile_image_service.dart';
import 'services/appointment_service.dart';
import 'services/patient_service.dart';
import 'services/medical_record_service.dart';
import 'services/blood_donation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthService()),
        ChangeNotifierProvider(create: (_) => NotificationService()),
        ChangeNotifierProvider(create: (_) => ProfileImageService()),
        ChangeNotifierProvider(create: (_) => AppointmentService()),
        ChangeNotifierProvider(create: (_) => PatientService()),
        ChangeNotifierProvider(create: (_) => MedicalRecordService()),
        ChangeNotifierProvider(create: (_) => BloodDonationService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SanoC Docteur',
        theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        home: const LoginPage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(title: "SanoC Docteur"),
          '/rendez_vous': (context) => const RendezVousPage(),
          '/patient_liste': (context) => const PatientListePage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
