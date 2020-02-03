import 'package:demo_ican/bloc_layer/authentication_bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(AppLocalizations.of(context).tr("title", args: ['title'])),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(
                  LoggedOut(),
                );
              },
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
//            Center(child: Text('Welcome $name!')),
            Center(
                child: Text(AppLocalizations.of(context)
                    .tr("msg", args: [name, 'flutter']))),
            Center(
                child: Text(AppLocalizations.of(context)
                    .plural("clicked","zero"))),
            OutlineButton(
              onPressed: () {
                data.changeLocale(Locale('ar', 'DZ'));
              },
              child: Text(AppLocalizations.of(context).tr("clickMe")),
            )
          ],
        ),
      ),
    );
  }
}
