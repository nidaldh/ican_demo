import 'package:demo_ican/data_layer/InfoEntity.dart';

class Info{
  final String id;
  final String firstName;
  final String lastName;
  final int age;

  Info(this.id, this.firstName, this.lastName, this.age);

  Info copyWith({String id ,String firstName, String lastName, int age}){
    return Info(
      id ?? this.id,
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      age ?? this.age
    );
  }

  @override
  int get hashCode =>
      firstName.hashCode ^ lastName.hashCode ^ age.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Info &&
              runtimeType == other.runtimeType &&
              firstName == other.firstName &&
              lastName == other.lastName &&
              age == other.age &&
              id == other.id;



  InfoEntity toEntity() {
    return InfoEntity(firstName, lastName, age, id);
  }


  static Info fromEntity(InfoEntity entity) {
    return Info(
      entity.id,
      entity.firstName,entity.lastName,entity.age
    );
  }



}