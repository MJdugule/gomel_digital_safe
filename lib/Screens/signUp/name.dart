import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:websocket/Screens/signUp/number.dart';
import 'package:websocket/services/user_serv.dart';

class Name extends StatefulWidget {
  const Name({Key? key}) : super(key: key);

  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  late String email;
  late String name;
  bool _loading = false;

  var firstName = TextEditingController();
  var lastName = TextEditingController();

  updateProfile() {
    return FirebaseFirestore.instance.collection('User').doc(user!.uid).update({
      'firstName': firstName.text,
      'lastName': lastName.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: _formKey,
          child: Container(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      'Welcome!!',
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 60, fontWeight: FontWeight.bold, height: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        child: AnimatedTextKit(
                            repeatForever: true,
                            pause: Duration(milliseconds: 100),
                            animatedTexts: [
                              ScaleAnimatedText(
                                "We will love to know you more",
                                scalingFactor: 1,
                                duration: Duration(milliseconds: 6000),
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'sora',
                                ),
                              ),
                            ]),
                      ),
                    ),
                    Center(
                      child: MirrorAnimation<double>(
                          tween: Tween(
                              begin: -120.0,
                              end: 120.0), // value for offset x-coordinate
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeInOutSine, // non-linear animation
                          builder: (context, child, value) {
                            return Transform.translate(
                              offset: Offset(value,
                                  20), // use animated value for x-coordinate
                              child: child,
                            );
                          },
                          child: CircleAvatar(
                            radius: 15,
                          )),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 10),
                      child: Text(
                        'Please enter your name',
                      ),
                    ),
                    TextFormField(
                      controller: firstName,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.purple,
                          )),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'First Name',
                          prefixIcon: Icon(Icons.person),
                          focusColor: Theme.of(context).primaryColor),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your First Name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: lastName,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.purple,
                          )),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Last NAme',
                          prefixIcon: Icon(Icons.person),
                          focusColor: Theme.of(context).primaryColor),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your Last Name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                          padding: EdgeInsets.zero,
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                                Loader.show(context,
                                    isSafeAreaOverlay: false,
                                    isAppbarOverlay: true,
                                    isBottomBarOverlay: true,
                                    progressIndicator:
                                        CircularProgressIndicator(),
                                    themeData: Theme.of(context)
                                        .copyWith(accentColor: Colors.black38),
                                    overlayColor: Color(0xD3FFFFFF));
                              });
                              updateProfile().then((value) {
                                Navigator.of(context)
                                    .push(CupertinoPageRoute(
                                        builder: (context) => Phone()))
                                    .then((value) => setState(() {
                                          _loading = false;
                                        }));
                                Loader.hide();
                              });
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 19,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    ));
  }
}
