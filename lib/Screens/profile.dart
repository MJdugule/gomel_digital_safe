import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:websocket/Screens/profileUpdate.dart';
import 'package:websocket/Screens/provider/auth_provider.dart';
import 'package:websocket/Screens/welcome.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthProvider userDetails = AuthProvider();
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? doc;
  String? firstname;
  String? lastname;
  String? name1;
  String? number;
  String? email;

  @override
  void initState() {
    userDetails.getUserDetails().then((value) {
      if (this.mounted) {
        setState(() {
          doc = value;
          firstname = userDetails.snapshot?['firstName'];
          lastname = userDetails.snapshot?['lastName'];
          name1 = userDetails.snapshot?['firstName'][0];
          email = userDetails.snapshot?['email'];
          email = userDetails.snapshot?['number'];
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 18.0, left: 8),
        child: FloatingActionButton(
          elevation: 15,
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
                                          builder: (context) => UpdateProfile()));
          },
          child: Icon(
            Icons.edit_outlined,
            color: Colors.white,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'MY ACCOUNT',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          controller: ScrollController(),
            //physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                        right: 1,
                        left: 60,
                        bottom: 80,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.black,
                        )),
                    Positioned(
                        right: 0,
                        left: 300,
                        bottom: 10,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.red,
                        )),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      
                        borderRadius: BorderRadius.circular(20),
                        gradient: RadialGradient(
                            center: Alignment(-0.8, 0.5),
                            focalRadius: 3.0,
                            focal: Alignment(0.3, -2),
                            colors: [
                              Colors.purple.withOpacity(.2),
                              Colors.purple.shade800.withOpacity(1),
                            ]),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              borderRadius: BorderRadius.circular(25),
                              elevation: 15,
                              child: CircleAvatar(
                                radius: 38,
                                backgroundColor: Colors.white,
                                child: Center(
                                  child: Text(
                                    userDetails.snapshot?['firstName'] != null
                                        ? '${userDetails.snapshot?['firstName'][0]}'
                                        : 'G',
                                    style: TextStyle(
                                      fontSize: 49,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                             SizedBox(
                              height: 30,
                            ),
                            Column(
                              children: [
                                Text(
                                  userDetails.snapshot?['firstName'] != null
                                      ? '${userDetails.snapshot?['firstName']}'
                                          ' '
                                          '${userDetails.snapshot?['lastName']}'
                                      : 'Update Your Name',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.7,
                                      wordSpacing: 1,
                                      fontSize: userDetails
                                                  .snapshot?['firstName'] ==
                                              null
                                          ? 21
                                          : 23,
                                      height: 1.3,
                                      fontFamily: 'sora',
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 5, right: 5),
                  trailing: Container(
                    child: Text(
                      userDetails.snapshot?['email'] != null
                          ? '${userDetails.snapshot?['email']}'
                          : 'Loading....',
                      style: TextStyle(
                          height: 1.3,
                          fontFamily: 'sora',
                          color: Colors.grey[600],
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  onTap: () {},
                  leading: Icon(
                    Icons.email_outlined,
                    size: 30,
                    color: Colors.deepOrange,
                  ),
                  title: Text(
                    'Email',
                    style: TextStyle(
                      height: 1.3,
                    ),
                  ),
                  horizontalTitleGap: 1,
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 5, right: 5),
                  trailing: Container(
                    child: Text(
                      userDetails.snapshot?['number'] != null
                          ? '${userDetails.snapshot?['number']}'
                          : '',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 17,
                        height: 1.3,
                        fontFamily: 'sora',
                      ),
                    ),
                  ),
                  onTap: () {},
                  leading: Icon(
                    Icons.call_outlined,
                    size: 30,
                    color: Colors.green,
                  ),
                  title: Text(
                    'Phone',
                    style: TextStyle(
                      height: 1.3,
                    ),
                  ),
                  horizontalTitleGap: 1,
                ),
                Divider(
                  color: Colors.grey[400],
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 5, right: 5),
                  trailing: Text(
                    'On',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 17,
                      height: 1.3,
                      fontFamily: 'sora',
                    ),
                  ),
                  onTap: () {},
                  leading: Icon(
                    Icons.notifications_none,
                    size: 30,
                    color: Colors.purple,
                  ),
                  title: Text(
                    'Notifications',
                    style: TextStyle(
                      height: 1.3,
                    ),
                  ),
                  horizontalTitleGap: 1,
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 5, right: 5),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showhelpDialog();
                  },
                  leading: Icon(
                    Icons.help_outline_rounded,
                    size: 30,
                    color: Colors.indigo,
                  ),
                  title: Text(
                    'Help',
                    style: TextStyle(
                      height: 1.3,
                    ),
                  ),
                  horizontalTitleGap: 1,
                ),
                ListTile(
                  
                  contentPadding: EdgeInsets.only(left: 5, right: 5),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                  //  privacy();
                  },
                  leading: Icon(
                    Icons.privacy_tip_outlined,
                    size: 30,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(
                      height: 1.3,
                    ),
                  ),
                  horizontalTitleGap: 1,
                ),  
                 ListTile(
                  
                  contentPadding: EdgeInsets.only(left: 5, right: 5),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                  //terms();
                  },
                  leading: Icon(
                    Icons.sticky_note_2_outlined,
                    size: 30,
                    color: Colors.brown,
                  ),
                  title: Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      height: 1.3,
                    ),
                  ),
                  horizontalTitleGap: 1,
                ),
                Divider(
                  color: Colors.grey[400],
                ),
                ListTile(
                //mouseCursor: MouseCursor.uncontrolled,
                  hoverColor: Colors.purple,
                  contentPadding: EdgeInsets.only(left: 5, right: 5),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showAboutDialog(context: context,
                    
                    applicationIcon: Container(
                      height: 70,
                      width: 70,
                      child: Image.asset('image/gomel21.png')),
                    applicationName: 'Gomel Digital Save',
                    applicationVersion: '1.0.0',
                    children: [
                      Text('Visual app made for contribution records')
                    ]
                    );
                    
                  },
                  leading: Icon(
                    Icons.info,
                    size: 30,
                    color: Colors.purple,
                  ),
                  title: Text(
                    'About',
                    style: TextStyle(
                      height: 1.3,
                    ),
                  ),
                  horizontalTitleGap: 1,
                ),
                ListTile(
                  hoverColor: Colors.purple,
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.only(left: 5, right: 5),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showDialog();
                  },
                  leading: Icon(
                    Icons.power_settings_new,
                    size: 30,
                    color: Colors.red[900],
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      height: 1.3,
                    ),
                  ),
                  horizontalTitleGap: 1,
                ),
              ],
            )),
      ),
    );
  }

  // privacy(){
  //    showCupertinoDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           insetPadding: EdgeInsets.only(top: 110, right: 30, left: 30, bottom: 60),
  //          child: Column(children: [
  //            Expanded(child: 
  //            FutureBuilder(
  //              future: Future.delayed(Duration(milliseconds: 150)).then((value) {
  //                return rootBundle.loadString('assets/privacy_policies.md');
  //              }),
  //              builder: (context, snapshot){
  //                if(snapshot.hasData){
  //                  return Markdown(data: snapshot.data.toString(),);
  //                }
  //                return Center(child: CircularProgressIndicator(),);
  //              },
  //            )),
  //            FlatButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text(
  //                 'Close',
  //                 style: TextStyle(
  //                   color: Theme.of(context).primaryColor,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //          ],),
  //         );
  //       });
  // }
  // terms(){
  //    showCupertinoDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           insetPadding: EdgeInsets.only(top: 110, right: 30, left: 30, bottom: 60),
  //          child: Column(children: [
  //            Expanded(child: 
  //            FutureBuilder(
  //              future: Future.delayed(Duration(milliseconds: 150)).then((value) {
  //                return rootBundle.loadString('assets/terms_and_condition.md');
  //              }),
  //              builder: (context, snapshot){
  //                if(snapshot.hasData){
  //                  return Markdown(data: snapshot.data.toString(),);
  //                }
  //                return Center(child: CircularProgressIndicator(),);
  //              },
  //            )),
  //            FlatButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text(
  //                 'Close',
  //                 style: TextStyle(
  //                   color: Theme.of(context).primaryColor,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //          ],),
  //         );
  //       });
  // }

  showDialog() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              'Log Out',
              style: TextStyle(fontSize: 20),
            ),
            content: Text(
              'Are you sure you want to Log out?',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (context) {
                      return WelcomeScreen();
                    },
                  ), ModalRoute.withName('/welcome-screen'));
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          );
        });
  }
  showhelpDialog() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Contact Us',
              style: TextStyle(fontSize: 20),
            ),
            content: Text(
              'email: morkaj360@gmail.com \n24hr Customer Care: +2348117913480',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
           
           ],
          );
       });
  }

  
}
