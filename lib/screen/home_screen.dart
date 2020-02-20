import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/bloc_layer/authentication_bloc/bloc.dart';
import 'package:demo_ican/data_layer/model/user.dart';
import 'package:demo_ican/screen/recipes_List_screen.dart';
import 'package:demo_ican/screen/user_profile.dart';
import 'package:demo_ican/screen/video_screen.dart';
import 'package:demo_ican/screen/leacture_view.dart';
import 'package:demo_ican/ui_layer/add_user/add_user_form.dart';
import 'package:demo_ican/ui_layer/chat/chat_screen.dart';
import 'package:demo_ican/ui_layer/chat/detail_screen.dart';
import 'package:demo_ican/ui_layer/ibm/show_ibm.dart';
import 'package:demo_ican/ui_layer/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String email;

  HomeScreen({Key key, @required this.email}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  String name2 = '';

  String phone = "";

  int age = 0;

  String location = "";

  double height = 0;

  double weight = 0;

  User user;

  BuildContext context2;

  Firestore firestore = Firestore.instance;
  dynamic data;
  final StorageReference storageReference = FirebaseStorage().ref().child("");
  final reference = Firestore.instance.collection("notify");
  Stream<QuerySnapshot> get query => reference.snapshots();
  final reference2 = Firestore.instance.collection("image");
  Stream<QuerySnapshot> get query2 => reference2.snapshots();
  @override
  void initState() {
    super.initState();
    initUser();
    registerNotification();
  }

  void sendTokenToServer(String fcmToken) {
//    print('token: $fcmToken');
  }

  void registerNotification() {
    firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    firebaseMessaging.getToken();
    firebaseMessaging.subscribeToTopic('all');
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          print("onMessage: $message");
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
// Find the Scaffold in the widget tree and use it to show a SnackBar.
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          print("onLaunch: $message");
        });
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          print("onResume: $message");
        });
      },
    );
  }

  initUser() async {
    print("start");
    print("call firestore");
    await firestore
        .collection("info")
        .document(widget.email)
        .get()
        .then((DocumentSnapshot ds) {
      name2 = ds.data['name'];
      age = ds.data['age'];
      location = ds.data['location'];
      height = ds.data['height'];
      phone = ds.data['phone_number'];
      weight = ds.data['weight'];
    }).catchError((err) async {
//      print(err);
      user = new User(name2, age, phone, weight, height, location,
          email: widget.email);
      print(err.toString());
      data = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return AddUser(
            user: user,
          );
        }),
      );

//      setState(() {
//        user=data['user'];
//      });
    });
//    if (data['user'] == null)

    print(data.toString());
    try {
      print(data['user']);
      user = data['user'];
    } catch (e) {
      print(e);
      user = new User(name2, age, phone, weight, height, location,
          email: widget.email);
    }
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
                        return UserProfile(user);
//                        return PopImage();
                      }),
                    );
                  },
                  title: Text(
                    AppLocalizations.of(context).tr("user_profile"),
                    style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  leading: Icon(
                    Icons.person,
                    color: Colors.white,
                  )),
              ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return ChatScreen2(
                          user: user,
                        );
                      }),
                    );
                  },
                  title: Text(
                    AppLocalizations.of(context).tr("chat"),
                    style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  leading: Icon(
                    Icons.chat,
                    color: Colors.white,
                  )),
              Divider(
                thickness: 1,
                color: Colors.white,
              ),
              ListTile(
                  onTap: () {
                    if (data.locale.toString().compareTo("ar_DZ") == 0)
                      data.changeLocale(Locale('en', 'US'));
                    else
                      data.changeLocale(Locale('ar', 'DZ'));
                  },
                  title: Text(
                      AppLocalizations.of(context).tr("change_language"),
                      style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
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
  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');
    await prefs.setInt('counter', counter);
  }


  @override
  Widget build(BuildContext context) {
    context2 = context;
    _incrementCounter();
//    initUser();
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        drawer: sideBar(context, data),
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            AppLocalizations.of(context).tr("title"),
            style: GoogleFonts.cairo(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
          ),
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
//            FutureBuilder(
//              future: getNotify(),
//              builder: (context, snapshot) {
//                if (snapshot.connectionState == ConnectionState.waiting)
//                  return Padding(
//                    padding: const EdgeInsets.all(20.0),
//                    child: Container(
//                      child: Card(
//                        child: Center(child: CircularProgressIndicator()),
//                      ),
//                    ),
//                  );
//                if (snapshot.connectionState == ConnectionState.done)
//                  return ListView.builder(
//                      scrollDirection: Axis.vertical,
//                      shrinkWrap: true,
//                      physics: ClampingScrollPhysics(),
//                      itemCount: snapshot.data.length,
//                      itemBuilder: (_, index) {
//                        return Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child:
//                          Card(
//                              color: Colors.amber,
//                              child: Padding(
//                                padding: const EdgeInsets.all(20.0),
//                                child: Center(
//                                    child: Text(
//                                  snapshot.data[index].data['note'],
//                                  style: GoogleFonts.cairo(
//                                      color: Colors.white,
//                                      fontWeight: FontWeight.w700,
//                                      fontSize: 20),
//                                )),
//                              )),
//                        );
//                      });
//                return Container();
//              },
//            ),
            ///
            ///
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: new FirestoreAnimatedList(
                errorChild: Card(
                    color: Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                          child: Text(
                        "no notification",
                        style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 1.2 * SizeConfig.textMultiplier),
                      )),
                    )),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                query: query,
                itemBuilder: (
                  BuildContext context,
                  DocumentSnapshot snapshot,
                  Animation<double> animation,
                  int index,
                ) =>
                    FadeTransition(
                  opacity: animation,
                  child: Card(
                      color: Colors.amber,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                            child: Text(
                          snapshot.data['note'],
                          style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 1.2 * SizeConfig.textMultiplier),
                        )),
                      )),
//                        Text(
//                           snapshot.data['note'],
//                        ),
                ),
              ),
            ),

            ///
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

                if (snapshot.connectionState == ConnectionState.done) {
                  print(snapshot.data.length);
                  return CarouselSlider.builder(
//                    scrollPhysics: ClampingScrollPhysics(),
                    height: 1 * SizeConfig.heightMultiplier,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int itemIndex) =>
                        Container(
                            child:
//                              Image.network(
//                                  snapshot.data[itemIndex].data['url'])
                                GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return DetailScreen(
                            url: snapshot.data[itemIndex].data['url'],
                          );
                        }));
                      },
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data[itemIndex].data['url'],
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )),
//                    CachedNetworkImage(
//                      imageUrl: snapshot.data[itemIndex].data['url'],
//                      placeholder: (context, url) => CircularProgressIndicator(),
//                      errorWidget: (context, url, error) => Icon(Icons.error),
//                    ),
                  );
                }
                return Container();
              },
            ),

            ///

//            Flexible(
//              child: Padding(
//                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                child: new FirestoreAnimatedList(
////                  shrinkWrap: true,
////                  physics: ClampingScrollPhysics(),
////                  scrollDirection:Axis.horizontal,
//                  query: query2,
//                  itemBuilder: (
//                      BuildContext context,
//                      DocumentSnapshot snapshot,
//                      Animation<double> animation,
//                      int index,
//                      ) =>
//                            Container(
//                                child: CachedNetworkImage(
//                                  imageUrl:
//                                    snapshot.data['url'],
//                                )
//                            ),
////                    CachedNetworkImage(
////                      imageUrl: snapshot.data[itemIndex].data['url'],
////                      placeholder: (context, url) => CircularProgressIndicator(),
////                      errorWidget: (context, url, error) => Icon(Icons.error),
////                    ),
//                ),
//              ),
//            ),
            ///
            Expanded(
                child: StaggeredGridView.count(
              physics: ClampingScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: <Widget>[
                MyItem(Icons.insert_chart,
                    AppLocalizations.of(context).tr("add_BMI"), 1),
                MyItem(
                    Icons.web, AppLocalizations.of(context).tr("lecture"), 2),
                MyItem(Icons.web,
                    AppLocalizations.of(context).tr("Healthy_recipes"), 3),
                MyItem(Icons.video_library,
                    AppLocalizations.of(context).tr("videos"), 4),
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 60),
                StaggeredTile.extent(1, 60),
                StaggeredTile.extent(1, 60),
                StaggeredTile.extent(2, 60),
              ],
            )
//            DashBord()
                ),
          ],
        ),
      ),
    );
  }

//  Future getNotify() async {
//    print("in Notify");
//    QuerySnapshot qn = await firestore.collection("notify").getDocuments();
//    return qn.documents;
//  }

  Future getImage() async {
//    print("in Image");
    QuerySnapshot qn = await firestore.collection("image").getDocuments();
    return qn.documents;
  }

  Material MyItem(IconData icon, String string, int index) {
    return Material(
        child: InkWell(
            child: Card(
                color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      icon,
                      color: Colors.purple,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      string,
                      style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 1 * SizeConfig.textMultiplier),
                    ),
                  ],
                )),
            onTap: () {
              _onPressed(index);
            }));
  }

  void _onPressed(int position) {
    if (position == 1) {
      Navigator.of(context2).push(
        MaterialPageRoute(builder: (context) {
//          return ChartScreen();
          return ShowIBM(
            user: user,
          );
        }),
      );
    } else if (position == 2) {
      Navigator.of(context2).push(
        MaterialPageRoute(builder: (context) {
          return LectureList();
        }),
      );
    } else if (position == 3) {
      Navigator.of(context2).push(
        MaterialPageRoute(builder: (context) {
          return RecipesList();
        }),
      );
    } else if (position == 4) {
      Navigator.of(context2).push(
        MaterialPageRoute(builder: (context) {
          return VideoList();
        }),
      );
    }
  }
}
