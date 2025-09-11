import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'createAccount.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: "Bienvenue sur SanoC",
      description: "Votre application de santé communautaire pour un accès facilité aux soins",
      image: "assets/images/onboarding1.jpg",
      icon: Icons.local_hospital,
    ),
    OnboardingItem(
      title: "Gestion des rendez-vous",
      description: "Prenez facilement rendez-vous avec vos médecins et suivez vos consultations",
      image: "assets/images/onboarding2.jpg",
      icon: Icons.calendar_today,
    ),
    OnboardingItem(
      title: "Dossier médical",
      description: "Accédez à vos dossiers médicaux en toute sécurité, où que vous soyez",
      image: "assets/images/onboarding3.jpg",
      icon: Icons.folder,
    ),
    OnboardingItem(
      title: "Rappels de médicaments",
      description: "Ne manquez plus vos prises de médicaments grâce à nos rappels intelligents",
      image: "assets/images/onboarding4.jpg",
      icon: Icons.medication,
    ),
    OnboardingItem(
      title: "Don de sang",
      description: "Contribuez à sauver des vies en participant aux dons de sang",
      image: "assets/images/onboarding5.jpg",
      icon: Icons.favorite,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < _items.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        // Revenir au début après la dernière page
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void _restartAutoScroll() {
    _stopAutoScroll();
    _startAutoScroll();
  }

  void _onNextPage() {
    _restartAutoScroll(); // Redémarrer le timer après interaction manuelle
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateAccountPage(title: 'SanoC'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  _restartAutoScroll(); // Redémarrer le timer après changement de page
                },
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingItem(_items[index]);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingItem(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            width: 250,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.deepOrange[100],
                    child: Icon(
                      item.icon,
                      size: 80,
                      color: Colors.deepOrange[700],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Titre
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // Description
          Text(
            item.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Indicateurs de page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _items.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index 
                      ? Colors.deepOrange 
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // Bouton suivant/commencer
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _currentPage < _items.length - 1 ? 'Suivant' : 'Commencer',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          
          // Bouton passer
          if (_currentPage < _items.length - 1) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: _finishOnboarding,
              child: Text(
                'Passer',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;
  final IconData icon;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
  });
}
