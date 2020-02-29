
import 'package:demo_ican/screen/home_screen.dart';
import 'package:demo_ican/screen/splash_screen.dart';
import 'package:demo_ican/ui_layer/admin/admin_screen.dart';
import 'package:demo_ican/ui_layer/login/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bloc_layer/authentication_bloc/bloc.dart';
import 'bloc_layer/simple_bloc_delegate.dart';
import 'data_layer/user_repository.dart';
import 'ui_layer/size_config.dart';

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
//     MyApp()
  );
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple,
    );
  }
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
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);

          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.amber,
              primaryColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              EasyLocalizationDelegate(
                  locale: data.locale, path: 'assets/language')
            ],
            supportedLocales: [Locale('en', 'US'), Locale('ar', 'DZ')],
            locale: data.locale,
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is Uninitialized) {
                  return SplashScreen();
                }
                if (state is Authenticated) {
                  return HomeScreen(email: state.displayName);
//                  return AdminScreen();
//                return HomePage();
                }
                return LoginScreen(userRepository: widget._userRepository);
              },
            ),
          );
        });
      }),
    );
  }

}



///Firebase functions
///
//
//import 'package:flutter/material.dart';
//import 'package:cloud_functions/cloud_functions.dart';
//
//void main() => runApp(Phone());
//
//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  String _response = 'no response';
//  int _responseCount = 0;
//
//  @override
//  Widget build(BuildContext context) {
//    final HttpsCallable callable = CloudFunctions.instance
//        .getHttpsCallable(functionName: 'repeat')
//      ..timeout = const Duration(seconds: 30);
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: const Text('Cloud Functions example app'),
//        ),
//        body: Center(
//          child: Container(
//            margin: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
//            child: Column(
//              children: <Widget>[
//                Text('Response $_responseCount: $_response'),
//                MaterialButton(
//                  child: const Text('SEND REQUEST'),
//                  onPressed: () async {
//                    try {
//                      final HttpsCallableResult result = await callable.call(
//                        <String, dynamic>{
//                          'message': 'hello world!',
//                          'count': _responseCount,
//                        },
//                      );
//                      print(result.data);
//                      setState(() {
//                        _response = result.data['repeat_message'];
//                        _responseCount = result.data['repeat_count'];
//                      });
//                    } on CloudFunctionsException catch (e) {
//                      print('caught firebase functions exception');
//                      print(e.code);
//                      print(e.message);
//                      print(e.details);
//                    } catch (e) {
//                      print('caught generic exception');
//                      print(e);
//                    }
//                  },
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}