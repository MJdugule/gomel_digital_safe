import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:websocket/Screens/wid/addToFav.dart';
import 'package:websocket/services/cartService.dart';

class CounterForCard extends StatefulWidget {
  final DocumentSnapshot document;
  CounterForCard(
      {required this.document, required this.qty, required this.docId});
  final String docId;
  final int qty;

  @override
  _CounterForCardState createState() => _CounterForCardState();
}

class _CounterForCardState extends State<CounterForCard> {
  CartServices _cart = CartServices();
  int _qty = 1;
  bool _exists = true;
  bool _updating = false;

  @override
  Widget build(BuildContext context) {
    return _exists
        ? Container(
            child: Center(
              child: InkWell(
                  onTap: () {
                    setState(() {
                      _updating = true;
                    });
                    if (_qty == 1) {
                      _cart.removeFromCart(widget.docId).then((value) {
                        setState(() {
                          _updating = false;
                          _exists = false;
                        });
                        _cart.checkcartData();
                      });
                    }
                    if (_qty > 1) {
                      setState(() {
                        _qty--;
                      });
                      var total = _qty * widget.document['price'];
                      _cart
                          .updateCartQty(widget.docId, _qty, total)
                          .then((value) {
                        setState(() {
                          _updating = false;
                        });
                      });
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.purple),
                        color: Colors.purple[600]),
                    child: Center(
                        child: Text(
                      widget.document['weekName'],
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          height: 1.2,
                          fontFamily: 'sora'),
                    )),
                  )),
            ),
          )
        : AddToFav(widget.document);
  }
}
