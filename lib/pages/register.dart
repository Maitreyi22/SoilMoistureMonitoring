import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:soilmoisture/pages/dashboard.dart';
import 'package:soilmoisture/pages/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =
      // FirebaseDatabase.instance.reference().child("Users");
      FirebaseDatabase.instance.ref("Users");
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  List<String> typeOfSoil = ["Clay", "Sandy", "Loam"];
  String? selectedItem = "Clay";

  int _radioValue = 0;

  void _handleRadioValueChange(value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(
        children: [
          // Row(
          //   // mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
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
          // SizedBox(
          //   width: 60,
          // ),
          // Container(
          //     margin: const EdgeInsets.only(top: 52),
          //     child: Text(
          //       "Create an account",
          //       style: TextStyle(
          //           fontSize: 20,
          //           color: Color(0xFF84ba64),
          //           fontWeight: FontWeight.bold),
          //     )),
          //   ],
          // ),
          Container(
            margin: const EdgeInsets.only(top: 20, right: 153),
            child: const Text(
              "Create Account",
              style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFF84ba64),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, right: 23),
            child: Text(
              "Enter your details to sign in to the application.",
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey[700]!,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 5),
          Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Stack(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 17, horizontal: 10),
                      labelText: "Enter Name",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: Colors.grey[500]!,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                        //allow upper and lower case alphabets and space
                        return "Enter Correct Name";
                      } else if (value.length < 6) {
                        return 'Name must be atleast 6 characters!';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 120, left: 25, right: 25),
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
                Padding(
                  padding: const EdgeInsets.only(top: 197, left: 8, right: 25),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                      ),
                      Text('Gender   ',
                          style: TextStyle(
                              fontSize: 17.0, color: Colors.grey.shade600)),
                      Radio(
                        value: 0,
                        activeColor: const Color(0xFF84ba64),
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      Text(
                        'Male',
                        style: TextStyle(
                            fontSize: 16.0, color: Colors.grey.shade600),
                      ),
                      Radio(
                        value: 1,
                        activeColor: const Color(0xFF84ba64),
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      Text(
                        'Female',
                        style: TextStyle(
                            fontSize: 16.0, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 255, left: 25, right: 25),
                  // padding: const EdgeInsets.only(top: 210, left: 25, right: 25),
                  child: TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 17, horizontal: 10),
                      labelText: "Enter Mobile Number",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: Colors.grey[500]!,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Mobile Number cannot be Empty!';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 350, left: 25, right: 25),
                  // padding: const EdgeInsets.only(top: 305, left: 25, right: 25),
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
                // Padding(
                //   padding: const EdgeInsets.only(top: 440, left: 25, right: 25),
                //   child: DropdownButtonFormField<String>(
                //     decoration: InputDecoration(
                //       //To adjust the height of the textBox
                //       contentPadding: const EdgeInsets.symmetric(
                //           vertical: 17, horizontal: 10),
                //       labelText: "Enter Soil Type",
                //       // hintText: 'Please choose one',
                //       enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(4.0),
                //         borderSide: BorderSide(
                //           color: Colors.grey[500]!,
                //         ),
                //       ),
                //       border: const OutlineInputBorder(),
                //     ),
                //     isExpanded: true,
                //     //Logic of the DropDown TextFormField.
                //     value: selectedItem,
                //     items: typeOfSoil
                //         .map((item) => DropdownMenuItem<String>(
                //             value: item, child: Text(item)))
                //         .toList(),
                //     onChanged: (item) => setState(() => selectedItem = item),
                //     icon: const Padding(
                //         //Icon at tail, arrow bottom is default icon
                //         padding: EdgeInsets.only(left: 20),
                //         child: Icon(
                //           Icons.arrow_drop_down,
                //           size: 30,
                //           color: Colors.grey,
                //         )),
                //     // iconEnabledColor: Colors.yellow, //Icon color
                //     style: TextStyle(
                //       color: Colors.grey[700]!, //Font color
                //       // fontSize: 20 //font size on dropdown button
                //     ),

                //     dropdownColor: Colors.white,
                //     //dropdown background color

                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return 'Select a value';
                //       }
                //       return null;
                //     },
                //   ),
                // ),
                Padding(
                  // padding: const EdgeInsets.only(top: 530, left: 25, right: 25),
                  padding: const EdgeInsets.only(top: 450, left: 25, right: 25),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(8.0),
                            fixedSize: const Size(350, 50),
                            textStyle: const TextStyle(fontSize: 16),
                            backgroundColor: const Color(0xFF84ba64),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // setState(() {
                              //   isLoading = true;
                              // });
                              registerToFirebase();
                            }
                          },
                          child: const Text('Sign In'),
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 510, left: 69, bottom: 30),
                      child: Text(
                        "Already have an account? ",
                        style:
                            TextStyle(color: Colors.grey[700]!, fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Padding(
                      // padding: const EdgeInsets.only(
                      //     top: 590, right: 40, bottom: 30),
                      padding:
                          // const EdgeInsets.only(top: 590, left: 69, bottom: 30),
                          const EdgeInsets.only(top: 510, bottom: 30),
                      child: GestureDetector(
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                              color: Color(0xFF84ba64),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginPage()));
                        },
                      ),
                    ),
                  ],
                ),
              ])))
        ],
      ),
    )));
  }

  void registerToFirebase() {
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text)
        .then((result) {
      dbRef.child(result.user!.uid).set({
        "email": emailController.text,
        // "age": ageController.text,
        "name": nameController.text,
        "gender": _radioValue == 0 ? 'Male' : 'Female',
        'mobile': mobileController.text.toString(),
        // 'soilType': selectedItem
      }).then((res) {
        isLoading = false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DashBoard(uid: result.user!.uid)),
        );
      });
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
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

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    // ageController.dispose();
    mobileController.dispose();
  }
}
