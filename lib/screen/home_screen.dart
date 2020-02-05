import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/bloc_layer/authentication_bloc/bloc.dart';
import 'package:demo_ican/data_layer/user.dart';
import 'package:demo_ican/screen/user_profile.dart';
import 'package:demo_ican/temp_chart.dart';
import 'package:demo_ican/ui_layer/ibm/show_ibm.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final String email;
  String name2 = '';
  String phone = "";
  int age;
  String location;
  double height;
  double weight;
  User user;
  HomeScreen({Key key, @required this.email}) : super(key: key);
  Firestore firestore = Firestore.instance;

  initUser()async{
    await firestore
        .collection("info")
        .document(email)
        .get()
        .then((DocumentSnapshot ds) {
      // use ds as a snapshot
//     ds.data[''];
//      print(ds.data['height']);
      name2 = ds.data['name'];
      age = ds.data['age'];
      location = ds.data['location'];
      height = ds.data['height'];
      phone = ds.data['phone_number'];
      weight = ds.data['weight'];
    });
  user = new User(name2, age, phone, weight, height, location,email: email);
  print(user.name);
  }

  @override
  Widget build(BuildContext context) {
    initUser();
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            color: Colors.deepPurpleAccent,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
//                            return AddUser(
//                              email: name,
//                            );
                          return UserProfile(user);
                          }),
                        );
                      },
                      title: Text(
                        "Add Info",
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.add,
                        color: Colors.white,
                      )),
                  ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return ShowIBM(user: user,
                            );
                          }),
                        );
                      },
                      title: Text(
                        "Add IBM",
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.add,
                        color: Colors.white,
                      )),ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return LineChartSample7();
                          }),
                        );
                      },
                      title: Text(
                        "chart of IBM",
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.add,
                        color: Colors.white,
                      )),
                  ListTile(
                      onTap: () {
                        if (data.savedLocale.toString().compareTo("ar_DZ") == 0)
                          data.changeLocale(Locale('en', 'US'));
                        else
                          data.changeLocale(Locale('ar', 'DZ'));
                      },
                      title: Text(
                        AppLocalizations.of(context).tr("clickMe"),
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.language,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ),
        ),
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
            Center(
                child: Text(AppLocalizations.of(context)
                    .tr("msg", args: [email, 'flutter']))),
          ],
        ),
      ),
    );
  }
}
