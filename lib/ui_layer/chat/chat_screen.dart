import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'dart:async';

import 'message2.dart';

class ChatScreen2 extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen2> {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  final reference = Firestore.instance.collection("messages");
  Stream<QuerySnapshot> get query => reference.snapshots();
  final analytics = new FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Friendlychat"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Column(children: <Widget>[
          new Flexible(
            child: new FirestoreAnimatedList(
              query: query,
//              sort: (a, b) => b.key.compareTo(a.key),
//              padding: new EdgeInsets.all(8.0),
//              reverse: true,
//              itemBuilder: (_, DocumentSnapshot snapshot) {//, Animation<double> animation
//                return new ChatMessage(
//                    snapshot: snapshot,
////                    animation: animation
//                );
//              },
              itemBuilder: (
                BuildContext context,
                DocumentSnapshot snapshot,
                Animation<double> animation,
                int index,
              ) =>
                  FadeTransition(
                opacity: animation,
                child: ChatMessage(
//                  index: index,
                  snapshot: snapshot,
//                  onTap: _removeMessage,
                ),
              ),
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ]));
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(children: <Widget>[
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.photo_camera),
                  onPressed: () async {
                    print("images pikecr");
//                    File imageFile = await ImagePicker.pickImage();
                    var image =
                        await ImagePicker.pickImage(source: ImageSource.gallery);
                    int random = new Random().nextInt(100000);
//                    StorageReference ref =
//                    FirebaseStorage.instance.ref().child("image_$random.jpg");
//                    FirebaseStorage _storage =
//                    FirebaseStorage(storageBucket: 'gs://icanhel-demo.appspot.com/');
//                    String filePath = 'images/${DateTime.now()}.png';
//                    _storage.ref().child(filePath).putFile(image);
//                    StorageUploadTask uploadTask = ref.putFile(image);
//                    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
//                    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
//                    Uri downloadUrl = (await uploadTask.onComplete).downloadUrl();

                    final FirebaseStorage _storage = FirebaseStorage(
                        storageBucket: 'gs://icanhel-demo.appspot.com/');

                    StorageUploadTask _uploadTask;
                    String filePath = 'images/${DateTime.now()}.png';
                    _uploadTask = _storage.ref().child(filePath).putFile(image);
                    StorageTaskSnapshot storageTaskSnapshot =
                        await _uploadTask.onComplete;
                    String downloadUrl =
                        await storageTaskSnapshot.ref.getDownloadURL();
                    _sendMessage(imageUrl: downloadUrl);
                  }),
            ),
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? new CupertinoButton(
                        child: new Text("Send"),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                    : new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )),
          ]),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border:
                      new Border(top: new BorderSide(color: Colors.grey[200])))
              : null),
    );
  }

  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    _sendMessage(text: text);
  }

  void _sendMessage({String text, String imageUrl}) {
    reference.document().setData({
      'text': text,
      'imageUrl': imageUrl,
      'senderName': "nidal@gmail.com",
//      'senderPhotoUrl': googleSignIn.currentUser.photoUrl,
    });
    analytics.logEvent(name: 'send_message');
  }
}
