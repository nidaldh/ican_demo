import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/data_layer/model/user.dart';
import 'package:demo_ican/screen/user_profile.dart';
import 'package:demo_ican/ui_layer/ibm/show_ibm.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void settingModalBottomSheet(context, DocumentSnapshot snapshot) {
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
                  title: new Text(AppLocalizations.of(context).tr("user_profile")),
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return UserProfile(user);
                      }),
                    )
                  }),
              new ListTile(
                leading: new Icon(Icons.insert_chart),
                title: new Text(AppLocalizations.of(context).tr("add_BMI")),
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