import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo3',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page3'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button3 this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
