import 'package:cloud_firestore/cloud_firestore.dart';
class ProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'products';

  Future<List<DocumentSnapshot>> getProducts() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });
}