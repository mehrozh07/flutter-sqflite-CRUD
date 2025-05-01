import 'package:flutter/material.dart';
import 'package:sqflite_practice/data_sources/todo_local_database.dart';
import 'package:sqflite_practice/data_sources/todo_repository.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late TodoRepositoryImpl todoRepositoryImpl;

  @override
  void initState() {
    super.initState();
    todoRepositoryImpl = TodoRepositoryImpl(TodoLocalDataSource());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text('TODO CRUD'),
          TextFormField(controller: titleController),
          TextFormField(controller: descriptionController),
        ],
      ),
    );
  }
}
