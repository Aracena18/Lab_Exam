import 'package:cloud_firestore/cloud_firestore.dart';

class CrudService {
  final CollectionReference foods =
      FirebaseFirestore.instance.collection('foods');

  // CREATE
  Future<void> addFood(String name) {
    return foods.add({
      'name': name,
      'created_at': Timestamp.now(),
    });
  }

  // READ
  Stream<QuerySnapshot> getFoods() {
    return foods.orderBy('created_at', descending: true).snapshots();
  }

  // UPDATE
  Future<void> updateFood(String id, String name) {
    return foods.doc(id).update({
      'name': name,
    });
  }

  // DELETE
  Future<void> deleteFood(String id) {
    return foods.doc(id).delete();
  }
}
