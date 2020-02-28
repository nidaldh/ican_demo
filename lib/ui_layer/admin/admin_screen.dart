import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/data_layer/model/user.dart';
import 'package:demo_ican/screen/user_profile.dart';
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
      appBar: AppBar(),
      body: FirestoreAnimatedList(
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
              User user;
              try{
               user = User(
                  snapshot.data['name'],
                  snapshot.data['age'],
                  snapshot.data['phone_number'],
                  snapshot.data['weight'],
                  snapshot.data['height'],
                  snapshot.data['location'],email: snapshot.documentID,);}
                  catch (e){
                print(e);
                  }
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return UserProfile(user);
//                        return PopImage();
                }),
              );
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
//                        Text(
//                           snapshot.data['note'],
//                        ),
        ),
      ),
    );
  }
}
