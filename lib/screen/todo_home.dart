// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/screen/add_todo.dart';
// import 'package:http/http.dart' as http;
import 'package:todo_app/services/todo_services.dart';

class TodoHome extends StatefulWidget {
  const TodoHome({super.key});

  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Todo List',
          style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Colors.amber[600]),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text('No Item')),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return Card(
                    color: Colors.blueGrey,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.cyan,
                        child: Text('${index + 1}'),
                      ),
                      title: Text(
                        item['title'],
                        style: GoogleFonts.poppins(color: Colors.amber[600]),
                      ),
                      subtitle: Text(item['description']),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            NavigationToEditPage(item);
                          } else if (value == 'delete') {
                            deletedById(id);
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              child: Text('Edit'),
                              value: 'edit',
                            ),
                            const PopupMenuItem(
                              child: Text('Delete'),
                              value: 'delete',
                            )
                          ];
                        },
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: NavigationToAddPage,
        label: const Text('Add Todo'),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> NavigationToEditPage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddTodo(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> NavigationToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodo());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deletedById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showFailedMessage('Failed');
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodo();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showFailedMessage('Failed');
    }
    setState(() {
      isLoading = false;
    });
  }

  void showFailedMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
