import 'dart:async';

import 'package:demo_ican/data_layer/info.dart';

abstract class InfoRepository{
  Future<void> addInfo(Info info);
  Info showInfo(String id);
  Future<void> updateInfo(Info update);
}