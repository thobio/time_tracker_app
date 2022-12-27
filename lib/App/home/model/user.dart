// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'dart:convert';

Users userFromMap(String str) => Users.fromMap(json.decode(str));

String userToMap(Users data) => json.encode(data.toMap());

class Users {
  Users({
    required this.age,
    required this.bp,
    required this.dateOfJoining,
    required this.email,
    required this.height,
    this.memberShipUid,
    required this.name,
    required this.phoneNumber,
    required this.roleUid,
    required this.weight,
  });

  String age;
  String bp;
  String dateOfJoining;
  String email;
  String height;
  String? memberShipUid;
  String name;
  String phoneNumber;
  String roleUid;
  String weight;

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        age: json["age"],
        bp: json["bp"],
        dateOfJoining: json["date_of_joining"],
        email: json["email"],
        height: json["height"],
        memberShipUid: json["member_ship_uid"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        roleUid: json["role_uid"],
        weight: json["weight"],
      );

  Map<String, dynamic> toMap() => {
        "age": age,
        "bp": bp,
        "date_of_joining": dateOfJoining,
        "email": email,
        "height": height,
        "member_ship_uid": memberShipUid,
        "name": name,
        "phone_number": phoneNumber,
        "role_uid": roleUid,
        "weight": weight,
      };
}
