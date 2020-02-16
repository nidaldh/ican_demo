import 'package:demo_ican/screen/home_screen.dart';
import 'package:demo_ican/screen/splash_screen.dart';
import 'package:demo_ican/screen/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bloc_layer/authentication_bloc/bloc.dart';
import 'bloc_layer/simple_bloc_delegate.dart';
import 'data_layer/user_repository.dart';

void main() {
  //is required in Flutter v1.9.4+ before using any plugins if the code is executed before runApp.
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();

  runApp(
    BlocProvider(
      create: (context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
      child: EasyLocalization(child: App(userRepository: userRepository)),
    ),
  );
}

///We are using BlocBuilder in order to render UI based on
/// the AuthenticationBloc state.
class App extends StatefulWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {

    print(widget._userRepository.getUser().toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: MaterialApp(
//        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
//          EasylocaLizationDelegate(locale: data.locale, path: 'assets/language')
          EasyLocalizationDelegate(locale: data.locale, path: 'assets/language')
        ],
        supportedLocales: [Locale('en', 'US'), Locale('ar', 'DZ')],
        locale: data.locale,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState> (
          builder: (context, state) {
            if (state is Uninitialized) {
              return SplashScreen();
            }
            if (state is Authenticated) {
                return HomeScreen(email: state.displayName);
//                return HomePage();
            }
            return LoginScreen(userRepository: widget._userRepository);
          },
        ),
      ),
    );
  }

}
