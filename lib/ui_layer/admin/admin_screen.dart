import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/data_layer/model/user.dart';
import 'package:demo_ican/screen/user_profile.dart';
import 'package:demo_ican/ui_layer/admin/search_screen.dart';
import 'package:demo_ican/ui_layer/admin/bottom_sheet.dart';
import 'package:demo_ican/ui_layer/ibm/show_ibm.dart';
import 'package:easy_localization/easy_localization.dart';
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
          AppLocalizations.of(context).tr("users_list"),
          style: GoogleFonts.cairo(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        actions: <Widget>[
          Tooltip(
            message:AppLocalizations.of(context).tr("search"),
            child: FlatButton.icon(onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return SearchScreen();
                }),
              );
            }, icon: Icon(Icons.search,color: Colors.white,),
                label: Text(""),)
            ),

        ],
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
              settingModalBottomSheet(context, snapshot);
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


}
