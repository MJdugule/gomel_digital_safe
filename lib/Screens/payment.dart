import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:websocket/Screens/wid/instrust.dart';
import 'package:websocket/Screens/provider/cartProvider.dart';
import 'package:websocket/Screens/wid/productCard.dart';
import 'package:websocket/services/poductServ.dart';
import 'package:intl/intl.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final _formKey = GlobalKey<FormState>();
  String? accname;
  String? accnum;
  String getCurrency() {
     Locale locale = Localizations.localeOf(context);
    var format =
        NumberFormat.currency(locale: Platform.localeName, name: 'NGN');
    return format.currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getCartTotal();
   // _cartProvider.getShopName();
    var amount = _cartProvider.ntotal;
    ProductServices _services = ProductServices();
    return Scaffold(
      bottomSheet: Material(
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          height: _cartProvider.cartQty > 0 ? 300 : 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_cartProvider.cartQty > 0)
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Amount',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.purple, width: 1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    Center(
                                      child: Text(
                                        '  ${getCurrency()} ' '$amount',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                //controller: _passwordText,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Field cannot be empty';
                                  }

                                  setState(() {
                                    accnum = value;
                                  });
                                  return null;
                                },
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.purple, width: 2)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.purple)),
                                    contentPadding: EdgeInsets.zero,
                                    hintText: 'Account Number',
                                    prefixIcon:
                                        Icon(Icons.format_list_numbered),
                                    focusColor: Theme.of(context).primaryColor),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                //controller: _emailTextField,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Field cannot be empty';
                                  }

                                  setState(() {
                                    accname = value;
                                  });
                                  return null;
                                },
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.purple, width: 2)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.purple)),
                                    contentPadding: EdgeInsets.zero,
                                    hintText: 'Account Name',
                                    prefixIcon: Icon(Icons.person),
                                    focusColor: Theme.of(context).primaryColor),
                              ),
                              // SizedBox(
                              //   height: 200,
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Loader.show(context,
                                    isSafeAreaOverlay: true,
                                
                                    isAppbarOverlay: true,
                                    isBottomBarOverlay: true,
                                    progressIndicator:
                                        CircularProgressIndicator(),
                                    themeData: Theme.of(context)
                                        .copyWith(accentColor: Colors.black38),
                                    overlayColor: Color(0x44FFFFFF));
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Instruct();
                        });
                         Loader.hide();
                  }
                },
                child: Container(
                  height: 54,
                  width: MediaQuery.of(context).size.width,
                  color: _cartProvider.cartQty > 0
                      ? Colors.green
                      : Colors.grey[300],
                  child: Center(
                    child: Text(
                      'Pay',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'sora',
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: _cartProvider.cartQty > 0
                              ? Colors.white
                              : Colors.grey[500]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.purple,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Make Payment',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Payment should be made through transfers only',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'sora',
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Select a week',
                style: TextStyle(fontSize: 17),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _services.weeks.orderBy('weekName').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        'Please check your internet connection and try again'),
                  );
                }

                if (!snapshot.hasData) {
                  return Container();
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Container();
                }

                return Padding(
                  padding: const EdgeInsets.all(
                    10.0,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        new GridView.count(
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 20.0,
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 3,
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            return new ProductCard(document);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 400,
            )
          ],
        ),
      ),
    );
  }
}
