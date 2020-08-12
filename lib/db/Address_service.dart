import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Pages/HomePage.dart';
import 'package:uuid/uuid.dart';

class AddressService {
  Firestore _firestore = Firestore.instance;
  String ref = 'Address';
  Future<List<DocumentSnapshot>> getUserAddress()=>
      _firestore.collection('user').document(loggedInUser.uid).collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });

  void uploadAddress({
    String name,
    String mobileNo ,
    String address,
    String pinCode,
    String locality,
    String city,
    String state,}) {
    var id = Uuid();
    String addressId = id.v1();

    _firestore.collection('user').document(loggedInUser.uid).collection(ref).document(addressId).setData({
      'name':name,
      'mobileNo':mobileNo,
      'address':address,
      'pinCode':pinCode,
      'locality':locality,
      'city':city,
      'state':state,
      'id':addressId
    }
    );
  }
  deleteData(docId ){
    Firestore.instance.collection('user').document(loggedInUser.uid).collection(ref).document(docId).delete().catchError((e){print(e);});
  }
}