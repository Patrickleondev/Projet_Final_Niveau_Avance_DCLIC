// ignore_for_file: file_names

import 'package:another_flushbar/flushbar.dart';
import 'login.dart';
import 'package:flutter/material.dart';

class CreateAccountDoctorPage extends StatefulWidget {
  const CreateAccountDoctorPage({super.key, required String title});

  @override
  State<CreateAccountDoctorPage> createState() =>
      _CreateAccountDoctorPageState();
}

class _CreateAccountDoctorPageState extends State<CreateAccountDoctorPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool verifierMotDePasse() {
    if (passwordController.text == confirmPasswordController.text) {
      return true;
    } else {
      Flushbar(
        title: "Erreur",
        message: "Les mots de passe ne correspondent pas !",
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(20),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.error, size: 28.0, color: Colors.white),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ).show(context);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Color mainColor = Colors.blue; // Couleur principale pour le docteur
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth * 0.9,
            height: screenHeight,
            padding: EdgeInsets.only(top: screenHeight * 0.05),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/doctor.png", // Image spécifique au docteur
                      height: screenWidth * 0.2,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "SanoC - Docteur",
                      style: TextStyle(
                        fontSize: screenHeight * 0.045,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Inscription Docteur",
                      style: TextStyle(
                        fontSize: screenWidth * 0.075,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Inscrivez-vous pour gérer vos patients et vos services de santé",
                        softWrap: true,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: mainColor,
                        controller: nameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person_outline_sharp,
                            color: Colors.black,
                          ),
                          labelText: "Nom",
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor, width: 2),
                          ),
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? "Veuillez entrer votre nom"
                                    : null,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        cursorColor: mainColor,
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                          ),
                          labelText: "Email",
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Veuillez entrer votre email";
                          } else if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                          ).hasMatch(value)) {
                            return "Veuillez entrer un email valide";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        cursorColor: mainColor,
                        controller: passwordController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock_outlined,
                            color: Colors.black,
                          ),
                          labelText: "Mot de passe",
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Veuillez entrer votre mot de passe";
                          } else if (value.length < 6) {
                            return "Le mot de passe doit contenir au moins 6 caractères";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        cursorColor: mainColor,
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock_outlined,
                            color: Colors.black,
                          ),
                          labelText: "Confirmer le mot de passe",
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Veuillez confirmer votre mot de passe";
                          } else if (value.length < 6) {
                            return "Le mot de passe doit contenir au moins 6 caractères";
                          } else if (!verifierMotDePasse()) {
                            return "Les mots de passe ne correspondent pas !";
                          }
                          return null;
                        },
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
                            if (formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const LogInDoctorPage(
                                        showNotification: true,
                                        title: 'SanoC - Docteur',
                                      ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "S'inscrire",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.02,
                            ),
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
      ),
    );
  }
}
