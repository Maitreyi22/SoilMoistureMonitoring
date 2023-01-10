import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:soilmoisture/pages/monitor.plant.dart';

import 'package:soilmoisture/pages/plant.register.dart';
import 'package:soilmoisture/pages/welcomescreen.dart';

class DashBoard extends StatefulWidget {
  final String uid;

  DashBoard({super.key, required this.uid});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final dbRef = FirebaseDatabase.instance.ref().child('Users');

  User? result = FirebaseAuth.instance.currentUser;

  List<Map<dynamic, dynamic>> lists = [];

  var listForPlantKey = [];
  var plantKeyString = '';
  String? index;
  bool isWorking = true;

  Future<String> getUsername() async {
    final ref = FirebaseDatabase.instance.ref();

    return ref
        .child('Users')
        .child(widget.uid)
        .once()
        .then((DatabaseEvent databaseEvent) {
      final String userName =
          databaseEvent.snapshot.children.elementAt(3).value.toString();

      // print(userName);
      return userName;
    });
  }

  // Future<DatabaseEvent> getplantDetails() async {
  //   final plantref = FirebaseDatabase.instance.reference();

  //   return plantref
  //       .child('Users')
  //       .child(widget.uid)
  //       .child('plants')
  //       .once()
  //       .then((DatabaseEvent databaseEvent) {
  //     final Object? databaseSnapshot = databaseEvent.snapshot.value;

  //     return databaseSnapshot;
  //   });
  // }

  sendIndex(indexVal) {
    setState(() {
      index = indexVal.toString();
    });

    return index;
  }

  _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                      height: 390,
                      width: 800,
                      child: Image.asset(
                        'images/Dashboard image.png',
                        fit: BoxFit.cover,
                      )),
                  Container(
                      margin: const EdgeInsets.only(left: 10, top: 25),
                      height: 30,
                      width: 120,
                      child: GestureDetector(
                          onTap: (() {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            auth.signOut().then((res) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WelcomeScreen()),
                                  (Route<dynamic> route) => false);
                            });
                          }),
                          child: Image.asset(
                            'images/Log out.png',
                          ))),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 220),
                    child: const Text(
                      "Hi,",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 20, top: 250),
                      child: FutureBuilder<String>(
                          future: getUsername(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data!,
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white));
                            } else {
                              return const Text("Loading data.",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white));
                            }
                          })),
                  Container(
                      margin: const EdgeInsets.only(left: 20, top: 310),
                      child: const Text("Your plants",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  Container(
                      margin: const EdgeInsets.only(top: 335),
                      child: FutureBuilder(
                        future: dbRef.child(widget.uid).child('plants').once(),
                        // initialData: null,
                        builder:
                            (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                          if (snapshot.data!.snapshot.value == null) {
                            return Container(
                              // color: Colors.amber,
                              height: 300,
                              child: Column(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(top: 150),
                                    child: Center(
                                      child: Text(
                                        "Uh oh!",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),

                                  // margin:
                                  //     const EdgeInsets.only(left: 75, top: 5),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 300,
                                        child: Text(
                                          "You do not have any plants added",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            lists.clear();

                            // final databaseSnapshot = snapshot.data!.snapshot.value;

                            // listForPlantKey.add(databaseSnapshot);

                            Map<dynamic, dynamic> values = snapshot
                                .data!.snapshot.value as Map<dynamic, dynamic>;

                            values.forEach((key, values) {
                              //final newPostKey = dbRef.push().key;
                              final plantKey =
                                  Map<String, dynamic>.from(values);

                              plantKey['key'] = key;

                              plantKeyString = plantKey['key'];

                              listForPlantKey.add(plantKey['key']);

                              // print(plantKey);
                              // print(values);

                              lists.add(values);
                            });

                            return ListView.builder(
                                // scrollDirection: Axis.vertical,
                                // physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: lists.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20, top: 10),
                                    child: GestureDetector(
                                      child: SizedBox(
                                        height: 100,
                                        child: Card(
                                          elevation: 1.5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Text(listForPlantKey[index]),
                                                // name = sendIndex(listForPlantKey[index]),

                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Expanded(
                                                      flex: 2,
                                                      child: Image.asset(
                                                          "images/cardImage.png"),
                                                    ),
                                                  ),
                                                ),

                                                Expanded(
                                                    child: Column(
                                                  children: [
                                                    ListTile(
                                                        title: Text(lists[index]
                                                            ["name"]),
                                                        subtitle: Text(
                                                            lists[index]
                                                                ["plantType"]
                                                            //     +
                                                            // ", " +
                                                            // lists[index][
                                                            //     "soilType"] +
                                                            // ", " +
                                                            // lists[index][
                                                            //     "moistureLevel"]
                                                            )),
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    PlantMonitorPage(
                                                        uid: result!.uid,
                                                        plantKeyString:
                                                            plantKeyString)))
                                      },
                                    ),
                                  );
                                });
                          }

                          return Container(
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xFF84ba64))));
                        },
                      ))
                ],
              ),
            ),
          ),
          Container(
            // margin: EdgeInsets.only(top: 700),
            // alignment: Alignment.bottomCenter,
            margin:
                const EdgeInsets.only(top: 10, bottom: 30, left: 50, right: 50),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PlantRegistration(uid: widget.uid)));
              },
              icon: const Icon(
                Icons.add_circle_rounded,
                size: 20,
              ),
              label: const Text("Add a Plant"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(8.0),
                fixedSize: const Size(320, 50),
                textStyle: const TextStyle(fontSize: 15),
                backgroundColor: const Color(0xFF84ba64),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      ),
      // bottomNavigationBar:
    );
  }
}
