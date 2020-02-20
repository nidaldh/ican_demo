import 'package:demo_ican/data_layer/model/user.dart';
import 'package:demo_ican/ui_layer/add_user/add_user_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatefulWidget {
  User user;
  UserProfile(this.user);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final f = new NumberFormat("###.00");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(AppLocalizations.of(context).tr("user_profile"),
            style: GoogleFonts.cairo(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
        actions: <Widget>[
          Tooltip(
            waitDuration: Duration(microseconds: 1),
            showDuration: Duration(seconds: 2),
            message: AppLocalizations.of(context).tr("edit_info"),
            child: IconButton(
              icon: Icon(Icons.update),
              onPressed: () async {
                dynamic date = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return AddUser(
                          user: this.widget.user,
                        ) ??
                        "nothing";
                  }),
                );
//                print(date);
//                setState(() {
//                  print(date['user']);
//                });
                print("weight " + widget.user.height.toString());
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(

          children: <Widget>[
            Expanded(
                child: StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 5,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: <Widget>[
                ProfileHead(Icons.perm_identity, widget.user.name),
                MyItem(Icons.phone, widget.user.phoneNumber),
                MyItem(Icons.alternate_email, widget.user.email),
                MyItem(Icons.location_on, widget.user.location),
                WLItem("kg", f.format(widget.user.weight)),
                WLItem("cm", f.format(widget.user.height)),
                StarItem(f.format(widget.user.weight * .95)),
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 140),
                StaggeredTile.extent(2, 60),
                StaggeredTile.extent(2, 60),
                StaggeredTile.extent(2, 60),
                StaggeredTile.extent(1, 60),
                StaggeredTile.extent(1, 60),
                StaggeredTile.extent(3, 60),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Material WLItem(String type, String value) {
    return Material(
        child: Card(
            color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).tr(type),
                  style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  value,
                  style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20),
                ),
              ],
            )));
  }

  Material StarItem(String value) {
    return Material(
        child: InkWell(
      child: Card(
          color: Colors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
          AppLocalizations.of(context).tr("goal"),
                style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18),
              ),

              SizedBox(
                width: 10,
              ),
              Text(
                value,
                style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              SizedBox(
                width: 10,
              ),Text(
                AppLocalizations.of(context).tr("kg"),
                style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              Icon(
                Icons.star,
                color: Colors.purple,
              ),
            ],
          )),
    ));
  }

  Material MyItem(IconData icon, String string) {
    return Material(
        child: Card(
            color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).tr(string),
                  style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  icon,
                  color: Colors.purple,
                ),
              ],
            )));
  }

  Material ProfileHead(IconData icon, String string) {
    return Material(
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//          Icon(icon,color: Colors.white,),
            Center(
              child: Text(
                string,
                style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 30),
              ),
            ),
          ],
        ),
        color: Colors.purple,
      ),
    );
  }
}
