import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:websocket/services/orderServices.dart';

class RecentPaid extends StatefulWidget {
  static const String id = 'my-order';
  @override
  _RecentPaidState createState() => _RecentPaidState();
}

class _RecentPaidState extends State<RecentPaid> {
  OrderServices _orderServices = OrderServices();
  User? user = FirebaseAuth.instance.currentUser;
  String getCurrency() {
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return format.currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _orderServices.orders
          .where('userId', isEqualTo: user?.uid)
          .orderBy('timestamp')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.size == 0) {
          return Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('No Recent Payment'),
              ),
            ),
          );
        }

        return new GridView.count(
          childAspectRatio: 1.0,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 1.0,
          scrollDirection: Axis.vertical,
          crossAxisCount: 5,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: CircleAvatar(
                  backgroundColor: _orderServices.statusColor(document),
                  radius: 25,
                  child: Icon(
                    document['orderStatus'] == 'Accepted'
                        ? document['orderStatus'] == 'Pending'
                            ? Icons.cancel
                            : Icons.check
                        : Icons.donut_large_outlined,
                    size: 50,
                    color: Colors.white,
                  )),
            );
          }).toList(),
        );
      },
    );
  }
}
