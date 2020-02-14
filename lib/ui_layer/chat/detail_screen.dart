import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailScreen extends StatefulWidget {
  String url;

  DetailScreen({this.url});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    //SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: PhotoView(
              maxScale: 2.5,
              minScale: 0.1,
//              initialScale: .5,
//              tightMode: true,
              imageProvider: CachedNetworkImageProvider(

                 widget.url,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },

      ),
    );
  }
}
