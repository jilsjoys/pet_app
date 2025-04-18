import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/Pages/home_page.dart';
import 'package:pet_app/Screens/forget_password_screen.dart';
import 'package:pet_app/Screens/signup_screen.dart';
import 'package:pet_app/Utils/validator.dart';
import 'package:pet_app/Widgets/button_widget.dart';

import '../Widgets/textField_widget.dart';
import '../Widgets/text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //  FirebaseFirestore db = FirebaseFirestore.instance;
    final String email = emailController.text;
    final String password = passwordController.text;
    try {
      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password);

      // Check if user data exists before navigating
      //  DocumentSnapshot userDoc =
      //    await db.collection("Users").doc(userCredential.user!.uid).get();

      if (userCredential.user != null) {
        // Navigate to HomePage after login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (emailController.text.isEmpty && passwordController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: const TextWidget(
                title: "Error",
                txtSize: 25.0,
                txtColor: Colors.white,
              ),
              content: const TextWidget(
                title: "Please fill the fields",
                txtSize: 20.0,
                txtColor: Colors.white,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const TextWidget(
                    title: "Ok",
                    txtSize: 18.0,
                    txtColor: Colors.blue,
                  ),
                ),
              ],
            );
          },
        );
      }
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: TextWidget(
              title: "No User Found for that Email",
              txtSize: 18.0,
              txtColor: Theme.of(context).primaryColor,
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: TextWidget(
              title: "Wrong Password Provided by User",
              txtSize: 18.0,
              txtColor: Theme.of(context).primaryColor,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(height: 50),
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
                child: Image.asset("assets/image.png"),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 21.0),
              height: MediaQuery.of(context).size.height / 1.67,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    title: "Log-in",
                    txtSize: 30,
                    txtColor: Theme.of(context).primaryColor,
                  ),
                  const TextWidget(
                    title: "Email",
                    txtSize: 22,
                    txtColor: Color(0xffdddee3),
                  ),
                  InputTxtField(
                    hintText: "Your Email id",
                    controller: emailController,
                    validator: emailValidator,
                    obscureText: false,
                  ),
                  const TextWidget(
                    title: "Password",
                    txtSize: 22,
                    txtColor: Color(0xffdddee3),
                  ),
                  InputTxtField(
                    hintText: "Password",
                    controller: passwordController,
                    validator: passwordValidator,
                    obscureText: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  ((context) => const ForgetPasswordScreen()),
                            ),
                          );
                        },
                        child: const TextWidget(
                          title: "Forget password?",
                          txtSize: 18,
                          txtColor: Color(0xff999a9e),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2,
                      child: ButtonWidget(btnText: "Login", onPress: login),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TextWidget(
                        title: "Don't have an account? ",
                        txtSize: 18,
                        txtColor: Color(0xff999a9e),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const SignUpScreen()),
                            ),
                          );
                        },
                        child: const TextWidget(
                          title: "Sign-Up ",
                          txtSize: 18,
                          txtColor: Color(0xff999a9e),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 15),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //       child: Container(
                  //         height: 2.0,
                  //         width: 90.0,
                  //         color: const Color(0xff999a9e),
                  //       ),
                  //     ),
                  //     TextWidget(
                  //       title: "Or login with",
                  //       txtSize: 18,
                  //       txtColor: const Color(0xff999a9e),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //       child: Container(
                  //         height: 2.0,
                  //         width: 90.0,
                  //         color: const Color(0xff999a9e),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // // const SizedBox(height: 7.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SocialButtonWidget(
                  //       bgColor: Colors.white,
                  //       imagePath: 'assets/Gmail.png',
                  //       onPress: () {},
                  //     ),
                  //     const SizedBox(width: 25.0),
                  //     SocialButtonWidget(
                  //       bgColor: const Color(0xff1877f2),
                  //       imagePath: 'assets/facebook.png',
                  //       onPress: () {},
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
