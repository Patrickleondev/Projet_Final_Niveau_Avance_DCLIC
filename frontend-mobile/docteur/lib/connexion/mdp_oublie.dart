// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'login.dart'; // Page de connexion pour docteur

class ForgotPasswordDoctorPage extends StatefulWidget {
  const ForgotPasswordDoctorPage({super.key, required String title});

  @override
  State<ForgotPasswordDoctorPage> createState() =>
      _ForgotPasswordDoctorPageState();
}

class _ForgotPasswordDoctorPageState extends State<ForgotPasswordDoctorPage> {
  @override
  Widget build(BuildContext context) {
    Color mainColor = Colors.blue; // Couleur principale pour le docteur
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          height: screenHeight * 0.7,
          width: screenWidth * 0.9,
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/doctor.png",
                    height: 100,
                  ), // Image spécifique au docteur
                  const SizedBox(width: 10),
                  Text(
                    "SanoC - Docteur",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Mot de passe oublié",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: Text(
                      "Entrez votre adresse E-mail,\nPour réinitialiser votre mot de passe",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: screenHeight * 0.02),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                height: screenHeight * 0.06,
                child: TextField(
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.black),
                    labelText: "Votre adresse E-mail",
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor, width: 2),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.05,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Logique pour envoyer le mail de réinitialisation
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Réinitialisation du mot de passe"),
                          content: const Text(
                            "Un lien de réinitialisation a été envoyé à votre adresse E-mail.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                    // Logique pour envoyer le mail de réinitialisation
                  },
                  child: Text(
                    "Envoyer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.02,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vous vous en souvenez ?",
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const LogInDoctorPage(
                                  title: "SanoC - Docteur",
                                ),
                          ),
                        );
                      },
                      child: Text(
                        "Connectez-vous",
                        style: TextStyle(
                          color: mainColor,
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
