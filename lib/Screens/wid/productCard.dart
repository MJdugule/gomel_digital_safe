import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:websocket/Screens/wid/addToFav.dart';
import 'package:websocket/Screens/wid/counterCard.dart';
import 'package:websocket/Screens/provider/cartProvider.dart';

class ProductCard extends StatelessWidget {
  final DocumentSnapshot document;
  ProductCard(this.document);

  String getCurrency() {
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return format.currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getCartTotal();

    return Material(
      color: Color(0x66bccae0),
      shadowColor: Color(0x66bccae0),
      elevation: 9,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
            color:
                document['published'] == true ? Colors.white : Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
            border: document['published'] == true
                ? Border.all(width: 1, color: Colors.purple)
                : Border.all(width: 0, color: Colors.grey)),
        // borderRadius: BorderRadius.circular(4),
        child: Stack(children: [
          Center(
            child: Text(
              document['weekName'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: document['published'] == true
                    ? Colors.black
                    : Colors.grey[500],
              ),
            ),
          ),
          if (document['published'] == true)
            Container(
              child: AddToFav(document),
            ),
        ]),
      ),
    );
  }
}
