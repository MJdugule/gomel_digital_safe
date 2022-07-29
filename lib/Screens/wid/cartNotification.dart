import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:websocket/Screens/provider/cartProvider.dart';


class CartNotification extends StatefulWidget {
  @override
  _CartNotificationState createState() => _CartNotificationState();
}

class _CartNotificationState extends State<CartNotification> {
   var _emailTextField = TextEditingController();
  var _passwordText = TextEditingController();

    final _formKey = GlobalKey<FormState>();
  String getCurrency() {
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return format.currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getCartTotal();
    var amount = _cartProvider.ntotal;
    String accname;
    String accnum;

    return Visibility(
      visible: _cartProvider.cartQty > 0 ? true : false,
      child:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Center(
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
                          border: Border.all(color: Colors.purple, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          Center(
                            child: Text(
                              '${getCurrency()}' '$amount',
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
                      
                      controller: _passwordText,
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
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Account Number',
                          prefixIcon: Icon(Icons.format_list_numbered),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailTextField,
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
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Account Name',
                          prefixIcon: Icon(Icons.person),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    FlatButton(
                      onPressed: () async{
                        if (_formKey.currentState!.validate()) {
          
                        }
                       
                      },
                      child: Container(
                        height: 56,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.green[400],
                        child: Center(
                          child: Text(
                            'Pay',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'sora',
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      
    );
  }
}
