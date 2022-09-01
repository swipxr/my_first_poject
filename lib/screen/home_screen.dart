import 'package:flutter/material.dart';
import 'package:my_first_poject/connect.dart';
import 'package:my_first_poject/screen/about_screen.dart';
import 'package:my_first_poject/screen/add_screen.dart';
import 'package:my_first_poject/screen/contact_screen.dart';
import 'package:mysql1/mysql1.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _todoItem = [];

  Future<void> _getTodos() async {
    var connect = await MySqlConnection.connect(mysqlSettings);
    var results = await connect.query("""
      SELECT * FROM todos
""");
    for (var item in results) {
      setState(() {
        _todoItem.add({
          'todo_id': item.fields['todo_id'],
          'name': item.fields['name'],
          'status': item.fields['status'],
          'created_at': item.fields['created_at'],
        });
      });
    }
  }

  Future<void> _dleteTodo(int id) async {
    var connect = await MySqlConnection.connect(mysqlSettings);
    var results = await connect.query(
      """
      DELETE FROM todos WHERE todo_id = ?
""",
      [id],
    );

    setState(() {
      _todoItem.removeWhere((element) => element['todo_id'] == id);
    });
  }

  Future<void> _updateTodo(int id, int status) async {
    var connect = await MySqlConnection.connect(mysqlSettings);
    var results = await connect.query(
      """
      UPDATE todos SET status = ? WHERE todo_id = ?
""",
      [status, id],
    );

    setState(() {
      var item = _todoItem.firstWhere((element) => element['todo_id'] == id);
      item['status'] = status;
    });
  }

  @override
  void initState() {
    super.initState();
    _getTodos();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MY APP"),
      ),
      drawer: Drawer(),
      body: _todoItem.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _todoItem.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      var newStatus = _todoItem[index]['status'] == 0 ? 1 : 0;
                      _updateTodo(_todoItem[index]['todo_id'], newStatus);
                    },
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("คุณแน่ใจหรือไม่ที่จะลบรายการนี้ ?"),
                              content: Text(
                                  "หลังจากลบรายการแล้วจะไม่สามารถกู้คืนได้"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("ยกเลิก"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _dleteTodo(_todoItem[index]['todo_id']);
                                  },
                                  child: Text("ยืนยัน"),
                                ),
                              ],
                            );
                          });
                    },
                    title: Text(_todoItem[index]['name']),
                    subtitle: _todoItem[index]['status'] == 0
                        ? Text('ยังไม่เสร็จ')
                        : Text('เสร็จแล้ว'),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (Value) {
          switch (Value) {
            case 0:
              Navigator.of(context).pushNamed(HomeScreen.routeName);
              break;
            case 1:
              Navigator.of(context).pushNamed(AboutScreen.routeName);
              break;
            case 2:
              Navigator.of(context).pushNamed(ContactScreen.routeName);
              break;
            default:
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.width_normal), label: 'About'),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Contact',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddScreen.routeName).then((value) {
            setState(() {
              _todoItem.clear();
            });
            _getTodos();
          });
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
