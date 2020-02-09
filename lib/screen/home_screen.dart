import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/bloc_layer/authentication_bloc/bloc.dart';
import 'package:demo_ican/data_layer/model/user.dart';
import 'package:demo_ican/screen/recipes_List_screen.dart';
import 'package:demo_ican/screen/user_profile.dart';
import 'package:demo_ican/screen/video_screen.dart';
import 'package:demo_ican/screen/leacture_view.dart';
import 'package:demo_ican/ui_layer/ibm/show_ibm.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final StorageReference storageReference = FirebaseStorage().ref().child("");
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

  Drawer sideBar(BuildContext context, var data) {
    return Drawer(
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
                    AppLocalizations.of(context).tr("user_profile"),
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
                    AppLocalizations.of(context).tr("add_BMI"),
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
                    AppLocalizations.of(context).tr("videos"),
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
                        return LectureList();
                      }),
                    );
                  },
                  title: Text(
                    AppLocalizations.of(context).tr("lecture"),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return RecipesList();
                      }),
                    );
                  },
                  title: Text(
                    AppLocalizations.of(context).tr("Healthy_recipes"),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    print("1");

    initUser();
    print("2");

    getDate();
    print("3");
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        drawer: sideBar(context, data),
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
          children: <Widget>[
            FutureBuilder(
              future: getNotify(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Card(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  );

                if (snapshot.connectionState == ConnectionState.done)
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              color: Colors.amber,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                    child: Text(
                                        snapshot.data[index].data['note'])),
                              )),
                        );
                      });
                return Container();
              },
            ),
            FutureBuilder(
              future: getImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Card(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  );

                if (snapshot.connectionState == ConnectionState.done)
                  return CarouselSlider.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int itemIndex) =>
                        Container(
                          child:
                          Image.network(
                                  snapshot.data[itemIndex].data['url'])),

                  );

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  getDate() async {
    print("in");
    QuerySnapshot querySnapshot =
        await firestore.collection("notify").getDocuments();
    querySnapshot.documents.forEach((f) {
      print("add");
      print(f.documentID);
    });
  }

  Future getNotify() async {
    QuerySnapshot qn = await firestore.collection("notify").getDocuments();
    return qn.documents;
  }

  Future getImage() async {
    QuerySnapshot qn = await firestore.collection("image").getDocuments();
    return qn.documents;
  }
}
