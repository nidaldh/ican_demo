import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/data_layer/model/user.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:async';

import 'message2.dart';

class ChatScreen2 extends StatefulWidget {
  User user;

  ChatScreen2({this.user});

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
          backgroundColor: Colors.purple,
          title: new Text("Group chat"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Column(children: <Widget>[
          new Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(1, 3, 1, 0),
              child: new FirestoreAnimatedList(
                query: query,
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
                    me: snapshot.data['senderName'] == widget.user.name,
//                  onTap: _removeMessage,
                  ),
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

  ProgressDialog pr;

  Widget _buildTextComposer() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

//    pr.style(message: 'Showing some progress...');

    pr.style(
      message: 'Send Image',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

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
                    pr.show();
                    print("images pikecr");
//                    File imageFile = await ImagePicker.pickImage();
                    var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    final FirebaseStorage _storage = FirebaseStorage(
                        storageBucket: 'gs://icanhel-demo.appspot.com/');
                    StorageUploadTask _uploadTask;
                    String filePath = 'images/${DateTime.now()}.png';
                    _uploadTask = _storage.ref().child(filePath).putFile(image);
                    StorageTaskSnapshot storageTaskSnapshot =
                        await _uploadTask.onComplete;
                    pr.hide();
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
                child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null,
                )),
          ]),
        ));
  }

  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    _sendMessage(text: text);
  }

  void _sendMessage({String text, String imageUrl}) {
    print(DateTime.now().millisecondsSinceEpoch);
    var format = DateFormat.yMd();
    var format2 = DateFormat('kk:mm:ss  y-M-d', 'ar');
    var dateString = format.format(DateTime.now());
    var dateString2 = format2.format(DateTime.now());
    print(dateString);
    print(dateString2);

    reference
        .document(DateTime.now().millisecondsSinceEpoch.toString())
        .setData({
      'text': text,
      'imageUrl': imageUrl,
      'date': dateString2,
      'senderName': widget.user.name,
    });
    analytics.logEvent(name: 'send_message');
  }
}
