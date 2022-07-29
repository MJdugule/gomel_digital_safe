import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:websocket/Screens/login.dart' as user;
import 'package:websocket/Screens/login.dart';
import 'package:websocket/Screens/signUp/email.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String id = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('image/gomel21.png')),
              Text(
                'Welcome!!',
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.00009,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 20,
                  child: AnimatedTextKit(
                      repeatForever: true,
                      pause: Duration(milliseconds: 1500),
                      animatedTexts: [
                        ScaleAnimatedText(
                          "Save and pack more",
                          scalingFactor: 1,
                          duration: Duration(milliseconds: 5000),
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'sora',
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    child: SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.purple),
                                      ),
                                      new Divider(
                                        color: Colors.red,
                                      ),
                                      Text(
                                        'Login with your email and password',
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  thickness: 1,
                                ),
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  user.LoginScreen()));
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.purple,
                                    )),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 1.0, color: Color(0x99bccae0)),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x99bccae0),
                                offset: Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => EmailScreen()));
                    },
                    child: SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.purple),
                                      ),
                                      new Divider(
                                        color: Colors.red,
                                      ),
                                      Text(
                                        'Register with your email and password',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  thickness: 1,
                                ),
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  EmailScreen()));
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.purple,
                                    )),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 1.0, color: Color(0x99bccae0)),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x99bccae0),
                                offset: Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 94,
                  ),
                  Text(
                    '@2022 MJ Gomel Digital Save Limited',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
