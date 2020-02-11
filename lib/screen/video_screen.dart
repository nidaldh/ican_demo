import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/data_layer/model/video.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Creates list of video players
class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  Firestore firestore = Firestore.instance;

  //  List _list= widget.videos;
  List<YoutubePlayerController> _controllers = Video.videos
      .map<YoutubePlayerController>(
        (videoId) => YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(
            autoPlay: false,
          ),
        ),
      )
      .toList();

  final List videos = [];

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
        title: Text(AppLocalizations.of(context).tr("videos"),
            style: GoogleFonts.cairo(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                Text(Video.titles[index],style:GoogleFonts.cairo(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
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

}
