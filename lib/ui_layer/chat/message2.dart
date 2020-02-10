import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@override
class ChatMessage extends StatelessWidget {
  ChatMessage({this.snapshot, this.animation});
  final DocumentSnapshot snapshot;
  final Animation animation;

  Widget build(BuildContext context) {

    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//            new Container(
//              margin: const EdgeInsets.only(right: 16.0),
//              child: new CircleAvatar(backgroundImage: new NetworkImage(snapshot.data['senderPhotoUrl'])),
//            ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                    snapshot.data['senderName'],
                    style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child:
                    snapshot.data['imageUrl'] != null ?
                    new Image.network(
                      snapshot.data['imageUrl'],
                      width: 250.0,
                    ) :
                  new Text(snapshot.data['text']),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


