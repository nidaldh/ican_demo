import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/data_layer/model/user.dart';
import 'package:demo_ican/screen/user_profile.dart';
import 'package:demo_ican/ui_layer/ibm/show_ibm.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../size_config.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final reference = Firestore.instance.collection("info");
  Stream<QuerySnapshot> get query => reference.snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "المستخدمين",
          style: GoogleFonts.cairo(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: FirestoreAnimatedList(
        errorChild: Card(
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                  child: Text(
                "no accounts",
                style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 1.2 * SizeConfig.textMultiplier),
              )),
            )),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        query: query,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        itemBuilder: (
          BuildContext context,
          DocumentSnapshot snapshot,
          Animation<double> animation,
          int index,
        ) =>
            FadeTransition(
          opacity: animation,
          child: InkWell(
            onTap: () {
              _settingModalBottomSheet(context, snapshot);
            },
            child: Card(
                color: Colors.amber,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                      child: Text(
                    snapshot.data['name'],
                    style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 1.2 * SizeConfig.textMultiplier),
                  )),
                )),
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context, DocumentSnapshot snapshot) {
    User user;
    try {
      user = User(
        snapshot.data['name'],
        snapshot.data['age'],
        snapshot.data['phone_number'],
        snapshot.data['weight'],
        snapshot.data['height'],
        snapshot.data['location'],
        email: snapshot.documentID,
      );
    } catch (e) {
      print(e);
    }
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(user.name,
                        style: GoogleFonts.cairo(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 20)),
                  ],
                ),
                Divider(
                  height: 1,
                  color: Colors.black12,
                  thickness: 1,
                ),
                new ListTile(
                    leading: new Icon(Icons.person),
                    title: new Text('profile'),
                    onTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return UserProfile(user);
                            }),
                          )
                        }),
                new ListTile(
                  leading: new Icon(Icons.insert_chart),
                  title: new Text('IBM'),
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return ShowIBM(
                          user: user,
                        );
                      }),
                    )
                  },
                ),
              ],
            ),
          );
        });
  }
}
