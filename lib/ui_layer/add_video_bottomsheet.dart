import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

///todo: add form to the bottom sheet and upload new video and remove videos
void addVideoBottomSheet(context, Firestore snapshot) {
  final _formKey = GlobalKey<FormState>();
  final Firestore _firestore = Firestore.instance;
  String note = "";
  String id = "";
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: note,
                    decoration: InputDecoration(
                      icon: Icon(Icons.note),
                      labelText: AppLocalizations.of(context).tr("video title"),
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
//                        print(value);
                      note = value.trim();
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
//                  initialValue: note,
                    decoration: InputDecoration(
                      icon: Icon(Icons.note),
                      labelText: AppLocalizations.of(context).tr("video_id"),
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
                      value = YoutubePlayer.convertUrlToId(value);
                      id = value;
                      print(id);
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
                          await _firestore
                              .collection("videos")
                              .document(note)
                              .setData({"id": id}).catchError((err) {
                            Fluttertoast.showToast(msg: "error");
                          });
                          Fluttertoast.showToast(msg: "updated");
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}
