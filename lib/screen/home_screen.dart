import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/bloc_layer/authentication_bloc/bloc.dart';
import 'package:demo_ican/ui_layer/add_user/add_user_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({Key key, @required this.name}) : super(key: key);
  Firestore firestore = Firestore.instance;
//  void check() async{
//    final snapShot = await Firestore.instance
//        .collection('info')
//        .document("NnrSxvBpmR8enb0XhM4F")
//        .get();
//
//    print(name);
////    if (snapShot == null || !snapShot.exists) {
////      // Document with id == docId doesn't exist.
////    }
//    print(snapShot == null || !snapShot.exists);
//  }

  @override
  Widget build(BuildContext context) {
//    check();
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
            ),
            OutlineButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return AddUser(email: name,);
                  }),
                );
              },
              child: Text("add Info"),
            )

          ],
        ),
      ),
    );
  }
}
