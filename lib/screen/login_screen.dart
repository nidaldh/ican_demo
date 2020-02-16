
import 'package:demo_ican/bloc_layer/login/bloc.dart';
import 'package:demo_ican/data_layer/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ui_layer/login/login_form.dart';

/*we are extending StatelessWidget and using a BlocProvider to initialize
 and close the LoginBloc as well as to make the LoginBloc instance available
 to all widgets within the sub-tree.*/

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).tr("login")),
            backgroundColor: Colors.amber,
        actions: <Widget>[
          OutlineButton(
            onPressed: () {
              print(data.locale);
              if(data.locale.toString().compareTo("ar_DZ") ==0)
              data.changeLocale(Locale('en', 'US'));
              if(data.locale.toString().compareTo("en_US") ==0)
              data.changeLocale(Locale('ar', 'DZ'));
            },
            child: Text(AppLocalizations.of(context).tr("change_language")),
          )
        ],),
        body: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(userRepository: _userRepository),
          child: LoginForm(userRepository: _userRepository),
        ),
      ),
    );
  }


  void changeLanguage(){

  }

}
