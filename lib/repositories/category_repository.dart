import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepository {
  final Firestore _firestore;

  CategoryRepository() : _firestore = Firestore.instance;

  Future<QuerySnapshot> getTypesList(String category) {
    Future<QuerySnapshot> typesList = _firestore
        .collection("Human Force")
        .document("Category")
        .collection(category)
        .getDocuments();

    return typesList;
  }
}
