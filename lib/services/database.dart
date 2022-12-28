import 'package:time_tracker_app/App/home/model/user.dart';
import 'package:time_tracker_app/services/api_path.dart';
import 'package:time_tracker_app/services/firebase_service.dart';

import '../App/home/model/role.dart';

abstract class Database {
  Future<void> createUser(Users user);
  Stream<List<Users>> readUserStream();
  Stream<List<Role>> getAllRole();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;
  final _service = FirebaseService.instance;

  @override
  Future<void> createUser(Users user) => _service.setData(
        path: APIPath.user(uid),
        data: user.toMap(),
      );

  @override
  Stream<List<Users>> readUserStream() => _service.collectionStream(
        path: APIPath.allUser(),
        builder: (data) => Users.fromMap(data),
      );

  @override
  Stream<List<Role>> getAllRole() => _service.collectionSelectAllStream(
        path: APIPath.allRole(),
        builder: (data) => Role.fromMap(data),
      );
}
