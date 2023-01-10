// ignore_for_file: unnecessary_new, prefer_interpolation_to_compose_strings

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:soilmoisture/pages/monitor.plant.dart';

class PlantDetails extends StatefulWidget {
  const PlantDetails({super.key});

  @override
  State<PlantDetails> createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  final dbRef = FirebaseDatabase.instance.ref().child("Plants");

  List<Map<dynamic, dynamic>> lists = [];

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
            margin: const EdgeInsets.only(top: 20, right: 125),
            child: const Text(
              "My Plant Details",
              style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFF84ba64),
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FutureBuilder<DatabaseEvent>(
              future: dbRef.once(),
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData) {
                  lists.clear();
                  Map<dynamic, dynamic> values =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  values.forEach((key, values) {
                    // final newPostKey = dbRef.push().key;
                    lists.add(values);
                  });
                  return new ListView.builder(
                      shrinkWrap: true,
                      itemCount: lists.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: GestureDetector(
                            child: Container(
                              height: 100,
                              child: Card(
                                elevation: 1.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        lists[index]["name"],
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF84ba64),
                                        ),
                                      ),
                                      // Text("Plant Type: " +
                                      //     lists[index]["plantType"]),
                                      // Text("Soil  Type: " +
                                      //     lists[index]["soilType"]),
                                      // Text("Moisture level: " +
                                      //     lists[index]["moistureLevel"]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (_) => const PlantMonitorPage()))
                            },
                          ),
                        );
                      });
                }
                return Container(child: CircularProgressIndicator());
              }),
        ],
      ),
    )));
  }
}
