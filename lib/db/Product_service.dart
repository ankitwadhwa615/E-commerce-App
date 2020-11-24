import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'products';

  Future<List<DocumentSnapshot>> getProducts() =>
      _firestore.collection(ref).orderBy('dateTime',descending: true).getDocuments().then((snaps) {
        return snaps.documents;
      });

  Future<List<DocumentSnapshot>> getProductsAscending() => _firestore
          .collection("products")
          .orderBy("currentPrice")
          .getDocuments()
          .then((snaps) {
        return snaps.documents;
      });
  Future<List<DocumentSnapshot>> getProductsByCategory(String category) => _firestore
          .collection("products")
          .where('category', isEqualTo: category)
          .getDocuments()
          .then((snaps) {
        return snaps.documents;
      });
  Future<List<DocumentSnapshot>> getProductsDescending() => _firestore
      .collection("products")
      .orderBy("currentPrice", descending: true)
      .getDocuments()
      .then((snaps) {
    return snaps.documents;
  });
}
