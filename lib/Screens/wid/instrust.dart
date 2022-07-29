import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:websocket/Screens/profileUpdate.dart';
import 'package:websocket/Screens/provider/auth_provider.dart';
import 'package:websocket/Screens/provider/cartProvider.dart';
import 'package:websocket/Screens/provider/orderProvider.dart';
import 'package:websocket/services/cartService.dart';
import 'package:websocket/services/orderServices.dart';
import 'package:websocket/services/user_serv.dart';

class Instruct extends StatefulWidget {
  late final DocumentSnapshot document;

  @override
  _InstructState createState() => _InstructState();
}

class _InstructState extends State<Instruct> {
  UserServices _userService = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  CartServices _cartServices = CartServices();
  OrderServices _orderServices = OrderServices();
  String getCurrency() {
    // Locale locale = Localizations.localeOf(context);
    var format =
        NumberFormat.currency(locale: Platform.localeName, name: 'NGN');
    return format.currencySymbol;
  }


  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getCartTotal();
    // _cartProvider.getShopName();
    var name = _cartProvider.cName;
    var amount = _cartProvider.ntotal + 50;
    final orderProvider = Provider.of<OrderProvider>(context);
    var userDetails = Provider.of<AuthProvider>(context);

    return Dialog(
      insetPadding: EdgeInsets.only(left: 10, top: 80, bottom: 40, right: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: Column(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text(
                    'Note: You have to minimize the app and make payment then click the done button.',
                  ),
                ],
              ),
            ),
            Text(
              'Transfer ${getCurrency()}$amount for $name to the account below:',
              style: TextStyle(
                fontSize: 30,
                height: 1,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  '2288546764',
                  style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'sora',
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  'Zenith Bank',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            FlatButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Loader.show(context,
                    isSafeAreaOverlay: true,
                    isAppbarOverlay: true,
                    isBottomBarOverlay: true,
                    progressIndicator: CircularProgressIndicator(),
                    themeData:
                        Theme.of(context).copyWith(accentColor: Colors.black38),
                    overlayColor: Color(0x44FFFFFF));
                _userService.getUserById(user!.uid).then((value) {
                  if (value['firstName'] != null) {
                    if (value['number'] == null) {
                      Loader.hide();
                      showphoneDialog();
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                              transitionDuration: Duration(microseconds: 600),
                              transitionsBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                      Widget child) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                                return UpdateProfile();
                              }));
                    } else {
                      if (_cartProvider.cod == false) {
                        orderProvider.totalAmount(
                            amount,
                            // widget.document['shopName'],
                            userDetails.snapshot?['email']);
                        setState(() {
                          orderProvider.paymentStatus(true);
                        });

                        if (orderProvider.success == true) {
                          _saveOrder(_cartProvider, amount, orderProvider);
                        }
                      } else {
                        _saveOrder(_cartProvider, amount, orderProvider);
                      }
                    }
                  } else {
                    Loader.hide();
                    showphoneDialog();
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            transitionDuration: Duration(microseconds: 600),
                            transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return UpdateProfile();
                            }));
                  }
                });
              },
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Note: You are to minimize the app and make the transfer through your bank apps or ussd banking.',
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'The additional 50 naira is for bank charges and disburstment',
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Failure to pay the 50 naira will lead to subtraction from your money where 50 naira will be deducted from every week you have paid for. Thank you',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _saveOrder(CartProvider cartProvider, amount, OrderProvider orderProvider) {
    _orderServices.saveOrder({
      'products': cartProvider.cartList,
      'userId': user?.uid,
      'total': amount,
      'cod': cartProvider.cod,
      'Admin': cartProvider.admin,
      'timestamp': DateTime.now().toString(),
      'orderStatus': 'Pending',
    }).then((value) {
      orderProvider.success = false;
      _cartServices.deleteCart().then((value) {
        _cartServices.checkcartData().then((value) {
          Loader.hide();
          success();
          Navigator.pop(context);
          Navigator.pop(context);
        });
      });
    });
  }

  success() {
    Loader.show(
      context,
      isSafeAreaOverlay: true,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      themeData: Theme.of(context).copyWith(accentColor: Colors.black38),
      overlayColor: Color(0x44FFFFFF),
      progressIndicator: CupertinoAlertDialog(
        title: Icon(
          Icons.check,
          size: 60,
          color: Colors.green,
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () {
              Loader.hide();
            },
          )
        ],
        content: Text(
          'Payment made successfully, awaiting confirmation',
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  showphoneDialog() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'No Phone Number',
              style: TextStyle(fontSize: 20),
            ),
            content: Text(
              'Please add your Phone number',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
