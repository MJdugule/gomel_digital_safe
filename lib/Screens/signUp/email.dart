import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:websocket/Screens/provider/auth_provider.dart';
import 'package:websocket/Screens/signUp/conPass.dart';
import 'package:websocket/services/user_serv.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  var _emailTextField = TextEditingController();
  var _passwordText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String email;
  bool _visible = false;
  late String password;
  bool _loading = false;
  UserServices _userServices = UserServices();

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
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
                      'Let\'s',
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 60, fontWeight: FontWeight.bold, height: 1),
                    ),
                    Text(
                      'Get You Started',
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 60, fontWeight: FontWeight.bold, height: 1),
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
                        'Please enter your email and password',
                      ),
                    ),
                    TextFormField(
                      controller: _emailTextField,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        final bool _isValid =
                            EmailValidator.validate(_emailTextField.text);
                        if (!_isValid) {
                          return 'Invalid Email Format';
                        }
                        setState(() {
                          email = value;
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordText,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        if (value.length < 8) {
                          return 'Minimum 8 Characters';
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
                          hintText: 'Password',
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
                              final User? user =
                                  (await _authData.register(email, password))
                                      ?.user;

                              if (user != null) {
                                _userServices
                                    .getUserById(user.uid)
                                    .then((snapShot) {
                                  if (snapShot.exists) {
                                  } else {
                                    _authData.createUser(
                                      id: user.uid,
                                      password: password,
                                      email: email,
                                    );
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                ConfirmPassword()));
                                  }
                                });
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        elevation: 10,
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 3),
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _authData.error,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.red,
                                              size: 26,
                                            )
                                          ],
                                        )));
                              }
                            }
                            setState(() {
                              Loader.hide();

                              _loading = false;
                            });
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
