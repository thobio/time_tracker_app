import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker_app/App/home/model/user.dart';
import 'package:time_tracker_app/services/api_path.dart';

abstract class Database {
  Future<void> createUser(Users user);
  Future<String> readUserStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;

  @override
  Future<void> createUser(Users user) => _setData(
        path: APIPath.user(uid),
        data: user.toMap(),
      );

  @override
  Future<String> readUserStream() async {
    final path = APIPath.allUser();
    final snapshots = FirebaseFirestore.instance.collection(path).get();
    // ignore: await_only_futures
    return await snapshots.then((value) => value.toString()).toString();
  }

  Future<void> _setData({
    required String path,
    Map<String, dynamic>? data,
  }) async {
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(data!);
  }
}
