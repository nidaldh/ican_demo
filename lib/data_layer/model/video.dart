import 'package:cloud_firestore/cloud_firestore.dart';

class Video{
  String name;
  String id;
  Firestore firestore = Firestore.instance;

  Video(this.name, this.id);
//  static List videos;

  static List videos=[
    'UXervHKFjLk',
    'okaFmDsM5bc',
    'fm2ZDmb5K-M',
    '87ImUlk5C4o',
    '6WeGn51_7PE',
  ];

  static List titles=[
    'تمارين لمنطقة الرقبة والظهر',
    'تمارين سهلة و فعالة لنحت الخصر بسرعة',
    'تمارين لحرق الدهون في نصف ساعة',
    'تمارين شد ونحت لكافة عضلات الجسم',
    ' تمارين لعضلات المعدة',
  ];

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


}