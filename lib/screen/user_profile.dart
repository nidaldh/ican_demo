import 'package:demo_ican/data_layer/model/user.dart';
import 'package:demo_ican/ui_layer/add_user/add_user_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfile extends StatefulWidget {
  User user;
  UserProfile(this.user);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("profile"),
        actions: <Widget>[
          IconButton(
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
              print(date);
              setState(() {
                print(date['user']);
              });
              print("weight " + widget.user.height.toString());
            },
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
                ProfileHead(Icons.perm_identity,
                    AppLocalizations.of(context).tr("add_BMI")),
                MyItem(Icons.phone, widget.user.phoneNumber),
                MyItem(Icons.alternate_email,
                    widget.user.email),
                MyItem(Icons.location_on,
                    widget.user.location),
                WLItem("Kg",
                    widget.user.weight.toString()),
                WLItem("cm",
                    widget.user.height.toString()),
                MyItem(Icons.star, (widget.user.weight*.95).toString()+" kg"),
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
//            Center(child: Text(widget.user.name)),
//            Divider(
//              thickness: 3,
//              color: Colors.deepPurple,
//            ),
//            Text(widget.user.phoneNumber),
//            Divider(
//              thickness: 3,
//              color: Colors.deepPurple,
//            ),
//            Text(widget.user.email),
//            Divider(
//              thickness: 3,
//              color: Colors.deepPurple,
//            ),
//            Text(widget.user.location),
//            Divider(
//              thickness: 3,
//              color: Colors.deepPurple,
//            ),
//            Text(widget.user.weight.toString()),
//            Divider(
//              thickness: 3,
//              color: Colors.deepPurple,
//            ),
//            Text(widget.user.height.toString()),
//            Divider(
//              thickness: 3,
//              color: Colors.deepPurple,
//            ),
//            Text(widget.user.age.toString()),
//            Divider(
//              thickness: 3,
//              color: Colors.deepPurple,
//            ),
          ],
        ),
      ),
    );
  }
}
Material WLItem(String type,String value){
  return Material(
      child: InkWell(
        child: Card(
            color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(type,style:GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16) ,),
                SizedBox(
                  width: 10,
                ),
                Text(value,style:GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16) ,),
              ],
            )),
      ));
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
              "فداء ناجح",
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

Material MyItem(IconData icon, String string) {
  return Material(
      child: InkWell(
    child: Card(
        color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(string,style:GoogleFonts.cairo(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16) ,),
            SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              color: Colors.purple,
            ),
          ],
        )),
  ));
}
