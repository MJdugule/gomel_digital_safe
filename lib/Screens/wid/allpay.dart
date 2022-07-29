import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:websocket/Screens/provider/orderProvider.dart';
import 'package:websocket/services/orderServices.dart';

class AllPayment extends StatefulWidget {
  static const String id = 'my-order';
  @override
  _AllPaymentState createState() => _AllPaymentState();
}

class _AllPaymentState extends State<AllPayment> {
  OrderServices _orderServices = OrderServices();
  User? user = FirebaseAuth.instance.currentUser;
  String getCurrency() {
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return format.currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    var _orderProvider = Provider.of<OrderProvider>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: _orderServices.orders
          .where('userId', isEqualTo: user?.uid)
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

        return new ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: new Container(
                padding: EdgeInsets.zero,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 14,
                            child: _orderServices.statusIcon(document)),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              document['orderStatus'],
                              style: TextStyle(
                                  fontSize: 12,
                                  color: _orderServices.statusColor(document),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Payment Method : ${document['cod'] == true ? 'Cash on delivery' : 'Transfer'}',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          'On ${DateFormat.yMMMd().format(
                            DateTime.parse(document['timestamp']),
                          )}',
                          style: TextStyle(fontSize: 12),
                        ),
                        children: [
                          Container(
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 19),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (document['orderStatus'] == 'Pending')
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              // Text('Pending '),
                                              CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  radius: 13,
                                                  child: Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                  )),
                                              Text('Pending')
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 2,
                                                width: 90,
                                                color: Colors.red,
                                              ),
                                              Text('')
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    Colors.grey[400],
                                                radius: 13,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 11,
                                                ),
                                              ),
                                              Text('Seen')
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 2,
                                                width: 90,
                                                color: Colors.grey[400],
                                              ),
                                              Text('')
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    Colors.grey[400],
                                                radius: 13,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 11,
                                                ),
                                              ),
                                              Text('Confirmed')
                                            ],
                                          ),
                                        ],
                                      ),
                                    if (document['orderStatus'] == 'Accepted')
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              // Text('Pending '),
                                              CircleAvatar(
                                                  backgroundColor: Colors.green,
                                                  radius: 13,
                                                  child: Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                  )),
                                              Text('Pending')
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 2,
                                                width: 90,
                                                color: Colors.green,
                                              ),
                                              Text('')
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              CircleAvatar(
                                                  backgroundColor: Colors.green,
                                                  radius: 13,
                                                  child: Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                  )),
                                              Text('Seen '),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 2,
                                                width: 90,
                                                color: Colors.green,
                                              ),
                                              Text('')
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              CircleAvatar(
                                                  backgroundColor: Colors.green,
                                                  radius: 13,
                                                  child: Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                  )),
                                              Text('Confirmed '),
                                            ],
                                          ),
                                        ],
                                      ),
                                    if (document['orderStatus'] == 'Rejected')
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              // Text('Pending '),
                                              CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  radius: 13,
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: Colors.white,
                                                  )),
                                              Text('Pending')
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 2,
                                                width: 70,
                                                color: Colors.red,
                                              ),
                                              Text('')
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              // Text('Pending '),
                                              CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  radius: 13,
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: Colors.white,
                                                  )),
                                              Text('Seen')
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 2,
                                                width: 70,
                                                color: Colors.red,
                                              ),
                                              Text('')
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              // Text('Pending '),
                                              CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  radius: 13,
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: Colors.white,
                                                  )),
                                              Text('Confirmed')
                                            ],
                                          ),
                                        ],
                                      )
                                  ],
                                );
                              },
                              itemCount: document['products'].length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
