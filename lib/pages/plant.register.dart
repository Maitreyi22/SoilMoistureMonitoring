import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:soilmoisture/pages/dashboard.dart';
import 'package:soilmoisture/pages/plant.info.dart';

class PlantRegistration extends StatefulWidget {
  final String uid;

  const PlantRegistration({required this.uid});

  @override
  State<PlantRegistration> createState() => _PlantRegistrationState();
}

class _PlantRegistrationState extends State<PlantRegistration> {
  final _formKey = GlobalKey<FormState>();

  User? result = FirebaseAuth.instance.currentUser;
  DateTime current_date = DateTime.now();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Users");
  // FirebaseDatabase.instance.ref().child("Plants");

  TextEditingController nameController = TextEditingController();

  List<String> moistureLevel = ["21-40%", "41-60%", "61-80%"];
  String? selectedMoistureLevel = "41-60%";

  List<String> typeOfSoil = ["Sandy", "Loam", "Clay"];
  String? selectedTypeOfSoil = "Loam";

  int _radioValue = 0;

  bool isLoading = false;

  final successnackbar =
      const SnackBar(content: Text('Details Saved Successfully!'));

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
              margin: const EdgeInsets.only(top: 20, left: 25, right: 120),
              child: const Text(
                "Provide your Plant Details",
                style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF84ba64),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 25, right: 25),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 17, horizontal: 10),
                            labelText: "Enter Name of the Plant",
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
                              return 'Enter Name of the Plant';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 8, right: 25),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                            ),
                            Text(
                              'Plant Type   ',
                              style: TextStyle(
                                color: Colors.grey[700]!, //Font color
                                fontSize: 16.0, //FontSize
                              ),
                            ),
                            Radio(
                              value: 0,
                              activeColor: const Color(0xFF84ba64),
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            Text(
                              'Outdoor',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[700]!),
                            ),
                            Radio(
                              value: 1,
                              activeColor: const Color(0xFF84ba64),
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            Text(
                              'Indoor',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[700]!),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 25, right: 25),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            //To adjust the height of the textBox
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 17, horizontal: 10),
                            labelText: "Enter Soil Type",
                            // hintText: 'Please choose one',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                color: Colors.grey[500]!,
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          isExpanded: true,
                          //Logic of the DropDown TextFormField.
                          value: selectedTypeOfSoil,
                          items: typeOfSoil
                              .map((item) => DropdownMenuItem<String>(
                                  value: item, child: Text(item)))
                              .toList(),
                          onChanged: (item) =>
                              setState(() => selectedTypeOfSoil = item),
                          icon: const Padding(
                              //Icon at tail, arrow bottom is default icon
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                                color: Colors.grey,
                              )),
                          // iconEnabledColor: Colors.yellow, //Icon color
                          style: TextStyle(
                            color: Colors.grey[700]!,
                          ),

                          dropdownColor: Colors.white,
                          //dropdown background color

                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Select a value';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 25, right: 25),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            //To adjust the height of the textBox
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 17, horizontal: 10),
                            labelText: "Enter Required Moisture level",
                            // hintText: 'Please choose one',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                color: Colors.grey[500]!,
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          isExpanded: true,
                          //Logic of the DropDown TextFormField.
                          value: selectedMoistureLevel,
                          items: moistureLevel
                              .map((item) => DropdownMenuItem<String>(
                                  value: item, child: Text(item)))
                              .toList(),
                          onChanged: (item) =>
                              setState(() => selectedMoistureLevel = item),
                          icon: const Padding(
                              //Icon at tail, arrow bottom is default icon
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                                color: Colors.grey,
                              )),
                          // iconEnabledColor: Colors.yellow, //Icon color
                          style: TextStyle(
                            color: Colors.grey[700]!, //Font color
                            // fontSize: 20 //font size on dropdown button
                          ),

                          dropdownColor:
                              Colors.white, //dropdown background color

                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Select a value';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 60, left: 25, right: 25),
                        child: isLoading
                            ? CircularProgressIndicator()
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
                                    dbRef
                                        .child(widget.uid)
                                        .child('plants')
                                        .push()
                                        .set({
                                      "name": nameController.text,
                                      "plantType": _radioValue == 0
                                          ? 'Outdoor'
                                          : 'Indoor',
                                      "moistureLevel": selectedMoistureLevel,
                                      "soilType": selectedTypeOfSoil,
                                      "time": current_date.toString(),
                                    }).then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(successnackbar);

                                      final newPostKey = dbRef.push().key;
                                      print(newPostKey);
                                      nameController.clear();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  DashBoard(uid: result!.uid)));
                                    }).catchError((onError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(onError)));
                                    });
                                  }
                                },
                                child: Text('Save Details'),
                              ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }
}
