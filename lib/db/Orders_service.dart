import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Pages/HomePage.dart';
import 'package:uuid/uuid.dart';

class OrderProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'orders';
  Future<List<DocumentSnapshot>> getOrderedProducts() => _firestore
          .collection('user')
          .document(loggedInUser.uid)
          .collection(ref)
          .getDocuments()
          .then((snaps) {
        return snaps.documents;
      });

  void uploadOrdersForUser(
      {String paymentMethod,
        String month,
        String date,
        String year,
        String orderDateTime,
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
    _firestore
        .collection('user')
        .document(loggedInUser.uid)
        .collection(ref)
        .document(productId)
        .setData({
      'paymentMethod': paymentMethod,
      'id': productId,
      'month':month,
      'year': year,
      'date':date,
      'dateTime':orderDateTime,
      'brand': brand,
      'description': description,
      'details': details,
      'currentPrice': currentPrice,
      'oldPrice': oldPrice,
      'quantity': quantity,
      'images': images,
      'size': size,
    });
  }


  void uploadOrderedProductsForAdmin(
      {String orderId,
        String brand,
        String category,
      String description,
      String details,
      double currentPrice,
      double oldPrice,
      int quantity,
      String size,
      List images}) {
    var id = Uuid();
    String productId = id.v1();
    _firestore
        .collection('orders')
        .document(orderId)
        .collection('products')
        .document(productId)
        .setData({
      'id':productId,
      'brand': brand,
      'category': category,
      'description': description,
      'details': details,
      'currentPrice': currentPrice,
      'oldPrice': oldPrice,
      'quantity': quantity,
      'images': images,
      'size': size,
    });
  }

  void uploadUsersDetailsForAdmin({
    String orderDateTime,
    String orderId,
    String month,
    String date,
    String year,
    String paymentMethod,
    double totalAmount,
    String name,
    String address,
    String mobileNo,
    String pinCode,
    String locality,
    String city,
    String state,
  }) {

    _firestore.collection('orders').document(orderId).setData({
      'id':orderId,
      'month':month,
      'year': year,
      'date':date,
      'dateTime':orderDateTime,
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount,
      'name': name,
      'address': address,
      'mobileNo': mobileNo,
      'locality': locality,
      'pinCode': pinCode,
      'city': city,
      'state': state,
    });
  }

  deleteData(docId) {
    Firestore.instance
        .collection('user')
        .document(loggedInUser.uid)
        .collection(ref)
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
