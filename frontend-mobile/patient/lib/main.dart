import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/onboarding_page.dart';
import 'pages/createAccount.dart';
import 'pages/home.dart';
import 'services/firebase_auth_service.dart';
import 'services/notification_service.dart';
import 'services/profile_image_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final bool hasSeenOnboarding = await checkOnboardingStatus();
  runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
}

Future<bool> checkOnboardingStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hasSeenOnboarding') ?? false;
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const MyApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthService()),
        ChangeNotifierProvider(create: (_) => NotificationService()),
        ChangeNotifierProvider(create: (_) => ProfileImageService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SanoC - Santé Communautaire',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        initialRoute: hasSeenOnboarding ? '/login' : '/onboarding',
        routes: {
          '/onboarding': (context) => const OnboardingPage(),
          '/login': (context) => const CreateAccountPage(title: 'SanoC'),
          '/home': (context) => const HomePage(title: 'SanoC'),
        },
      ),
    );
  }
}
