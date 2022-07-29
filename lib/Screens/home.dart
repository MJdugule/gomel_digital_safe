import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:websocket/Screens/calender.dart';
import 'package:websocket/Screens/payment.dart';
import 'package:websocket/Screens/profile.dart';
import 'package:websocket/Screens/wid/recentlyPaid.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                      right: 40,
                      left: 190,
                      bottom: 30,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.red,
                      )),
                  Positioned(
                      right: 0,
                      left: 50,
                      bottom: 50,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.black,
                      )),
                  Positioned(
                      left: 20,
                      bottom: 40,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green,
                      )),
                  Container(
                    height: MediaQuery.of(context).size.height / 2 - 120,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                          center: Alignment(-0.8, 0.5),
                          focalRadius: 3.0,
                          focal: Alignment(0.3, -2),
                          colors: [
                            Colors.purple.withOpacity(.1),
                            Colors.purple.shade800.withOpacity(0.97),
                          ]),
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(190)),
                      color: Colors.blue,
                    ),
                    child: Center(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('User')
                                .where('id', isEqualTo: user?.uid)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Container();
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.all(21.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //SizedBox(height: 20,),
                                        Text(
                                          document['firstName'] != null
                                              ? 'Hi, '
                                                  '${document['firstName']}'
                                                  ' ${document['lastName']}'
                                              : 'Hi',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: -0.7,
                                              wordSpacing: 1,
                                              fontSize: 35,
                                              height: 1.3,
                                              fontFamily: 'sora',
                                              color: Colors.white),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              );
                            })),
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                child: GridView.count(
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  padding:
                      EdgeInsets.only(right: 25, left: 25, bottom: 20, top: 30),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => Payment()));
                      },
                      child: Material(
                        child: Container(
                          child: Center(
                              child: Column(
                            children: [
                              Image(
                                image: AssetImage(
                                  'image/goldwallet.png',
                                ),
                                height: 80,
                              ),
                              Text(
                                'Make Payment',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                          decoration: BoxDecoration(
                              // image: DecorationImage(image: AssetImage('image/credit.png'),),
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: Offset(0, 1),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                ),
                              ]),
                        ),
                        color: Colors.white,
                        type: MaterialType.canvas,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => DateView()));
                      },
                      child: Material(
                        child: Container(
                          child: Center(
                              child: Column(
                            children: [
                              Image(
                                image: AssetImage(
                                  'image/goldcal.png',
                                ),
                                height: 80,
                              ),
                              Text(
                                'Calender',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                          decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: Offset(0, 1),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                ),
                              ]),
                        ),
                        color: Colors.white,
                        type: MaterialType.canvas,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => Profile()));
                      },
                      child: Material(
                        child: Container(
                          child: Center(
                              child: Column(
                            children: [
                              Image(
                                  image: AssetImage(
                                    'image/goldset.png',
                                  ),
                                  height: 80),
                              Text(
                                'Settings',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                          decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: Offset(0, 1),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                ),
                              ]),
                        ),
                        color: Colors.white,
                        type: MaterialType.canvas,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Recent Payment',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 19),
                        ),
                      ],
                    ),
                    Container(
                        child: RecentPaid()),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}




// Thank you if you want to learn how to develop mobile apps or you want a app developed for you, You can reach us on our facebook page or our website at
//wwww.thereptor.com.ng

//Please make sure you like and follow for more update