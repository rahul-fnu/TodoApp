import 'package:Todoapp/models/classes/task.dart';
import 'package:Todoapp/models/global.dart';
import 'package:Todoapp/models/widgets/intray_todo_widget.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import '../../models/global.dart';

class IntrayPage extends StatefulWidget {
  @override
  _IntrayPageState createState() => _IntrayPageState();
}

class _IntrayPageState extends State<IntrayPage> {
  List<Task> taskList = [];
  @override
  Widget build(BuildContext context) {
    taskList = getList();
    return Container(
      color: darkGreyColor,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: _buildReorderableListSimple(context, taskList),
      ),
      //child: ReorderableListView(
      //  padding: EdgeInsets.only(top: 300),
      //children: todoItems,
      //onReorder: _onReorder,
      //),
    );
  }

  Widget _buildListTile(BuildContext context, Task item) {
    return ListTile(
      key: Key(item.taskId.toString()),
      title: IntrayTodo(
        title: item.title,
      ),
    );
  }

  Widget _buildReorderableListSimple(
      BuildContext context, List<Task> taskList) {
    ScrollController _scrollController =
        PrimaryScrollController.of(context) ?? ScrollController();
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: CustomScrollView(
        // handleSide: ReorderableListSimpleSide.Right,
        // handleIcon: Icon(Icons.access_alarm),
        controller: _scrollController,
        slivers: <Widget>[
          ReorderableSliverList(
            delegate: ReorderableSliverChildListDelegate(taskList
                .map((Task item) => _buildListTile(context, item))
                .toList()),
            onReorder: _onReorder,
          )
        ],
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      Task row = taskList.removeAt(oldIndex);
      taskList.insert(newIndex, row);
    });
  }

  List<Task> getList() {
    for (int i = 0; i < 10; i++) {
      taskList.add(Task("My first todo " + i.toString(), false, i.toString()));
    }
    return taskList;
  }
}
