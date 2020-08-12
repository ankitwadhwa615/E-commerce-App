import 'package:cloud_firestore/cloud_firestore.dart';
class CarouselImageService {
  Firestore _firestore = Firestore.instance;
  String ref = 'carouselImages';

  Future<List<DocumentSnapshot>> getCarouselImages() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });
}