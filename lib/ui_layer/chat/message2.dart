import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@override
class ChatMessage extends StatelessWidget {
  ChatMessage({this.snapshot, this.animation, this.me});
  final DocumentSnapshot snapshot;
  final Animation animation;
  bool me;

  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//            new Container(
//              margin: const EdgeInsets.only(right: 16.0),
//              child: new CircleAvatar(backgroundImage: new NetworkImage(snapshot.data['senderPhotoUrl'])),
//            ),
          Expanded(
            child: Tooltip(
              child: Bubble(
                color: me ? Colors.amberAccent : Colors.deepPurpleAccent,
//              borderRadius: BorderRadius.circular(10.0),
                nip: me ? BubbleNip.rightBottom : BubbleNip.leftBottom,
                alignment: me ? Alignment.topRight : Alignment.topLeft,
                elevation: 6.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment:
                        me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (!me)
                        new Text(snapshot.data['senderName'],
                            style: Theme.of(context).textTheme.subhead),
                      new Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: snapshot.data['imageUrl'] != null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: new Image.network(
                                  snapshot.data['imageUrl'],
                                  width: 250.0,
                                ),
                              )
                            : new Text(snapshot.data['text'],style:GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
              message:snapshot.data['date'] ,
            ),
          ),
        ],
      ),
    );
  }
}
