import 'package:demo_ican/data_layer/model/user.dart';
import 'package:demo_ican/screen/user_profile.dart';
import 'package:demo_ican/ui_layer/admin/admin_screen.dart';
import 'package:demo_ican/ui_layer/chat/chat_screen.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Drawer sideBar(BuildContext context, var data,User user,bool admin) {
  return Drawer(
    child: Container(
      color: Colors.deepPurpleAccent,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            admin? ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return AdminScreen();
                    }),
                  );
                },
                title: Text(
                  AppLocalizations.of(context).tr("admin"),
                  style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                leading: Icon(
                  MdiIcons.head,
                  color: Colors.white,
                )):Container(),
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
                      return ChatScreen(
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

Widget admin(BuildContext context,User user){
  return ListTile(
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
      ));
}
