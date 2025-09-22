import ‘package:flutter/material.dart’;

void main() {
runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
title: ‘待辦事項’,
theme: ThemeData(
primarySwatch: Colors.blue,
visualDensity: VisualDensity.adaptivePlatformDensity,
),
home: TodoHomePage(),
);
}
}

class TodoItem {
String id;
String title;
String? description;
bool isCompleted;
DateTime createdAt;

TodoItem({
required this.id,
required this.title,
this.description,
this.isCompleted = false,
required this.createdAt,
});
}

class TodoHomePage extends StatefulWidget {
@override
_TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
final TextEditingController _titleController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
List<TodoItem> _todos = [];
String _filter = ‘all’; // all, active, completed

@override
void dispose() {
_titleController.dispose();
_descriptionController.dispose();
super.dispose();
}

void _addTodo() {
if (_titleController.text.trim().isEmpty) return;

```
setState(() {
  _todos.add(TodoItem(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    title: _titleController.text.trim(),
    description: _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim(),
    createdAt: DateTime.now(),
  ));
});

_titleController.clear();
_descriptionController.clear();
Navigator.of(context).pop();
```

}

void _toggleTodo(String id) {
setState(() {
final index = _todos.indexWhere((todo) => todo.id == id);
if (index != -1) {
_todos[index].isCompleted = !_todos[index].isCompleted;
}
});
}

void _deleteTodo(String id) {
setState(() {
_todos.removeWhere((todo) => todo.id == id);
});
}

void _editTodo(TodoItem todo) {
_titleController.text = todo.title;
_descriptionController.text = todo.description ?? ‘’;

```
showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('編輯待辦事項'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: '標題 *',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: '描述（可選）',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _titleController.clear();
            _descriptionController.clear();
            Navigator.of(context).pop();
          },
          child: Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.trim().isNotEmpty) {
              setState(() {
                final index = _todos.indexWhere((t) => t.id == todo.id);
                if (index != -1) {
                  _todos[index].title = _titleController.text.trim();
                  _todos[index].description = _descriptionController.text.trim().isEmpty
                      ? null
                      : _descriptionController.text.trim();
                }
              });
              _titleController.clear();
              _descriptionController.clear();
              Navigator.of(context).pop();
            }
          },
          child: Text('儲存'),
        ),
      ],
    );
  },
);
```

}

List<TodoItem> get _filteredTodos {
switch (_filter) {
case ‘active’:
return _todos.where((todo) => !todo.isCompleted).toList();
case ‘completed’:
return _todos.where((todo) => todo.isCompleted).toList();
default:
return _todos;
}
}

void _showAddTodoDialog() {
showDialog(
context: context,
builder: (BuildContext context) {
return AlertDialog(
title: Text(‘新增待辦事項’),
content: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextField(
controller: _titleController,
decoration: InputDecoration(
labelText: ‘標題 *’,
border: OutlineInputBorder(),
),
),
SizedBox(height: 16),
TextField(
controller: _descriptionController,
decoration: InputDecoration(
labelText: ‘描述（可選）’,
border: OutlineInputBorder(),
),
maxLines: 3,
),
],
),
actions: [
TextButton(
onPressed: () {
_titleController.clear();
_descriptionController.clear();
Navigator.of(context).pop();
},
child: Text(‘取消’),
),
ElevatedButton(
onPressed: _addTodo,
child: Text(‘新增’),
),
],
);
},
);
}

@override
Widget build(BuildContext context) {
final filteredTodos = _filteredTodos;
final completedCount = _todos.where((todo) => todo.isCompleted).length;
final activeCount = _todos.length - completedCount;

```
return Scaffold(
  appBar: AppBar(
    title: Text('待辦事項'),
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    actions: [
      PopupMenuButton<String>(
        onSelected: (value) {
          setState(() {
            _filter = value;
          });
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'all',
            child: Row(
              children: [
                Icon(_filter == 'all' ? Icons.check : null),
                SizedBox(width: 8),
                Text('全部 (${_todos.length})'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'active',
            child: Row(
              children: [
                Icon(_filter == 'active' ? Icons.check : null),
                SizedBox(width: 8),
                Text('未完成 ($activeCount)'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'completed',
            child: Row(
              children: [
                Icon(_filter == 'completed' ? Icons.check : null),
                SizedBox(width: 8),
                Text('已完成 ($completedCount)'),
              ],
            ),
          ),
        ],
      ),
    ],
  ),
  body: Column(
    children: [
      // 統計資訊
      Container(
        padding: EdgeInsets.all(16),
        color: Colors.grey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatCard('總計', _todos.length, Colors.blue),
            _buildStatCard('未完成', activeCount, Colors.orange),
            _buildStatCard('已完成', completedCount, Colors.green),
          ],
        ),
      ),
      // 待辦事項列表
      Expanded(
        child: filteredTodos.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      _filter == 'active'
                          ? '沒有待完成的事項'
                          : _filter == 'completed'
                              ? '沒有已完成的事項'
                              : '還沒有待辦事項',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (_filter != 'completed' && _todos.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          '點擊下方按鈕新增第一個待辦事項',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = filteredTodos[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) => _toggleTodo(todo.id),
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: todo.isCompleted
                              ? Colors.grey[600]
                              : null,
                        ),
                      ),
                      subtitle: todo.description != null
                          ? Text(
                              todo.description!,
                              style: TextStyle(
                                decoration: todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: todo.isCompleted
                                    ? Colors.grey[500]
                                    : null,
                              ),
                            )
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editTodo(todo),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTodo(todo.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    ],
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: _showAddTodoDialog,
    child: Icon(Icons.add),
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
);
```

}

Widget _buildStatCard(String label, int count, Color color) {
return Container(
padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
decoration: BoxDecoration(
color: color.withOpacity(0.1),
borderRadius: BorderRadius.circular(8),
border: Border.all(color: color.withOpacity(0.3)),
),
child: Column(
children: [
Text(
count.toString(),
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: color,
),
),
Text(
label,
style: TextStyle(
fontSize: 12,
color: color,
),
),
],
),
);
}
}