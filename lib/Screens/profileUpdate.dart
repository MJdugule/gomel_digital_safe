import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:websocket/services/user_serv.dart';


class UpdateProfile extends StatefulWidget {
  static const String id ='update-profile';

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserServices _user = UserServices();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var mobile = TextEditingController();
  var email = TextEditingController();

  updateProfile(){
    return FirebaseFirestore.instance.collection('User').doc(user?.uid).update({
      'firstName' : firstName.text,
      'lastName' : lastName.text,
      'number' : '+234' '${mobile.text}',
    });
  }

  @override
  void initState(){
    _user.getUserById(user!.uid).then((value){
      if(mounted){
        setState(() {
          firstName.text = value['firstName'];
          lastName.text = value['lastName'];
          email.text = value['email'];
              mobile.text = value['number'];
          
        });
      }
    });
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Update Profile', style: TextStyle(color: Colors.black, fontSize: 17),),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      bottomSheet: InkWell(
        onTap: (){
         if(_formKey.currentState!.validate()){
           loading();
            //EasyLoading.show(status: 'Updating Profile....');
          updateProfile().then((value){
            Loader.hide();

                    success();

                    Future.delayed(Duration(seconds: 3), () {
                      Loader.hide();
                    });
        
            Navigator.pop(context);
          });
         }
        },
        child: Container(
          width: double.infinity,
          height: 56,
          color: Colors.blueGrey[900],
          child: Center(child: Text(
            'Update', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),),
        ),
      ),
      body: ListView(
        children: [Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 40,),
                    TextFormField(
                      controller: email,
                      enabled: false,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.purple,
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.grey[50], fontSize: 18),
                        contentPadding: EdgeInsets.all(9)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter Email address';
                        }
                        return null;
                      },
                    ),
                SizedBox(height: 40,),
                TextFormField(
                  controller: firstName,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    contentPadding: EdgeInsets.all(10),
                     focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.purple,
                          )),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter your First Name';
                    }
                    return null;
                  },
                ),
                 SizedBox(height: 40,),
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
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                        contentPadding: EdgeInsets.all(10)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter your Last Name';
                        }
                        return null;
                      },
                    ),
                SizedBox(height: 40,),
                Row(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text('+234', style:  TextStyle(color: Colors.grey, fontSize: 18),),
                      )
                    ),
                    SizedBox(width: 10,),
                        Expanded(
                          child: TextFormField(
                                
                            controller: mobile,
                            maxLength: 10,
                          keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                               focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.purple,
                          )),
                              suffixIcon: Icon(Icons.phone_android_outlined),
                              labelText: 'Mobile Number',
                              labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                              contentPadding: EdgeInsets.all(10)
                            ),
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
                  height: 100,
                )
              ],
            ),
          ),
        ),
        ]),
      
    );
  }

  loading() {
    Loader.show(context,
        isSafeAreaOverlay: false,
        isBottomBarOverlay: true,
        overlayFromBottom: 80,
        overlayColor: Colors.black26,
        progressIndicator: CircularProgressIndicator(),
        themeData: Theme.of(context).copyWith(accentColor: Colors.white));
  }

  success() {
    Loader.show(context,
        isSafeAreaOverlay: false,
        isBottomBarOverlay: true,
        overlayFromBottom: 80,
        overlayColor: Colors.black26,
        progressIndicator: Container(
          width: 260,
          child: CupertinoAlertDialog(
            title: Icon(
              Icons.check,
              size: 70,
              color: Colors.green,
            ),
            content: Text(
              'Profile Updated',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        themeData: Theme.of(context).copyWith(accentColor: Colors.white));
  }

}