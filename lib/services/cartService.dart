import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartServices {
  CollectionReference cart = FirebaseFirestore.instance.collection('Cart');
  CollectionReference favour =
      FirebaseFirestore.instance.collection('Favourites');
  User? user = FirebaseAuth.instance.currentUser!;

  Future<void> addToCart(document) {
    cart.doc(user!.uid).set({
      'user': user!.uid,
      'AdminUid': document.data()['AdminUid'],
    });

    return cart.doc(user!.uid).collection('Week').add({
      'weekId': document.data()['weekId'],
      'weekName': document.data()['weekName'],
      'Amount': document.data()['Amount'],
      'AdminUid': document.data()['AdminUid'],
      'qty': 1,
      
    });
  }

  Future<void> updateCartQty(docId, qty, total) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Cart')
        .doc(user!.uid)
        .collection('Week')
        .doc(docId);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception("Week does not exist");
          }

          // Update the follower count based on the current count
          // Note: this could be done without a transaction
          // by updating the population using FieldValue.increment()

          // Perform an update on the document
          transaction.update(documentReference, {
            'qty': qty,
           // 'total': total,
          });

          // Return the new count
          return qty;
        })
        .then((value) => print("Cart Updated"))
        .catchError((error) => print("Failed to update cart: $error"));
  }

  Future<void> removeFromCart(docId) async {
    cart.doc(user!.uid).collection('Week').doc(docId).delete();
  }

  Future<void> checkcartData() async {
    final snapshot = await cart.doc(user!.uid).collection('Week').get();
    if (snapshot.docs.length == 0) {
      cart.doc(user!.uid).delete();
    }
  }


  Future<void> deleteCart() async {
    await cart.doc(user!.uid).collection('Week')
    .get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
   Future<void> deleteweekCart() async {
    await cart.doc(user!.uid).collection('Week').doc().delete();
   
    }


  Future<String> checkSeller() async {
    final snapshot = await cart.doc(user?.uid).get();
    return snapshot.exists ? snapshot['AdminUid'] : null;
  }
}
