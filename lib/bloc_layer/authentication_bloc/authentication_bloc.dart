import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:demo_ican/data_layer/user_repository.dart';
import 'package:meta/meta.dart';

import 'bloc.dart';


/// we can get to work on implementing the AuthenticationBloc which is going to
/// manage checking and updating a user's AuthenticationState in response to
/// AuthenticationEvents.

///this bloc is going to be converting
///AuthenticationEvents into AuthenticationStates.
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  //Our AuthenticationBloc has a dependency on the UserRepository
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  ///Now all that’s left is to implement mapEventToState.
  ///We are using yield* (yield-each) in mapEventToState to separate the event
  ///handlers into their own functions. yield* inserts all the elements of
  ///the subsequence into the sequence currently being constructed,
  ///as if we had an individual yield for each element.
  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  /// We created separate private helper functions to convert each
  /// AuthenticationEvent into the proper AuthenticationState in
  /// order to keep mapEventToState clean and easy to read.

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final name = await _userRepository.getUser();
        yield Authenticated(name);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(await _userRepository.getUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }


}
