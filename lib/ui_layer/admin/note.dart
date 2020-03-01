import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  int index;
  final _formKey = GlobalKey<FormState>();
  final Firestore _firestore = Firestore.instance;
  String note="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("note"),),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: note,
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  labelText: AppLocalizations.of(context).tr("note"),
                  hintText:
                  AppLocalizations.of(context).tr("note_hint"),
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
                        AppLocalizations.of(context).tr("push"),
                        style: GoogleFonts.cairo(color: Colors.white),
                      ),
//                            Icon(Icons.person)
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
  }
}
