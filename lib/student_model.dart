// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class Student {
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? CreatedAt;
  final String? MobileNo;
  Student({
    this.id,
    this.firstname,
    this.lastname,
    this.CreatedAt,
    this.MobileNo,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      CreatedAt: map['CreatedAt'],
      MobileNo: map['MobileNo'],
    );
  }

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Student(id: $id, firstname: $firstname, lastname: $lastname, CreatedAt: $CreatedAt, MobileNo: $MobileNo)';
  }

  @override
  bool operator ==(covariant Student other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.CreatedAt == CreatedAt &&
       other.MobileNo == MobileNo;

  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstname.hashCode ^
        lastname.hashCode ^
        CreatedAt.hashCode ^
        MobileNo.hashCode;
  }
}
