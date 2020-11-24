import 'package:cloud_firestore/cloud_firestore.dart';
class CategoryService {
  Firestore _firestore = Firestore.instance;
  String ref = 'categories';

  Future<List<DocumentSnapshot>> getCategories() =>
      _firestore.collection(ref).orderBy('category',descending: false).getDocuments().then((snaps) {
        return snaps.documents;
      });
}