import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:websocket/Screens/signUp/name.dart';
import 'package:websocket/services/user_serv.dart';

class ConfirmPassword extends StatefulWidget {
  const ConfirmPassword({Key? key}) : super(key: key);

  @override
  _ConfirmPasswordState createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  var _conpasswordText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String email;
  bool _visible = false;
  late String password;
  bool _loading = false;
  UserServices _userServices = UserServices();

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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
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
                                  10), // use animated value for x-coordinate
                              child: child,
                            );
                          },
                          child: CircleAvatar(
                            radius: 15,
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 10),
                      child: Text(
                        'Please confirm enter your password',
                      ),
                    ),
                    TextFormField(
                      controller: _conpasswordText,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field cannot be empty';
                        }

                        setState(() {
                          password = value;
                        });
                        return null;
                      },
                      obscureText: _visible == false ? true : false,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: _visible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.purple,
                          )),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Retype Password',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          focusColor: Theme.of(context).primaryColor),
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
                              var user = FirebaseAuth.instance.currentUser;
                              _userServices
                                  .getUserById(user!.uid)
                                  .then((snapShot) {
                                if (snapShot.exists) {
                                  if (snapShot['password'] ==
                                      _conpasswordText.text) {
                                    setState(() {
                                      
                                        Loader.hide();
                                      
                                      _loading = false;
                                    });
                                    Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) => Name()));
                                  } else {
                                    setState(() {
                                      Loader.hide();

                                      _loading = false;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            elevation: 10,
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 3),
                                            content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Password does not match',
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                Icon(
                                                  Icons.cancel_outlined,
                                                  color: Colors.red,
                                                  size: 26,
                                                )
                                              ],
                                            )));
                                  }
                                } else {
                                  Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                          transitionDuration:
                                              Duration(seconds: 1),
                                          transitionsBuilder: (BuildContext
                                                      context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation,
                                                  Widget child) =>
                                              FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              ),
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation) {
                                            return ConfirmPassword();
                                          }));
                                }
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
