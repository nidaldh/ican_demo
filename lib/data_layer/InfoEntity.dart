import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class InfoEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final int age;

  const InfoEntity(this.firstName, this.lastName, this.age,this.id);


  Map<String, Object> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "age": age,
      "id": id,
    };
  }

  static InfoEntity fromJson(Map<String, Object> json) {
    return InfoEntity(
      json["first_name"] as String,
      json["last_name"] as String,
      json["age"] as int,
      json["id"] as String,
    );
  }

  @override
  List<Object> get props => [firstName,lastName,age,id];

  @override
  String toString() {
    return 'InfoEntity { firstName: $firstName, lastName: $lastName,'
        ' age: $age, id: $id }';
  }

  static InfoEntity fromSnapshot(DocumentSnapshot snap) {
    return InfoEntity(
      snap.data['first_name'],
      snap.data['last_name'],
      snap.data['age'],
      snap.documentID,
    );
  }

  ///Firestore will automatically create the id for the document when we insert it
  Map<String, Object> toDocument() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "age": age,
    };
  }

}
