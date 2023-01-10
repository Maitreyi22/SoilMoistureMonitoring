import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soilmoisture/pages/dashboard.dart';
import 'package:soilmoisture/pages/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String email = '';
  bool isLoading = false;
  bool _obscureText = true;
  bool isWorking = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 50, left: 5),
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 30,
                    )),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50, right: 200),
                child: const Text(
                  "Welcome!",
                  style: TextStyle(
                      fontSize: 32,
                      color: Color(0xFF84ba64),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 25, right: 30),
                child: Text(
                  "Enter your email address and password to log in to the application. ",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey[700]!,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              // Container(
              //   margin: const EdgeInsets.only(right: 245),
              //   child: const Text(
              //     "Enter Email ",
              //     style: TextStyle(
              //       fontSize: 18,
              //       color: Colors.grey,
              //     ),
              //     textAlign: TextAlign.left,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 17, horizontal: 10),
                    labelText: "Enter Email",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: Colors.grey[500]!,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                      return "Enter Correct Email Address";
                    } else {
                      return null;
                    }
                  },
                ),
              ),

              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: TextFormField(
                  obscureText: _obscureText,
                  controller: passwordController,

                  decoration: InputDecoration(
                    // focusedBorder: OutlineInputBorder(
                    //   borderSide: const BorderSide(color: Colors.grey),
                    //   borderRadius: BorderRadius.circular(4.0),
                    // ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.7, horizontal: 10),
                    // filled: true,
                    // fillColor: const Color.grey,
                    labelText: "Enter Password",
                    // labelStyle: TextStyle(color: const Colors.grey),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: Colors.grey[500]!,
                      ),
                    ),

                    border: const OutlineInputBorder(),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey[500]!),
                    ),
                  ),

                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Password';
                    } else if (value.length < 6) {
                      return 'Password must be atleast 6 characters!';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // padding: const EdgeInsets.all(8.0),
                          fixedSize: const Size(350, 50),
                          textStyle: const TextStyle(fontSize: 16),
                          backgroundColor: const Color(0xFF84ba64),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            logInToFirebase();
                          }
                        },
                        child: const Text('Log in'),
                      ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 36),
                    child: Text(
                      "Don't have an account ? ",
                      style: TextStyle(color: Colors.grey[700]!, fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    child: const Text(
                      "Create a new account",
                      style: TextStyle(
                          color: Color(0xFF84ba64),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const RegisterPage()));
                    },
                  )
                ],
              )
            ]))),
      ),
    );
  }

  void logInToFirebase() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text)
        .then((result) {
      isLoading = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DashBoard(uid: result.user!.uid)),
      );
    }).catchError((err) {
      print(err.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(err.message),
              actions: [
                ElevatedButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }
}
