import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_practice/data_sources/todo_local_database.dart';
import 'package:sqflite_practice/data_sources/todo_repository.dart';
import 'package:sqflite_practice/note_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late TodoRepositoryImpl todoRepositoryImpl;
  List<Todo> todos = [];

  Future<void> _loadTodos() async {
    final loadedTodos = await todoRepositoryImpl.getTodos();
    setState(() {
      todos = loadedTodos;
    });
  }

  @override
  void initState() {
    super.initState();
    todoRepositoryImpl = TodoRepositoryImpl(TodoLocalDataSource());
    _loadTodos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('TODO CRUD'),
            TextFormField(controller: titleController),
            TextFormField(controller: descriptionController),
            SizedBox(height: 44),
            ElevatedButton(
              onPressed: () async {
                final todo = Todo(
                  title: titleController.text,
                  description: descriptionController.text,
                );
                await todoRepositoryImpl.createTodo(todo);
                _loadTodos();
              },
              child: Text('Add Todo'),
            ),
            if (todos.isEmpty) ...{Text('Empty List')},
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CupertinoListTile(
                        backgroundColor: Colors.grey.shade200,
                        title: Text(todo.title),
                        subtitle: Text(todo.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: todo.isCompleted,
                              onChanged: (_) {},
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                todoRepositoryImpl.deleteTodo(todo.id!);
                                _loadTodos();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
