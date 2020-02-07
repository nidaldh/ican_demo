import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/bloc_layer/authentication_bloc/bloc.dart';
import 'package:demo_ican/data_layer/user.dart';
import 'package:demo_ican/screen/user_profile.dart';
import 'package:demo_ican/screen/video_screen.dart';
import 'package:demo_ican/screen/web_view.dart';
import 'package:demo_ican/temp_chart.dart';
import 'package:demo_ican/ui_layer/ibm/show_ibm.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final String email;
  String name2 = '';
  String phone = "";
  int age = 0;
  String location = "";
  double height = 0;
  double weight = 0;
  User user;
  HomeScreen({Key key, @required this.email}) : super(key: key);
  Firestore firestore = Firestore.instance;

  initUser() async {
    print("start");
    print("call firestore");
    await firestore
        .collection("info")
        .document(email)
        .get()
        .then((DocumentSnapshot ds) {
      name2 = ds.data['name'];
      age = ds.data['age'];
      location = ds.data['location'];
      height = ds.data['height'];
      phone = ds.data['phone_number'];
      weight = ds.data['weight'];
    }).catchError((err) => print(err.toString()));

    user = new User(name2, age, phone, weight, height, location, email: email);
//  print(user.name);
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
                        AppLocalizations.of(context)
                            .tr("user_profile"),
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.person,
                        color: Colors.white,
                      )),
                  Divider(
                    thickness: 1,
                    color: Colors.white,
                  ),
                  ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            print(user);
                            return ShowIBM(
                              user: user,
                            );
                          }),
                        );
                      },
                      title: Text(
                        AppLocalizations.of(context)
                            .tr("add_BMI"),
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.add,
                        color: Colors.white,
                      )),
                  Divider(
                    thickness: 1,
                    color: Colors.white,
                  ),
                  ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return LineChartSample7();
                          }),
                        );
                      },
                      title: Text(
                        AppLocalizations.of(context)
                            .tr("BMI_chart"),
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.insert_chart,
                        color: Colors.white,
                      )),
                  Divider(
                    thickness: 1,
                    color: Colors.white,
                  ),
                  ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return VideoList();
                          }),
                        );
                      },
                      title: Text(
                        AppLocalizations.of(context)
                            .tr("videos"),
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.video_label,
                        color: Colors.white,
                      )),
                  Divider(
                    thickness: 1,
                    color: Colors.white,
                  ),
                  ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return WebViewList();
                          }),
                        );
                      },
                      title: Text(
                        AppLocalizations.of(context)
                            .tr("lecture"),
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.web,
                        color: Colors.white,
                      )),
                  Divider(
                    thickness: 1,
                    color: Colors.white,
                  ),
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
          backgroundColor: Colors.deepPurple,
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
