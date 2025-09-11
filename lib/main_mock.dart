import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'pages/onboarding_page.dart';
import 'pages/createAccount.dart';
import 'pages/home.dart';
import 'services/mock_auth_service.dart';
import 'services/mock_notification_service.dart';
import 'services/mock_profile_image_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
        ChangeNotifierProvider(create: (_) => MockAuthService()),
        ChangeNotifierProvider(create: (_) => MockNotificationService()),
        ChangeNotifierProvider(create: (_) => MockProfileImageService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SanoC - Santé Communautaire (Mode Test)',
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
