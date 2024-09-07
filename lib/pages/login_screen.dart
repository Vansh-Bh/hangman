import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangman/pages/home.dart';
import 'package:hangman/utils/user_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  // Check if the user is already logged in and redirect to the Home page if they are
  void _checkIfLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "LOGIN",
              style: TextStyle(
                fontFamily: 'Press-Start-2P',
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Image.asset('assets/hangman.png'),
            SizedBox(
              width: 240,
              height: 80,
              child: FittedBox(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final user = await UserController.loginWithGoogle();
                      if (user != null && mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      }
                    } on FirebaseAuthException catch (error) {
                      print(error.message);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(error.message ?? "Something went wrong"),
                      ));
                    } catch (error) {
                      print(error);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(error.toString()),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: const Color(0xff1e1e1e)),
                  child: const Image(image: AssetImage('assets/google.jpg')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
