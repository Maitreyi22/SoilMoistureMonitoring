// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:math';
import 'package:soilmoisture/pages/notification.dart';
import 'package:soilmoisture/services/notification_services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

final notifyVar = NotificationService();
// final notificationVar = NotificationPage();

class PlantMonitorPage extends StatefulWidget {
  final String plantKeyString;
  final String uid;

  const PlantMonitorPage(
      {super.key, required this.plantKeyString, required this.uid});

  @override
  State<PlantMonitorPage> createState() => _PlantMonitorPageState();
}

class _PlantMonitorPageState extends State<PlantMonitorPage> {
  bool value = false;
  String lowMessage = "Low, Please water the plants!";
  String highMessage = "High, Plants are watered!";
  Timer? timer;

  DatabaseReference ref = FirebaseDatabase.instance.ref('WaterPump');
  DatabaseReference sensorRef = FirebaseDatabase.instance.ref('SensorData');
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Users");
  DatabaseReference notifyRef = FirebaseDatabase.instance.ref("Notification");

  User? result = FirebaseAuth.instance.currentUser;

  List<Map<dynamic, dynamic>> lists = [];

  onUpdate() {
    setState(() {
      value = !value;
    });
  }

  // Future<void> Check() async {
  //   // DatabaseReference starCountRef =
  //   //     FirebaseDatabase.instance.ref('SensorData/Moisture');
  //   // starCountRef.onValue.listen((DatabaseEvent event) {
  //   //   final data = event.snapshot.value;
  //   //   print(data);
  //   // });

  //   // final snapshot = await sensorRef.child('Moisture').get();
  //   // if (snapshot.exists) {
  //   //   print(snapshot.value);
  //   // } else {
  //   //   print('No data available.');
  //   // }
  // }
  Future<String> getPlantName() async {
    return dbRef
        .child(widget.uid)
        .child('plants')
        .orderByKey()
        .equalTo(widget.plantKeyString)
        .once()
        .then((DatabaseEvent databaseEvent) {
      final String plantName = databaseEvent.snapshot.children.first.children
          .elementAt(1)
          .value
          .toString();

      // setState(() {
      //   pN = plantName.toString();
      // });
      // print(pN);
      // print(pN.runtimeType);

      // print(plantName);
      // print(plantName.runtimeType);
      return plantName;
    });
  }

  String getCleanDateString(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second)
        .toString();
  }

  void getSensorData(moistureVal) async {
    //To get a string variable from Future<string> Function.
    String plantName = await getPlantName();

    if (moistureVal <= 20) {
      print("Moisture less");

      //To get current time cast into a string for storing last watered time
      DateTime currentDate = DateTime.now();
      String timeOfMotorStart = getCleanDateString(currentDate);

      //To add lowMessage and start motor
      writeLowSensorData(timeOfMotorStart);

      //To show notification for when the moisture is less.
      notifyVar.showLowNotification(plantName);
    } else if (moistureVal >= 90) {
      print("Over Moisturized");

      writeHighSensorData();

      notifyVar.showHighNotification(plantName);
    } else {
      print("Moisturized");
      writeHighSensorData();

      notifyVar.showHighNotification(plantName);
    }
  }

  Future<void> writeHighSensorData() async {
    await ref.set({"switch": !value});
    await notifyRef.update({
      "notification": highMessage,
    });
  }

  Future<void> writeLowSensorData(timeOfMotorStart) async {
    await ref.set({"switch": value});
    await notifyRef.set(
        {"notification": lowMessage, 'timeOfMotorStart': timeOfMotorStart});
  }

  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => Check());
    notifyVar.checkForNotification();
  }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
              // Text(widget.plantKeyString),
              // StreamBuilder(
              //     stream: plantRef.onValue,
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData &&
              //           !snapshot.hasError &&
              //           snapshot.data!.snapshot.value != null) {
              //         final databaseSnapshot = snapshot.data!.snapshot.children;
              //         SchedulerBinding.instance.addPostFrameCallback((_) {
              //           func(databaseSnapshot);
              //         });

              //         return Column(
              //           children: [Text('${databaseSnapshot.first.value}')],
              //         );
              //       }
              //       return Container(
              //         color: Colors.amber,
              //       );
              //     }),

              FutureBuilder<DatabaseEvent>(
                  // future: plantRef.once(),
                  future: dbRef
                      .child(widget.uid)
                      .child('plants')
                      .orderByKey()
                      .equalTo(widget.plantKeyString)
                      .once(),
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (snapshot.hasData) {
                      lists.clear();
                      Map<dynamic, dynamic> values = snapshot
                          .data!.snapshot.value as Map<dynamic, dynamic>;
                      values.forEach((key, values) {
                        // final newPostKey = dbRef.push().key;
                        lists.add(values);
                      });
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: lists.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              child:
                                  // Consumer<NotificationService>(
                                  // builder: (context, model, _) =>
                                  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      lists[index]["name"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Color(0xFF84ba64),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 20, left: 10),
                                    child: Wrap(
                                      spacing: 15,
                                      children: [
                                        SizedBox(
                                          child: Chip(
                                            backgroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Color(0xFF84ba64)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4))),
                                            padding: const EdgeInsets.all(4),
                                            label: Text(
                                              "Plant Type - " +
                                                  lists[index]["plantType"],
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF84ba64)),
                                            ), //Text
                                          ),
                                        ),
                                        SizedBox(
                                          child: Chip(
                                            backgroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Color(0xFF84ba64)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4))),
                                            padding: const EdgeInsets.all(4),
                                            label: Text(
                                              " Ideal Soil Type - " +
                                                  lists[index]["soilType"],
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF84ba64)),
                                            ), //Text
                                          ),
                                        ),
                                        Container(
                                          // margin: const EdgeInsets.only(top: 0, left: 15),
                                          child: SizedBox(
                                            child: Chip(
                                              backgroundColor: Colors.white,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color:
                                                              Color(
                                                                  0xFF84ba64)),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                              padding: const EdgeInsets.all(4),
                                              label: Text(
                                                "Required Moisture Level - " +
                                                    lists[index]
                                                        ["moistureLevel"],
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF84ba64)),
                                              ), //Text
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    }
                    return Container(
                        margin: const EdgeInsets.only(top: 150),
                        child: const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF84ba64))));
                  }),
              const SizedBox(height: 30),
              StreamBuilder(
                  stream: sensorRef.onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        !snapshot.hasError &&
                        snapshot.data!.snapshot.value != null) {
                      final databaseSnapshot =
                          snapshot.data!.snapshot.children.first.value;
                      // Future.delayed(Duration.zero, () async {
                      //   func(databaseSnapshot);
                      // });
                      getSensorData(databaseSnapshot);
                      SchedulerBinding.instance.addPostFrameCallback((_) {});
                      return Column(
                          // children: snapshot.data!
                          //     .map((e) =>
                          children: [
                            const SizedBox(height: 20),

                            // mainAxisAlignment: MainAxisAlignment.center,
                            // children: [

                            SizedBox(
                              height: 280,
                              width: 280,
                              child: SfRadialGauge(
                                enableLoadingAnimation: true,
                                animationDuration: 4500,
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 100,
                                    pointers: <GaugePointer>[
                                      RangePointer(
                                        value: double.parse(
                                          '$databaseSnapshot',
                                        ),
                                        color: const Color(0xFF84ba64),
                                        cornerStyle: CornerStyle.bothCurve,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     Padding(
                            //       padding: EdgeInsets.only(right: 100),
                            //       child: Text('Current Moisture Data',
                            //           style: TextStyle(
                            //               fontSize: 16,
                            //               fontWeight: FontWeight.bold)),
                            //     ),
                            //     // SizedBox(width: 30),
                            //     Text(
                            //         // snapshot.data!.snapshot.value['Moisture : '].toString(),
                            //         // snapshot.data!.snapshot.value.toString(),
                            //         // '${databaseSnapshot.child("/Moisture").key}',
                            //         '${databaseSnapshot}',
                            //         style: const TextStyle(
                            //             fontSize: 16,
                            //             fontWeight: FontWeight.bold)),
                            //   ],
                            // ),
                            // FloatingActionButton(
                            //   onPressed: notifyVar.showLowNotification,
                            //   child: Icon(Icons.notification_add),
                            // ),

                            const SizedBox(height: 40),
                          ]);
                    } else {
                      return Container(color: Color(0xFF84ba64));
                    }
                  }),

              ElevatedButton.icon(
                onPressed: () {
                  onUpdate();

                  writeHighSensorData();
                },
                label: value ? const Text("ON") : const Text("OFF"),
                // backgroundColor: value
                //     ? Colors.yellow[800]
                //     : Colors.green[800],
                icon: value
                    ? const Icon(Icons.water_drop_sharp)
                    : const Icon(Icons.format_color_reset),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8.0),
                  fixedSize: const Size(300, 50),
                  textStyle: const TextStyle(fontSize: 15),
                  backgroundColor:
                      value ? Colors.yellow[800] : const Color(0xFF84ba64),
                  elevation: 0,
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, right: 20),
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => NotificationPage(
                                    uid: result!.uid,
                                    plantKeyString: widget.plantKeyString)));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          //border radius equal to or more than 50% of width
                        ),
                        // fixedSize: Size(50, 50),
                        // textStyle: TextStyle(fontSize: 15),
                        backgroundColor: const Color(0xFFf9731b),
                        elevation: 0,
                      ),
                      child: const Icon(Icons.notifications_active_sharp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
