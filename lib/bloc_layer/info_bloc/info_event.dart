import 'package:demo_ican/data_layer/info.dart';
import 'package:equatable/equatable.dart';

abstract class InfoEvent extends Equatable {
  const InfoEvent();

  @override
  List<Object> get props => [];
}

class LoadInfo extends InfoEvent {}

class AddTodo extends InfoEvent {
  final Info todo;

  const AddTodo(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'AddTodo { todo: $todo }';
}

class UpdateTodo extends InfoEvent {
  final Info updatedInfo;

  const UpdateTodo(this.updatedInfo);

  @override
  List<Object> get props => [updatedInfo];

  @override
  String toString() => 'updateInfo { updatedinfo: $updatedInfo }';
}

class DeleteTodo extends InfoEvent {
  final Info info;

  const DeleteTodo(this.info);

  @override
  List<Object> get props => [info];

  @override
  String toString() => 'deleteInfo { info: $info }';
}

class ClearCompleted extends InfoEvent {}

class ToggleAll extends InfoEvent {}
