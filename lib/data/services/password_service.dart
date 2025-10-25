import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_3/models/password_model.dart';

class PasswordService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  

  Stream<List<PasswordModel>> getPasswords(String userId) {
    return _db
        .collection('passwords')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PasswordModel.fromSnapshot(doc))
            .toList());
  }

  Future<void> addPassword(PasswordModel password) {
    return _db.collection('passwords').add(password.toJson());
  }


  Future<void> deletePassword(String docId) {
    return _db.collection('passwords').doc(docId).delete();
  }
}