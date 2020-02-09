import 'package:demo_ican/data_layer/model/info.dart';
import 'package:equatable/equatable.dart';

abstract class InfoState extends Equatable {
  const InfoState();

  @override
  List<Object> get props => [];

}
  class InfoLoading extends InfoState{}

  class InfoLoaded extends InfoState {
  final Info info;

  const InfoLoaded([this.info]);

  @override
  List<Object> get props => [info];

  @override
  String toString() => 'InfoLoaded { info: ${info.toString()} }';
  }

  class InfoNotLoaded extends InfoState {}




