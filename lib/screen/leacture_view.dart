import 'package:demo_ican/data_layer/model/lecture.dart';
import 'package:demo_ican/ui_layer/web/web_controler.dart';
import 'package:flutter/material.dart';

class LectureList extends StatelessWidget {
//  final _links = ['https://google.com'];
  final List<Lecture> _list = Lecture.lectures;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Web View"),
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
                  //                           <-- Card widget
                  child: ListTile(
                    title: Text(_list[index].name),
                    onTap: () => _handleURLButtonPress(
                        context, _list[index].url, _list[index].name),
                  ),
                );
              },
            )));
  }

//  Widget _urlButton(BuildContext context, String url) {
//    return Container(
//        padding: EdgeInsets.all(20.0),
//        child: FlatButton(
//          color: Theme.of(context).primaryColor,
//          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
//          child: Text(url),
//          onPressed: () => _handleURLButtonPress(context, url),
//        ));
//  }

  void _handleURLButtonPress(BuildContext context, String url, String name) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(url, title: name)));
  }
}
