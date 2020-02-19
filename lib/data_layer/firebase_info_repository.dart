import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/data_layer/InfoEntity.dart';
import 'package:demo_ican/data_layer/model/info.dart';
import 'package:demo_ican/data_layer/info_repository.dart';

class FirebaseInfoRepository implements InfoRepository{
  final infoCollection = Firestore.instance.collection('info');


  @override
  Future<void> addInfo(Info info) {
    return infoCollection.add(info.toEntity().toDocument());
  }

  @override
  Info showInfo(String id)   {
//    return Info("","","",0);
    DocumentSnapshot x = infoCollection.document(id).get() as DocumentSnapshot;
    return Info.fromEntity(InfoEntity.fromSnapshot(x));
    }

  @override
  Future<void> updateInfo(Info update) {
    return infoCollection.document(update.id).updateData(update.toEntity().toDocument());
  }

}