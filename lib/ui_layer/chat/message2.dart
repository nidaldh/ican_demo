import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'detail_screen.dart';

@override
class ChatMessage extends StatelessWidget {
  ChatMessage({this.snapshot, this.animation, this.me});
  final DocumentSnapshot snapshot;
  final Animation animation;
  bool me;
  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(AppLocalizations.of(context).tr("delete_message")
              ,style: TextStyle(color: Colors.redAccent)),
          content: new Text(AppLocalizations.of(context).tr("delete_alert_message")),
          actions: <Widget>[
            new FlatButton(
              child: new Text(AppLocalizations.of(context).tr("yes"),style: TextStyle(color: Colors.redAccent),),
              onPressed: () {
                Firestore.instance.collection("messages").document(snapshot.documentID).delete();
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(AppLocalizations.of(context).tr("no"),style: TextStyle(color: Colors.lightGreen),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: Bubble(
                color: me ? Colors.amberAccent : Colors.deepPurpleAccent,
                nip: me ? BubbleNip.rightBottom : BubbleNip.leftBottom,
                alignment: me ? Alignment.topRight : Alignment.topLeft,
                elevation: 6.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment:
                        me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: <Widget>[
                      if (!me)
                        new Text(snapshot.data['senderName'],
                            style: Theme.of(context).textTheme.subtitle1),
                      new Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: snapshot.data['imageUrl'] != null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child:
                                    GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return DetailScreen(
                                        url: snapshot.data['imageUrl'],
                                      );
                                    }));
                                  },
                                  child: CachedNetworkImage(
                                    width: 200,
                                    imageUrl: snapshot.data['imageUrl'],
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              )
                            : new Text(snapshot.data['text'],
                                style: GoogleFonts.cairo(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
              onDoubleTap: (){
                Fluttertoast.showToast(msg: snapshot.data['date']);
              },
              onLongPress: (){
                if(me)
                _showDialog(context);
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }


}

