// import 'package:flutter/material.dart';
// import '/pages/home.dart'; // Remplacez par la page d'accueil pour docteur si différente
// import 'inscription.dart'; // Page d'inscription pour docteur
// import 'mdp_oublie.dart'; // Page de mot de passe oublié
// import 'package:another_flushbar/flushbar.dart';

// class LogInDoctorPage extends StatefulWidget {
//   const LogInDoctorPage({
//     super.key,
//     required this.title,
//     this.showNotification = false,
//   });

//   final String title;
//   final bool showNotification; // Indicateur pour afficher la notification

//   @override
//   State<LogInDoctorPage> createState() => _LogInDoctorPageState();
// }

// class _LogInDoctorPageState extends State<LogInDoctorPage> {
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final FocusNode focusNodePassword = FocusNode();
//   bool visible = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.showNotification) {
//       Future.delayed(const Duration(milliseconds: 300), () {
//         afficherNotification(context);
//       });
//     }
//   }

//   void afficherNotification(BuildContext context) {
//     Flushbar(
//       title: "Inscription réussie !",
//       icon: const Icon(Icons.check_circle, size: 28.0, color: Colors.white),
//       message: "Votre compte a été enregistré avec succès.",
//       margin: const EdgeInsets.all(8),
//       borderRadius: BorderRadius.circular(20),
//       flushbarPosition: FlushbarPosition.TOP,
//       duration: const Duration(seconds: 3),
//       backgroundColor: Colors.green,
//     ).show(context);
//   }

//   @override
//   void dispose() {
//     focusNodePassword.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     Color mainColor = Colors.blue; // Couleur principale pour le docteur
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Center(
//         child: SingleChildScrollView(
//           child: SizedBox(
//             width: screenWidth * 0.9,
//             height: screenHeight * 0.9,
//             child: ListView(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       "assets/images/homme-serieux.jpg", // Image spécifique au docteur
//                       height: screenWidth * 0.2,
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       "SanoC - Docteur",
//                       style: TextStyle(
//                         fontSize: screenHeight * 0.045,
//                         fontWeight: FontWeight.w300,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: screenHeight * 0.03),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Connexion Docteur",
//                       style: TextStyle(
//                         fontSize: screenWidth * 0.075,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         "Connectez-vous pour gérer vos patients et vos services de santé.",
//                         softWrap: true,
//                         maxLines: 2,
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.05,
//                           fontWeight: FontWeight.w300,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: screenHeight * 0.05),
//                 Form(
//                   key: formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         cursorColor: mainColor,
//                         controller: emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(
//                           prefixIcon: const Icon(
//                             Icons.email_outlined,
//                             color: Colors.black,
//                           ),
//                           labelText: "Votre adresse email",
//                           labelStyle: const TextStyle(color: Colors.grey),
//                           border: const OutlineInputBorder(),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: mainColor, width: 2),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Veuillez entrer votre adresse email";
//                           }
//                           if (!RegExp(
//                             r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
//                           ).hasMatch(value)) {
//                             return "Veuillez entrer une adresse email valide";
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: screenHeight * 0.02),
//                       TextFormField(
//                         cursorColor: mainColor,
//                         controller: passwordController,
//                         focusNode: focusNodePassword,
//                         obscureText: !visible,
//                         decoration: InputDecoration(
//                           prefixIcon: const Icon(
//                             Icons.lock_outline,
//                             color: Colors.black,
//                           ),
//                           suffixIcon: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 visible = !visible;
//                               });
//                             },
//                             icon: Icon(
//                               visible ? Icons.visibility_off : Icons.visibility,
//                               color: Colors.black,
//                             ),
//                           ),
//                           labelText: "Entrez votre mot de passe",
//                           labelStyle: const TextStyle(
//                             color: Colors.grey,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: mainColor, width: 2),
//                           ),
//                           border: const OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Veuillez entrer votre mot de passe";
//                           }
//                           if (value.length < 6) {
//                             return "Le mot de passe doit contenir au moins 6 caractères";
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: screenHeight * 0.02),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (context) =>
//                                           const ForgotPasswordDoctorPage(
//                                             title: "SanoC",
//                                           ),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               "Mot de passe oublié ?",
//                               style: TextStyle(color: mainColor, fontSize: 16),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: screenHeight * 0.02),
//                       SizedBox(
//                         width: screenWidth * 0.9,
//                         height: screenHeight * 0.05,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: mainColor,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           onPressed: () {
//                             if (formKey.currentState!.validate()) {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (context) => const HomePage(
//                                         title: "SanoC - Docteur",
//                                       ),
//                                 ),
//                               );
//                             }
//                           },
//                           child: Text(
//                             "Se connecter",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: screenHeight * 0.02,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '/pages/home.dart'; // Remplacez par la page d'accueil pour docteur si différente
// Page d'inscription pour docteur
import 'mdp_oublie.dart'; // Page de mot de passe oublié
import 'package:another_flushbar/flushbar.dart';

class LogInDoctorPage extends StatefulWidget {
  const LogInDoctorPage({
    super.key,
    required this.title,
    this.showNotification = false,
  });

  final String title;
  final bool showNotification; // Indicateur pour afficher la notification

  @override
  State<LogInDoctorPage> createState() => _LogInDoctorPageState();
}

class _LogInDoctorPageState extends State<LogInDoctorPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode focusNodePassword = FocusNode();
  bool visible = false;

  @override
  void initState() {
    super.initState();
    if (widget.showNotification) {
      Future.delayed(const Duration(milliseconds: 300), () {
        afficherNotification(context);
      });
    }
  }

  void afficherNotification(BuildContext context) {
    Flushbar(
      title: "Inscription réussie !",
      icon: const Icon(Icons.check_circle, size: 28.0, color: Colors.white),
      message: "Votre compte a été enregistré avec succès.",
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(20),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
    ).show(context);
  }

  @override
  void dispose() {
    focusNodePassword.dispose();
    passwordController.dispose();
    super.dispose();
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
          child: SizedBox(
            width: screenWidth * 0.9,
            height: screenHeight * 0.9,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/homme-serieux.jpg", // Image spécifique au docteur
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
                      "Connexion Docteur",
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
                        "Connectez-vous pour gérer vos patients et vos services de santé.",
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
                SizedBox(height: screenHeight * 0.05),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: mainColor,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                          ),
                          labelText: "Votre adresse email",
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        cursorColor: mainColor,
                        controller: passwordController,
                        focusNode: focusNodePassword,
                        obscureText: !visible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                visible = !visible;
                              });
                            },
                            icon: Icon(
                              visible ? Icons.visibility_off : Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                          labelText: "Entrez votre mot de passe",
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor, width: 2),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const ForgotPasswordDoctorPage(
                                            title: "SanoC",
                                          ),
                                ),
                              );
                            },
                            child: Text(
                              "Mot de passe oublié ?",
                              style: TextStyle(color: mainColor, fontSize: 16),
                            ),
                          ),
                        ],
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
                            // Redirection directe vers la page HomePage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const HomePage(
                                      title: "SanoC - Docteur",
                                    ),
                              ),
                            );
                          },
                          child: Text(
                            "Se connecter",
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
