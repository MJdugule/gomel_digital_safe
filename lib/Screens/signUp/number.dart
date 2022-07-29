import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:websocket/Screens/home.dart';
import 'package:websocket/services/user_serv.dart';

class Phone extends StatefulWidget {
  const Phone({Key? key}) : super(key: key);

  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  var mobile = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  late String email;
  bool _visible = false;
  String? name;
  bool _loading = false;
  UserServices _user = UserServices();

  updateProfile() {
    return FirebaseFirestore.instance.collection('User').doc(user!.uid).update({
      'number': '+234' '${mobile.text}',
    });
  }

  
  @override
  void initState(){
    _user.getUserById(user!.uid).then((value){
      if(mounted){
        setState(() {
          name = value['firstName'];
      
          
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final _authData = Provider.of<AuthProvider>(context);
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
                      height: 90,
                    ),
                    if (name!=null)
                    Text(
                      'Hi'' '
                      '\'${name.toString()}\'',
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 60, fontWeight: FontWeight.bold, height: 1),
                    ),
                    Text(
                      'How may we reach you?',
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold, height: 1),
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
                        'Please enter your mobile number',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 1.0,
                                color: Colors.purple,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '+234',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                            ))),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: mobile,
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple, width: 2)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.purple,
                                )),
                                contentPadding: EdgeInsets.only(left: 10),
                                hintText: 'Mobile',
                                suffixIcon: Icon(Icons.phone_iphone_rounded),
                                focusColor: Theme.of(context).primaryColor),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your Mobile Number';
                              }
                              if (value.length < 10) {
                                return 'Enter your number without the \0 at the begining ';
                              }
                              if (value.startsWith('0')) {
                                return 'Please remove the \0 at the begining';
                              }
                              if (!value.startsWith('80')) {
                                if (!value.startsWith('81')) {
                                  if (!value.startsWith('90')) {
                                    if (!value.startsWith('91')) {
                                      if (!value.startsWith('70')) {
                                        return 'Invalid number';
                                      }
                                    }
                                  }
                                }

                                
                              }

                              return null;
                            },
                          ),
                        ),
                      ],
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
                                Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration:
                                            Duration(seconds: 1),
                                        transitionsBuilder:
                                            (BuildContext context,
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
                                          return Homescreen();
                                        })).then((value) => setState(() {
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
