import 'package:demo_ican/data_layer/model/lecture.dart';
import 'package:demo_ican/ui_layer/web/web_controler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LectureList extends StatelessWidget {
//  final _links = ['https://google.com'];
  final List<Lecture> _list = Lecture.lectures;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).tr("lecture"),
              style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20)),
          backgroundColor: Colors.deepPurple,
        ),
        body: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _list.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_list[index].name,style:GoogleFonts.cairo(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                    onTap: () => _handleURLButtonPress(
                        context, _list[index].url, _list[index].name),
                  ),
                );
              },
            )));
  }

  void _handleURLButtonPress(BuildContext context, String url, String name) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(url, title: name)));
  }
}
