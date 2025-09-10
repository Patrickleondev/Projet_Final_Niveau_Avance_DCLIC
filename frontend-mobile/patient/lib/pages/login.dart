import 'package:flutter/material.dart';
import 'package:sanoc/pages/home.dart';
import 'createAccount.dart';
import 'forgotPassword.dart';
import 'package:another_flushbar/flushbar.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({
    super.key,
    required this.title,
    this.showNotification = false,
  });

  final String title;
  final bool showNotification; // Indicateur pour afficher la notification

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  // Controllers pour les champs de texte
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode focusNodePassword = FocusNode();
  bool visible = false;

  @override
  void initState() {
    super.initState();
    if (widget.showNotification) {
      Future.delayed(Duration(milliseconds: 300), () {
        afficherNotification(
          // ignore: use_build_context_synchronously
          context,
        ); // Afficher la notification après l’arrivée
      });
    }
  }

  void afficherNotification(BuildContext context) {
    Flushbar(
      title: "Inscription réussie !",
      icon: const Icon(Icons.check_circle, size: 28.0, color: Colors.white),
      message: "Votre compte a été enregistré avec succès ",
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(20),
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 3),
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

    Color mainColor = Colors.deepOrange;
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.9,

            decoration: BoxDecoration(),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/hospital.png",
                      height: screenWidth * 0.2,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "SanoC",
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
                      "Connexion",
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
                        "Connectez-vous pour accéder à vos services de santé",
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
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                          ),
                          labelText: "Votre adresse email",
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez entrer votre adresse email";
                          }
                          if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                          ).hasMatch(value)) {
                            return "Veuillez entrer une adresse email valide";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        cursorColor: mainColor,
                        controller: passwordController,
                        focusNode: focusNodePassword,
                        obscureText: !visible,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.black,
                          ),
                          suffixIcon:
                              focusNodePassword.hasFocus
                                  ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        visible = !visible;
                                      });
                                    },
                                    icon: Icon(
                                      visible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.black,
                                    ),
                                  )
                                  : null,
                          labelText: "Entrez votre mot de passe",
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor, width: 2),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez entrer votre mot de passe";
                          }
                          if (value.length < 6) {
                            return "Le mot de passe doit contenir au moins 6 caractères";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            splashColor:
                                Colors.transparent, // Supprime l'effet de clic
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const ForgotPasswordPage(
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
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await Flushbar(
                                title: emailController.text,
                                flushbarPosition: FlushbarPosition.TOP,
                                margin: const EdgeInsets.all(8),
                                borderRadius: BorderRadius.circular(20),
                                backgroundColor: const Color.fromARGB(
                                  110,
                                  34,
                                  32,
                                  32,
                                ),
                                icon: const Icon(
                                  Icons.info_outline,
                                  size: 28.0,
                                  color: Colors.white,
                                ),
                                message:
                                    'Vous vous êtes connecté avec succès !',
                                duration: Duration(seconds: 3),
                              ).show(context);
                            }
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
                SizedBox(height: screenHeight * 0.02),
                Column(
                  children: [
                    Text(
                      "Ou",
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.05,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.black26, width: .5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const ForgotPasswordPage(title: "SanoC"),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/google.png",
                              width: screenWidth * 0.07,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              "Se connecter avec Google",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenHeight * 0.02,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      height: screenHeight * 0.05,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.black26, width: .5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(title: "SanoC"),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/apple-logo.png",
                              width: screenWidth * 0.07,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              "Se connecter avec Apple",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenHeight * 0.02,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Vous n'avez pas de compte ?",
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
                                  (context) =>
                                      const CreateAccountPage(title: "SanoC"),
                            ),
                          );
                        },
                        child: Text(
                          "Inscrivez-vous",
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
      ),
    );
  }
}
