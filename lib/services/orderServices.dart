import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderServices{
  CollectionReference orders = FirebaseFirestore.instance.collection('Order');

  Future<DocumentReference>saveOrder(Map<String, dynamic>data){
    var result = orders.add(
      data
    );
    return result;
  }
  

  Color statusColor(DocumentSnapshot document) {
    if (document['orderStatus'] == 'Accepted') {
      return Colors.green;
    }
    if (document['orderStatus'] == 'Rejected') {
      return Colors.red;
    }
    if (document['orderStatus'] == 'Completed') {
      return Colors.green;
    }
    return Colors.orange;
  }
  
  Icon statusIcon(DocumentSnapshot document) {
    if (document['orderStatus'] == 'Accepted') {
      return Icon(Icons.check, color: statusColor(document),);
    }

    if (document['orderStatus'] == 'Completed') {
      return Icon(Icons.check, color: statusColor(document),);
    }
    return Icon(Icons.pending_actions, color: statusColor(document),);
  }

   String statusComment(document,){
   if (document['orderStatus']=='Accepted'){
     return 'Your order has been Accepted by ${document['seller']['shopName']}';
   }
   
   if (document['orderStatus']=='Delivered'){
     return 'Your order has been delivered';
   }
   return 'Your order has been Accepted by ${document['seller']['shopName']}';
 }

}