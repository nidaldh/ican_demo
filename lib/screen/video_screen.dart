import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/data_layer/model/video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Creates list of video players
class VideoList extends StatefulWidget {

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  Firestore firestore = Firestore.instance;

  //  List _list= widget.videos;
   List<YoutubePlayerController> _controllers =
//  [
//    'UXervHKFjLk',
//    'okaFmDsM5bc',
//    'fm2ZDmb5K-M',
//    '87ImUlk5C4o',
//    '6WeGn51_7PE',
//  ]
//  videos
  Video.videos
      .map<YoutubePlayerController>(
        (videoId) => YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(
            autoPlay: false,
          ),
        ),
      )
      .toList();

  final List videos=[];

//  getDate() async {
//    print("in");
//    QuerySnapshot querySnapshot = await firestore
//        .collection("videos")
//        .getDocuments();
//    querySnapshot.documents.forEach((f) {
//      print("add");
//      videos.add(f.data['id']);
//
//    });
////    firestore.collection("v").reference().snapshots().listen((querySnapshot) {
////      querySnapshot.documentChanges.forEach((change) {
////        // Do something with change
////      });
////  });
//    print(videos.length);
//  }

  @override
  Widget build(BuildContext context) {
//    print(widget.videos);
//    getDate();
    print(videos.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List Demo'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                Text(Video.titles[index]),
                YoutubePlayer(
                  key: ObjectKey(_controllers[index]),
                  controller: _controllers[index],
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
            );
          },
          itemCount: _controllers.length,
          separatorBuilder: (context, _) => SizedBox(height: 10.0),
        ),
      ),
    );
  }

  mybuil()async{
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List Demo'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return YoutubePlayer(
            key: ObjectKey(_controllers[index]),
            controller: _controllers[index],
            actionsPadding: EdgeInsets.only(left: 16.0),
            bottomActions: [
              CurrentPosition(),
              SizedBox(width: 10.0),
              ProgressBar(isExpanded: true),
              SizedBox(width: 10.0),
              RemainingDuration(),
              FullScreenButton(),
            ],
          );
        },
        itemCount: _controllers.length,
        separatorBuilder: (context, _) => SizedBox(height: 10.0),
      ),
    );
  }
}
