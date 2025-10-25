import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordModel {
  final String? id;
  final String label;
  final String password;
  final String userId;

  PasswordModel({
    this.id,
    required this.label,
    required this.password,
    required this.userId,
  });


  factory PasswordModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PasswordModel(
      id: doc.id,
      label: data['label'],
      password: data['password'],
      userId: data['userId'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'password': password,
      'userId': userId,
    };
  }
}