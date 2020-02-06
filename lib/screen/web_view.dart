import 'package:demo_ican/screen/web_controler.dart';
import 'package:flutter/material.dart';

class WebViewList extends StatelessWidget {
//  final _links = ['https://google.com'];
List<WebItem> _list =[
  new WebItem("التغذية و السكري", "https://docs.google.com/presentation/d/1yCDMxqm6sbkbHRrsjje8-K48NI-56noMm9sqGbkv9xw/edit?usp=sharing"),
  new WebItem("كن كاشفا للدهون", "https://docs.google.com/presentation/d/1fRWACuOOeHYna2el2xiLq6EIN35C18W_G9Z7jlJxjgQ/edit?usp=sharing"),
];
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
                return Card( //                           <-- Card widget
                  child: ListTile(
                    title: Text(_list[index].name),
                    onTap:  () => _handleURLButtonPress(context, _list[index].url),
                  ),
                );
              },
            )
        )
    );
  }

  Widget _urlButton(BuildContext context, String url) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: FlatButton(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
          child: Text(url),
          onPressed: () => _handleURLButtonPress(context, url),
        ));
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }
}

class WebItem {
  String name;
  String url;

  WebItem(this.name, this.url);
}
