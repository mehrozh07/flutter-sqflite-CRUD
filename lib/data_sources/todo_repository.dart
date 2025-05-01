import 'package:sqflite_practice/data_sources/todo_local_database.dart';
import 'package:sqflite_practice/note_model.dart';

abstract class TodoRepository {
  Future<int> createTodo(Todo todo);
  Future<List<Todo>> getTodos();
  Future<Todo?> getTodoById(int id);
  Future<int> updateTodo(Todo todo);
  Future<int> deleteTodo(int id);
}

class TodoRepositoryImpl extends TodoRepository {
  final TodoLocalDataSource localDataSource;
  TodoRepositoryImpl(this.localDataSource);

  @override
  Future<int> createTodo(Todo todo) async {
    final todoData = await localDataSource.insertIntoTODO(
      TodoModel.fromEntity(todo),
    );
    return todoData;
  }

  @override
  Future<int> deleteTodo(int id) async {
    return await localDataSource.deleteTodo(id);
  }

  @override
  Future<Todo?> getTodoById(int id) async {
    final todoModel = await localDataSource.getTodoById(id);
    return todoModel;
  }

  @override
  Future<List<Todo>> getTodos() async {
    final todoModels = await localDataSource.getAllTodos();
    return todoModels.map((element) => element).toList();
  }

  @override
  Future<int> updateTodo(Todo todo) async {
    return await localDataSource.updateTodo(TodoModel.fromEntity(todo));
  }
}
