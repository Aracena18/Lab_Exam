import 'package:cloud_firestore/cloud_firestore.dart';

class CrudService {
  final CollectionReference items =
      FirebaseFirestore.instance.collection('items');

  // CREATE
  Future<void> addItem(String name, int quantity) {
    return items.add({
      'name': name,
      'quantity': quantity,
      'created_at': Timestamp.now(),
      'is_favorite': false,
    });
  }

  // READ
  Stream<QuerySnapshot> getItems() {
    return items.orderBy('created_at', descending: true).snapshots();
  }

  // UPDATE
  Future<void> updateItem(
    String id,
    String name,
    int quantity,
  ) {
    return items.doc(id).update({
      'name': name,
      'quantity': quantity,
    });
  }

  // EXTRA UPDATE EXAMPLE
  Future<void> toggleFavorite(
    String id,
    bool currentStatus,
  ) {
    return items.doc(id).update({
      'is_favorite': !currentStatus,
    });
  }

  // DELETE
  Future<void> deleteItem(String id) {
    return items.doc(id).delete();
  }
}
