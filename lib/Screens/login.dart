import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:websocket/Screens/home.dart';
import 'package:websocket/Screens/provider/auth_provider.dart';
import 'package:websocket/Screens/signUp/email.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late Icon icon;
  bool _visible = false;
  var _emailTextField = TextEditingController();
  late String email;
  late String password;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                    child: Container(
                        child: SingleChildScrollView(
                            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                          height: 120,
                          width: 120,
                          child: Image.asset('image/gomel21.png')),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Text(_authData.error),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailTextField,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Email';
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
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2)),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Password';
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
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              // Navigator.pushNamed(context, ResetPassword.id);
                            },
                            child: Text(
                              'Forgot Password?',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
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
                                      themeData: Theme.of(context).copyWith(
                                          accentColor: Colors.black38),
                                      overlayColor: Color(0xD3FFFFFF));
                                });
                                _authData
                                    .login(email, password)
                                    .then((credential) {
                                  if (credential != null) {
                                    setState(() {
                                      Loader.hide();
                                      _loading = false;
                                    });
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
                                                ScaleTransition(
                                                  scale: animation,
                                                  child: child,
                                                ),
                                            pageBuilder: (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation) {
                                              return Homescreen();
                                            }));
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
                                                  _authData.error,
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
                                });
                              }
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        FlatButton(
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: 'Dont have an account? ',
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: 'SignUp',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red))
                            ])),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 900),
                                      transitionsBuilder: (BuildContext context,
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
                                        return EmailScreen();
                                      }));
                            }),
                      ],
                    ),
                  ],
                )))))));
  }
}
