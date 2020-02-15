import 'package:demo_ican/bloc_layer/authentication_bloc/authentication_bloc.dart';
import 'package:demo_ican/bloc_layer/authentication_bloc/authentication_event.dart';
import 'package:demo_ican/bloc_layer/login/bloc.dart';
import 'package:demo_ican/bloc_layer/login/login_bloc.dart';
import 'package:demo_ican/bloc_layer/login/login_state.dart';
import 'package:demo_ican/data_layer/user_repository.dart';
import 'package:demo_ican/ui_layer/register/create_account_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'google_login_button.dart';
import 'login_button.dart';

//LoginForm widget is a StatefulWidget because it needs
// to maintain it's own TextEditingControllers for the email and password input.
class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  /*We use a BlocListener widget in order to execute one-time actions
   in response to state changes. In this case, we are showing different
   SnackBar widgets in response to a pending/failure state. In addition,
   if the submission is successful, we use the listener method to notify
   the AuthenticationBloc that the user has successfully logged in.*/

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(AppLocalizations.of(context).tr("login_failure")), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).tr("logging_in")),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      //We use a BlocBuilder widget in order to rebuild
      // the UI in response to different LoginStates.
      // Whenever the email or password changes, we add an event to
      // the LoginBloc in order for it to validate the current form state
      // and return the new form state.
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset('assets/image001.jpg', height: 200),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: AppLocalizations.of(context).tr("email"),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid ? AppLocalizations.of(context).tr("invalid_email") : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: AppLocalizations.of(context).tr("password"),
                    ),
                    obscureText: true,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid ? AppLocalizations.of(context).tr("invalid_password") : null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LoginButton(
                          onPressed: isLoginButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,
                        ),
                        GoogleLoginButton(),
                        CreateAccountButton(userRepository: _userRepository),
                        FlatButton(
                          onPressed:state.isEmailValid? () async {
                            await _userRepository
                                .resetPassword(_emailController.text).catchError((err)=>print(err));
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content:
                                  Text(AppLocalizations.of(context).tr("reset_email_message")),

                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                            );
                          }:null,
                          child: Tooltip(
                          message: AppLocalizations.of(context).tr("tooltip_forget_password")    ,
                          waitDuration: Duration(microseconds: 1),
                          child: Text(AppLocalizations.of(context).tr("forgot_password"))),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
