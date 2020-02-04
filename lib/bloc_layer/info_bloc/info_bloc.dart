//import 'dart:async';
//import 'package:bloc/bloc.dart';
//import 'package:demo_ican/bloc_layer/info_bloc/bloc.dart';
//import 'package:demo_ican/data_layer/info.dart';
//import 'package:demo_ican/data_layer/info_repository.dart';
//import 'package:meta/meta.dart';
//
//class InfoBloc extends Bloc<InfoEvent, InfoState> {
//  final InfoRepository _todosRepository;
//  StreamSubscription _todosSubscription;
//
//  InfoBloc({@required InfoRepository todosRepository})
//      : assert(todosRepository != null),
//        _todosRepository = todosRepository;
//
//  @override
//  InfoState get initialState => InfoLoading();
//
//  @override
//  Stream<InfoState> mapEventToState(InfoEvent event) async* {
//    if (event is LoadInfo) {
//      yield* _mapLoadTodosToState();
//    } else if (event is AddTodo) {
//      yield* _mapAddTodoToState(event);
//    } else if (event is UpdateTodo) {
//      yield* _mapUpdateTodoToState(event);
//    }
//  }
//
//  Stream<InfoState> _mapLoadTodosToState() async* {
//    _todosSubscription?.cancel();
//    _todosSubscription = _todosRepository.todos().listen(
//          (todos) => add(TodosUpdated(todos)),
//    );
//  }
//
//  Stream<TodosState> _mapAddTodoToState(AddTodo event) async* {
//    _todosRepository.addNewTodo(event.todo);
//  }
//
//  Stream<TodosState> _mapUpdateTodoToState(UpdateTodo event) async* {
//    _todosRepository.updateTodo(event.updatedTodo);
//  }
//
//
//
//
//  @override
//  Future<void> close() {
//    _todosSubscription?.cancel();
//    return super.close();
//  }
//}
