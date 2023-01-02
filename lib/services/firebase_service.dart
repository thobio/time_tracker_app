import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseService._();
  static final instance = FirebaseService._();

  Future<void> setData({
    required String path,
    Map<String, dynamic>? data,
  }) async {
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(data!);
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .where('email', isNotEqualTo: FirebaseAuth.instance.currentUser!.email);
    final snapshots = reference.snapshots();
    return snapshots.map(
        (snapshot) => snapshot.docs.map((e) => builder(e.data())).toList());
  }

  Stream<List<T>> collectionSelectAllStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
        (snapshot) => snapshot.docs.map((e) => builder(e.data())).toList());
  }
}
