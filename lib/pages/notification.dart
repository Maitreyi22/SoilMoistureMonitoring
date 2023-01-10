import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  final String plantKeyString;
  final String uid;

  const NotificationPage(
      {super.key, required this.plantKeyString, required this.uid});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  DatabaseReference notifyRef = FirebaseDatabase.instance.ref("Notification");
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Users");

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

  Future<String> getPlantRegistrationDate() async {
    return dbRef
        .child(widget.uid)
        .child('plants')
        .orderByKey()
        .equalTo(widget.plantKeyString)
        .once()
        .then((DatabaseEvent databaseEvent) {
      final String plantName = databaseEvent.snapshot.children.first.children
          .elementAt(3)
          .value
          .toString();

      var now = DateTime.now();
      DateTime date = DateTime.parse(plantName);
      var diff = date.difference(now).abs();
      // String time = diff.toString();
      // print(diff);

      if (diff.inDays >= 1) {
        return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ';
      } else if (diff.inHours >= 1) {
        return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ';
      } else if (diff.inMinutes >= 1) {
        return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ';
      } else if (diff.inSeconds >= 1) {
        return '${diff.inSeconds} second${diff.inSeconds == 1 ? '' : 's'} ';
      } else {
        return 'just now';
      }
    });
  }

  String getPlantLastWateredTime(String lastWateredTime) {
    //To store Current Time in DateTime
    var now = DateTime.now();
    //To get Last stored Time in String and convert it to DateTime
    DateTime lastTime = DateTime.parse(lastWateredTime);
    //Calculating the Absolute Difference
    var diff = lastTime.difference(now).abs();

    if (diff.inDays >= 1) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : ''} ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second${diff.inSeconds == 1 ? '' : 's'} ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50, left: 10),
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
            // Container(
            //   margin: const EdgeInsets.only(),
            //   child: const Text(
            //     "My Plant Updates ",
            //     style: TextStyle(
            //         fontSize: 32,
            //         color: Color(0xFF84ba64),
            //         fontWeight: FontWeight.bold),
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.only(right: 150),
            //   child: Text(
            //     "Plant updates ",
            //     style: TextStyle(
            //       fontSize: 17,
            //       color: Colors.grey[700]!,top: 30, right: 60
            //     ),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.only(left: 20, top: 10),
              child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: FutureBuilder<String>(
                      future: getPlantName(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text("Daily Alerts for ${snapshot.data!} ",
                              style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF84ba64)));
                        } else {
                          return const Text("",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF84ba64)));
                        }
                      })),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 80),
                  child: FutureBuilder<String>(
                      future: getPlantRegistrationDate(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700]!,
                                  fontWeight: FontWeight.bold));
                        } else {
                          return Text(" ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700]!,
                              ));
                        }
                      })),
            ),

            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Latest Notifications",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700]!,
                      ),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: notifyRef.onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        !snapshot.hasError &&
                        snapshot.data!.snapshot.value != null) {
                      final databaseSnapshot = snapshot.data!;

                      final lastWateredTime = getPlantLastWateredTime(
                          databaseSnapshot.snapshot.children.last.value
                              as String);

                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 55),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                color: Colors.white,
                                // shadowColor: Colors.blueGrey,
                                elevation: 2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, left: 8, right: 8),
                                      child: ListTile(
                                        leading: Image.asset(
                                          'images/moisture.png',
                                          fit: BoxFit.cover,
                                        ),
                                        title: const Text(
                                          "The Plant's Moisture Level  "
                                          // +
                                          //     '${databaseSnapshot.snapshot.children.first.value}'
                                          ,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        subtitle: Text(
                                            '${databaseSnapshot.snapshot.children.first.value}'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Card(
                              margin: const EdgeInsets.all(10),
                              color: Colors.white,
                              // shadowColor: Colors.blueGrey,
                              elevation: 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: Image.asset(
                                        'images/plant.png',
                                        fit: BoxFit.cover,
                                      ),
                                      title: const Text(
                                        "The Plant was Last Watered ",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      subtitle: Text(lastWateredTime),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                          margin: const EdgeInsets.only(top: 150),
                          child: const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFF84ba64))));
                    }
                  },
                ),
                Container(
                    margin: const EdgeInsets.only(top: 200),
                    height: 439.8,
                    width: 400,
                    child: Image.asset(
                      'images/plantStem.png',
                      fit: BoxFit.cover,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
