import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/Pages/home_page.dart';
import 'package:pet_app/Screens/login_screen.dart';
import 'package:pet_app/Utils/validator.dart';
import '../Widgets/button_widget.dart';
import '../Widgets/textField_widget.dart';
import '../Widgets/text_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void register() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseFirestore db = FirebaseFirestore.instance;
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      //   await db.collection("Users").doc(userCredential.user!.uid).set({
      //    "Name": name,
      //    "Email": email,
      //  });

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (nameController.text.isEmpty &&
          emailController.text.isEmpty &&
          passwordController.text.isEmpty) {
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
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: TextWidget(
              title: "Password Provided is too Weak",
              txtSize: 18.0,
              txtColor: Theme.of(context).primaryColor,
            ),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: TextWidget(
              title: "Account Already exists",
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
                    title: "Sign-up",
                    txtSize: 30,
                    txtColor: Theme.of(context).primaryColor,
                  ),
                  const TextWidget(
                    title: "Name",
                    txtSize: 22,
                    txtColor: Color(0xffdddee3),
                  ),
                  InputTxtField(
                    hintText: "Your Name",
                    controller: nameController,
                    validator: nameValidator,
                    obscureText: false,
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

                  Center(
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2,
                      child: ButtonWidget(btnText: "Signup", onPress: register),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const LoginScreen()),
                            ),
                          );
                        },
                        child: const TextWidget(
                          title: "Login",
                          txtSize: 18,
                          txtColor: Color(0xff999a9e),
                        ),
                      ),
                    ],
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SocialButtonWidget(
                  //         bgColor: Colors.white,
                  //         imagePath: 'assets/Gmail.png',
                  //         onPress: () async {
                  //           await Services.googleSignIn(context);
                  //         }),
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
