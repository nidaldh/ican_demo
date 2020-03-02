import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:demo_ican/ui_layer/chat/detail_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ImageScreen extends StatefulWidget {
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  Firestore firestore = Firestore.instance;
  final reference = Firestore.instance.collection("image");
  ConnectivityResult result;

  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    initConnectivity();

  }

  Future<void> initConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }
    print("internet :::: ");
    print(result);
//    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr =
        new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: AppLocalizations.of(context).tr("send_image"),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tr("image")),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.photo_camera),
                onPressed: () async {
                  await initConnectivity();
                  if (result == ConnectivityResult.none) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(
                            AppLocalizations.of(context).tr("no_internet")),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                    return null;
                  }
                  var image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  if (image == null) {
                    Fluttertoast.showToast(
                        msg: AppLocalizations.of(context).tr("no_image_selected"),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    pr.hide();
                    return null;
                  }
                  pr.show();
                  final FirebaseStorage _storage = FirebaseStorage(
                      storageBucket: 'gs://icanhel-demo.appspot.com/');
                  StorageUploadTask _uploadTask;
                  String filePath = 'note_image/${DateTime.now()}.png';
                  _uploadTask = _storage.ref().child(filePath).putFile(image);
                  StorageTaskSnapshot storageTaskSnapshot =
                      await _uploadTask.onComplete;

                  String downloadUrl =
                      await storageTaskSnapshot.ref.getDownloadURL();
                  _sendNote(downloadUrl);
                  pr.hide();
                  setState(() {});
                }),
          ),
          FutureBuilder(
            future: getImage(),
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
                return CarouselSlider.builder(
                  autoPlay: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int itemIndex) =>
                      Container(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return DetailScreen(
                                  url: snapshot.data[itemIndex].data['url'],
                                );
                              }));
                            },
                            onLongPress: (){
                              _showDialog(snapshot.data[itemIndex].documentID);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data[itemIndex].data['url'],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          )),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Future getImage() async {
//    print("in Image");
    QuerySnapshot qn = await firestore.collection("image").getDocuments();
    return qn.documents;
  }

  void _sendNote(String imageUrl) {
    print(DateTime.now().millisecondsSinceEpoch);
    var format2 = DateFormat('kk:mm:ss  y-M-d', 'ar');
    var dateString2 = format2.format(DateTime.now());
    print(dateString2);
    reference
        .document(DateTime.now().millisecondsSinceEpoch.toString())
        .setData({
      'url': imageUrl,
      'date': dateString2,
    });
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
