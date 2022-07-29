import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:websocket/Screens/wid/counterCard.dart';
import 'package:websocket/services/cartService.dart';


class AddToFav extends StatefulWidget {
  final DocumentSnapshot document;
  AddToFav(this.document);

  @override
  _AddToFavState createState() => _AddToFavState();
}

class _AddToFavState extends State<AddToFav> {
  CartServices _cart = CartServices();
  User? user = FirebaseAuth.instance.currentUser;
  bool _loading = true;
  bool _exist = false;
  int _qty = 1;
  String? _docId;


getCartData() async {
    final snapshot =
        await _cart.cart.doc(user?.uid).collection('Week').get();
     if(snapshot.docs.length == 0){
     if(mounted) { 
        setState(() {
                  _loading = false;
                });}
      }else{
       if(mounted) {setState(() {
                  _loading = false;
                });}
      }
    }
  
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('Cart')
        .doc(user?.uid)
        .collection('Week')
        .where('weekId', isEqualTo: widget.document['weekId'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                if (doc['weekId'] == widget.document['weekId']) {
                  if (this.mounted){setState(() {
                    _exist = true;
                    _qty = doc['qty'];
                    _docId = doc.id;
                  });}
                }
              })
            });

    return _loading
        ? Container(
          
            child: Center(
            child:  MirrorAnimation<double>(
                          tween: Tween(
                              begin: -40.0,
                              end: 40.0), // value for offset x-coordinate
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeInOutSine, // non-linear animation
                          builder: (context, child, value) {
                            return Transform.translate(
                              offset: Offset(value,
                                  30), // use animated value for x-coordinate
                              child: child,
                            );
                          },
                          child: CircleAvatar(
                            radius: 8,
                          )),
            ),
          )
        : _exist
            ? CounterForCard(
                document: widget.document,
                qty: _qty,
                docId: _docId??'',
              )
            : InkWell(
                onTap: () {
                  Loader.show(context,
                                    isSafeAreaOverlay: true,
                                
                                    isAppbarOverlay: true,
                                    isBottomBarOverlay: true,
                                    progressIndicator:
                                        CircularProgressIndicator(),
                                    themeData: Theme.of(context)
                                        .copyWith(accentColor: Colors.black38),
                                    overlayColor: Color(0x44FFFFFF));
                  _cart.addToCart(widget.document).then((value) {
                    setState(() {
                      _exist = true;
                    });
                   Loader.hide();
                  });
                },
                child: Center(
                  child: Container(
                    
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(
                          'Pay', style: TextStyle(fontSize: 14, fontFamily: 'sora', fontWeight: FontWeight.w500, color: Colors.purple),
                      ),
                       )

                      ],
                    ),
                  ),
                ),
                
                );
  }
  

  @override
  void initState() {
    if(mounted) {
      getCartData();
    }
    super.initState();
  }

  @override
  void dispose() {
    getCartData();
    super.dispose();
  }

}
