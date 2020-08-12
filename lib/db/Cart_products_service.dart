import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Pages/HomePage.dart';
import 'package:uuid/uuid.dart';

class CartProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'cartproducts';
  Future<List<DocumentSnapshot>> getCartProducts()=>
      _firestore.collection('user').document(loggedInUser.uid).collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });

  void uploadProducts({
    String brand,
    String description,
    String details,
    double currentPrice,
    double oldPrice,
    int quantity,
    String size,
    List images}) {
    var id = Uuid();
    String productId = id.v1();

    _firestore.collection('user').document(loggedInUser.uid).collection(ref).document(productId).setData({
      'id': productId,
      'brand': brand,
      'description':description,
      'details':details,
      'currentPrice':currentPrice,
      'oldPrice':oldPrice,
      'quantity':quantity,
      'images':images,
      'size':size,
    }
    );
  }
  updateData(docId,update){
    Firestore.instance.collection('user').document(loggedInUser.uid).collection(ref).document(docId).updateData({'quantity':update});
  }
  deleteData(docId ){
    Firestore.instance.collection('user').document(loggedInUser.uid).collection(ref).document(docId).delete().catchError((e){print(e);});
  }
}