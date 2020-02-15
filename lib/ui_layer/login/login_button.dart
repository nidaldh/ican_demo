import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
//just a StatelessWidget which has some styling and an onPressed
// callback so that we can have a custom VoidCallback whenever the button is pressed.
class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: _onPressed,
      child: Text( AppLocalizations.of(context).tr("login")),
    );
  }
}
