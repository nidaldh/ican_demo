import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthenticationState {
  final String displayName;
  // Since we’re using Equatable to allow us to compare different instances of
  // AuthenticationState we need to pass any properties to the superclass.
  // Without super([displayName]), we will not be able to properly compare
  // different instances of Authenticated.
  Authenticated(this.displayName);

  @override
  String toString() => 'Authenticated { displayName: $displayName }';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}
