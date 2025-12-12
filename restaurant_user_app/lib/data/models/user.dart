// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final int id;
  final String phoneNo;
  final int points;

  User({required this.id, required this.phoneNo, required this.points});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"], phoneNo: json["phone_no"], points: json["points"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone_no": phoneNo,
    "points": points,
  };
}
