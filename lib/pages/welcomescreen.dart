import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soilmoisture/pages/dashboard.dart';
import 'package:soilmoisture/pages/login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    User? result = FirebaseAuth.instance.currentUser;
    if (result != null) {
      return DashBoard(uid: result.uid);
    } else {
      return Scaffold(
          // resizeToAvoidBottomInset: false,
          body: SafeArea(
        child: Stack(
          children: [
            const SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image(
                  image: AssetImage('images/Photo.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 390, left: 185),
              height: 22,
              width: 22,
              child: Image.asset(
                'images/Religion.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 415, left: 139),
                child: const Text(
                  "Cuidado",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
            Container(
                margin: const EdgeInsets.only(top: 465, left: 35, right: 30),
                child: const Text(
                  "Take care of your plants from anywhere by monitoring them using our app. ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    // fontWeight: FontWeight.bold
                  ),
                )),
            Container(
              margin: const EdgeInsets.only(top: 650, left: 40),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                  // padding: const EdgeInsets.all(8.0),
                  fixedSize: const Size(300, 50),
                  textStyle: const TextStyle(
                    fontSize: 15,
                  ),
                  backgroundColor: Colors.white,
                  side: const BorderSide(width: 1, color: Color(0xFF84ba64)),
                  elevation: 0,
                ),
                child: const Text("Get Started",
                    style: TextStyle(color: Color(0xFF84ba64))),
              ),
            ),
          ],
        ),
      ));
    }
  }
}
