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

//  //  List _list= widget.videos;
//  List<YoutubePlayerController> _controllers = Video.videos
//      .map<YoutubePlayerController>(
//        (videoId) => YoutubePlayerController(
//          initialVideoId: videoId,
//          flags: YoutubePlayerFlags(
//            autoPlay: false,
//          ),
//        ),
//      )
//      .toList();
//
//  final List videos = [];

  getDate() async {
    print("in");
    QuerySnapshot querySnapshot = await firestore
        .collection("videos")
        .getDocuments();
//    querySnapshot.documents.forEach((f) {
//      print("add");
//      videos.add(f.data['id']);
//    });
    return querySnapshot.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tr("videos"),
            style: GoogleFonts.cairo(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child:
//        ListView.separated(
//          itemBuilder: (context, index) {
//            return Column(
//              children: <Widget>[
//                Text(Video.titles[index],style:GoogleFonts.cairo(
//                    color: Colors.black,
//                    fontWeight: FontWeight.w700,
//                    fontSize: 16)),
//                YoutubePlayer(
//                  key: ObjectKey(_controllers[index]),
//                  controller: _controllers[index],
//                  actionsPadding: EdgeInsets.only(left: 16.0),
//                  bottomActions: [
//                    CurrentPosition(),
//                    SizedBox(width: 10.0),
//                    ProgressBar(isExpanded: true),
//                    SizedBox(width: 10.0),
//                    RemainingDuration(),
//                    FullScreenButton(),
//                  ],
//                ),
//              ],
//            );
//          },
//          itemCount: _controllers.length,
//          separatorBuilder: (context, _) => SizedBox(height: 10.0),
//        ),
        FutureBuilder(
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
                    YoutubePlayerController playerController= YoutubePlayerController(
                      initialVideoId: snapshot.data[index].data['id'],
                      flags: YoutubePlayerFlags(
                        autoPlay: false,
                      ),
                    );
                    return
                      Card(
                        color: Colors.deepPurpleAccent,
                        child: Column(
                          children: <Widget>[
                            Text(snapshot.data[index].documentID,style:GoogleFonts.cairo(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                            SizedBox(height: 2,),
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

}
