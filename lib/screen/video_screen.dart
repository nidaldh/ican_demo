import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Creates list of video players
class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  Firestore firestore = Firestore.instance;
  final reference = Firestore.instance.collection("videos");
  final _formKey = GlobalKey<FormState>();
  String id = "";
  String title = "";
  getDate() async {
    print("in");
    QuerySnapshot querySnapshot =
        await reference.getDocuments();
    return querySnapshot.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print("pressed");
              _asyncInputDialog(context);
            },
          )
        ],
        title: Text(AppLocalizations.of(context).tr("videos"),
            style: GoogleFonts.cairo(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: FutureBuilder(
          future: getDate(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Card(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              );

            if (snapshot.connectionState == ConnectionState.done) {
              print(snapshot.data.length);
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    YoutubePlayerController playerController =
                        YoutubePlayerController(
                      initialVideoId: snapshot.data[index].data['id'],
                      flags: YoutubePlayerFlags(
                        autoPlay: false,
                      ),
                    );
                    return Card(
                      color: Colors.deepPurpleAccent,
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onLongPress: (){
                              print("object");
                              _showDialog(snapshot.data[index].documentID);
                            },
                            child: Text(snapshot.data[index].documentID,
                                style: GoogleFonts.cairo(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          YoutubePlayer(
                            key: ObjectKey(playerController),
                            controller: playerController,
                            actionsPadding: EdgeInsets.only(left: 16.0),
                            bottomActions: [
                              CurrentPosition(),
                              SizedBox(width: 10.0),
                              ProgressBar(isExpanded: true),
                              SizedBox(width: 10.0),
                              RemainingDuration(),
                              FullScreenButton(),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(AppLocalizations.of(context).tr("enter_video_details")),
          content: Form(
            key: _formKey,
            child: Container(
              width: 300,
              height: 300,
              child: new Column(
                children: <Widget>[
                  TextFormField(
//                  initialValue: note,
                    decoration: InputDecoration(
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
                      title = value.trim();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
//                  initialValue: note,
                    decoration: InputDecoration(
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
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  await firestore
                      .collection("videos")
                      .document(title)
                      .setData({"id": id}).catchError((err) {
                    Fluttertoast.showToast(msg: "error");
                  });
                  Fluttertoast.showToast(msg: "updated");
                  Navigator.of(context).pop(teamName);
                  setState(() {});
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(String id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(AppLocalizations.of(context).tr("delete_image")
              ,style: TextStyle(color: Colors.redAccent)),
          content: new Text(AppLocalizations.of(context).tr("delete_alert")),
          actions: <Widget>[
            new FlatButton(
              child: new Text(AppLocalizations.of(context).tr("yes"),style: TextStyle(color: Colors.redAccent),),
              onPressed: () {
                reference.document(id).delete();
                setState(() {

                });
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

}
