import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/data_layer/send_notification/messaging.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();
  int index;
  final _formKey = GlobalKey<FormState>();
  final Firestore _firestore = Firestore.instance;
  String note="";
  String title="";

  @override
  void initState() {
    // TODO: implement initState
    registerNotification();
    super.initState();
  }
  void sendTokenToServer(String fcmToken) {
    print('token: $fcmToken');
  }

  void sendNotification(String title,String body) async {
    await Messaging.sendToAll(title: title, body: body);
  }

  void registerNotification() {

    firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    firebaseMessaging.getToken();
    firebaseMessaging.subscribeToTopic('all');
    print("in initial");
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        final notification = message['notification'];
        setState(() {
          print("hal hal hal:   "+ notification['body']);
          print("onMessage: $message");
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          print("onLaunch: $message");
        });

        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          print("onResume: $message");
        });

        // TODO optional
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).tr("note"),style: GoogleFonts.cairo(),),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: note,
                  decoration: InputDecoration(
                    icon: Icon(Icons.title),
                    labelText: AppLocalizations.of(context).tr("note_title"),
                    border: new OutlineInputBorder(
                        borderSide:
                        new BorderSide(color: Colors.amberAccent)),
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return AppLocalizations.of(context).tr("empty_input");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    print(value);
                    title = value.trim();
                  },
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: note,
                  decoration: InputDecoration(
                    icon: Icon(Icons.note),
                    labelText: AppLocalizations.of(context).tr("note"),
                    border: new OutlineInputBorder(
                        borderSide:
                        new BorderSide(color: Colors.amberAccent)),
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return AppLocalizations.of(context).tr("empty_input");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    print(value);
                    note = value.trim();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Row(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).tr("update"),
                          style: GoogleFonts.cairo(color: Colors.white),
                        ),
                      ],
                    ),
                    color: Colors.deepPurple,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        index = 0;
                        add();
                        setState(() {});
                      }
                    },
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  add() async {
//    print(widget.user.email);
//    print("date: " + date.substring(0, 10));
    await _firestore
        .collection("notify")
        .document("event")
        .setData({"note": note}).catchError((err){
      Fluttertoast.showToast(msg: "error");
    });
    Fluttertoast.showToast(msg: "updated");
    sendNotification( title, note);
  }
}
