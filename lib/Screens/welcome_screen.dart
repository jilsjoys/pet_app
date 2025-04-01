import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_app/Screens/login_screen.dart';
import 'package:pet_app/Screens/signup_screen.dart';
import 'package:pet_app/Widgets/button_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height / 1.1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Divider(height: 100),
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2.5,
                child: Image.asset("assets/image.png"),
              ),
            ),
            Text(
              "Welcome",
              style: GoogleFonts.gemunuLibre(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              width: 350,
              height: 50,
              child: ButtonWidget(
                btnText: "login",
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: 350,
              height: 50,
              child: ButtonWidget(
                btnText: "signup",
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
