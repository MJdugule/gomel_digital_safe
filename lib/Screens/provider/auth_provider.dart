import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:websocket/services/user_serv.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  String error = '';
  late String screen;
  late double latitude;
  late double longitude;
  late String address;
  late String location;
  bool loading = false;
  UserServices _userServices = UserServices();
   DocumentSnapshot? snapshot;

  Future<UserCredential?> register(email, password) async {
    this.email = email;
    this.password = password;

    notifyListeners();
    UserCredential?  userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak.';
        notifyListeners();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'An account already exists for that email.';
        notifyListeners();
        print('The account already exists for that email.');
      }else if (e.code == 'invalid-email') {
        this.error = 'The email provided is invalid.';
        notifyListeners();
        print('The email provided is invalid.');
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }
  
  Future<UserCredential?> login(email, password) async {
    this.email = email;
    this.password = password;
    notifyListeners();
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        this.error = 'The password provided is incorrect.';
        notifyListeners();
        print('The password provided is too incorrect.');
      } else 
      if (e.code == 'email-already-in-use') {
        this.error = 'An account already exists for that email.';
        notifyListeners();
        print('An account already exists for that email.');
      } else 
      if (e.code == 'invalid-email') {
        this.error = 'The email provided is invalid.';
        notifyListeners();
        print('The email provided is invalid.');
      }else 
      if (e.code == 'user-not-found') {
        this.error = 'The User email is not registered.';
        notifyListeners();
        print('The User email is not registered.');
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

   void createUser({
    String? id,
   String? number,
   String? email,
    String? password,
    
  }) async {
    try {
      _userServices.createUserData({
        'id': id,
        'number': null,
        'password' : password,
        'firstName' : null,
        'lastName' : null,
        'email' : email

      });
      this.loading = false;
      notifyListeners();
    } catch (e) {
      print('Error $e');
    }
  }

  void updateUser({
    String? id,
     String? number,
  }) async {
    try {
      _userServices.updateUserData({
        'id': id,
        'firstName' : null,
        'lastName' : null,
        'number': number,
      
       
      });
      this.loading = false;
      notifyListeners();
    } catch (e) {
      print('Error $e');
    }
  }

  getUserDetails() async {
    DocumentSnapshot result =  await FirebaseFirestore.instance
        .collection('User')
        .doc(_auth.currentUser?.uid)
        .get();
    // ignore: unnecessary_null_comparison
    if (result != null) {
      this.snapshot = result;
      notifyListeners();
    } else {
      //this.snapshot = null;
      notifyListeners();
    }

    return result;
  }
}