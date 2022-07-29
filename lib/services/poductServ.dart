import 'package:cloud_firestore/cloud_firestore.dart';

class ProductServices{
  CollectionReference weeks = FirebaseFirestore.instance.collection('Weeks');
}