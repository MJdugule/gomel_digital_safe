import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:websocket/Screens/home.dart';
import 'package:websocket/Screens/login.dart';
import 'package:websocket/Screens/provider/auth_provider.dart';
import 'package:websocket/Screens/signUp/email.dart';
import 'package:websocket/Screens/welcome.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthProvider userDetails = AuthProvider();
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    userDetails.getUserDetails();
    Timer(
        Duration(
          seconds: 4,
        ), () {
    
        
          Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(microseconds: 600),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return NoInternet();
                    }));
        
      
    });
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    userDetails.getUserDetails();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      Text('Try');
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user == null) {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(microseconds: 600),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return WelcomeScreen();
                    }));
          } else {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(microseconds: 600),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return Homescreen();
                    }));
          }
        });
        break;
      case ConnectivityResult.mobile:
     
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user == null) {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(microseconds: 600),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return WelcomeScreen();
                    }));
          } else {
          
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(microseconds: 600),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return Homescreen();
                    }));
          
          }
        });
                                            
        break;
      case ConnectivityResult.none:
      
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }
}

class NoInternet extends StatelessWidget {
  const NoInternet({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.purple, size: 50,),
            Text('No internet connection', style: TextStyle(fontSize: 18),),
            SizedBox(height: 20,),
            FlatButton(
              color: Colors.blue,
              onPressed: (){
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context) {
        return SplashScreen();
      },
    ), ModalRoute.withName('/splash-screen'));
              }, child: Text('Reload', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),))
          ],
        ),
      ),
    );
  }
}