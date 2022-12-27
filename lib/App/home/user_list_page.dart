import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/App/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:time_tracker_app/services/database.dart';

import '../common_widgets/show_exception_alert_dialog.dart';
import 'model/user.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({
    super.key,
  });

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } on Exception catch (e) {
      showExceptionAlertDialog(context, title: "Error", exception: e);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
        context: context,
        title: "Logout",
        content: "Are you sure you want to logout?",
        defaultActionText: 'Logout',
        cancelActionText: 'Cancel');
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final databases = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
        actions: <Widget>[
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: const Text(
              "Logout",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => SizedBox(
                      height: 100,
                      child: Center(
                        child: Row(children: [
                          Image.asset(
                            "images/google-logo.png",
                            height: 50,
                            width: 50,
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                Text(
                                  snapshot.data!.docs[index]['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Age:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]['age'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Height:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data!.docs[index]
                                                  ['height'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Weight:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data!.docs[index]
                                                  ['weight'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                              ]),
                        ]),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(
                  child: Text("No data found!"),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createUser(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void createUser(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createUser(Users(
        age: "31",
        bp: "165/100",
        dateOfJoining: "23 December 2022 at 00:00:00 UTC+5:30",
        email: "jthobio2@gmail.com",
        height: "189 cm",
        name: "Thobio Joseph",
        phoneNumber: "+919048128845",
        roleUid: "",
        weight: "150 kg",
        memberShipUid: "QF08QA3jvUFOjTWV62xi",
      ));
    } on Exception catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Operation failed",
        exception: e,
      );
    }
  }
}
