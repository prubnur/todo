import 'package:flutter/material.dart';
import 'package:notodo/model/nodo_item.dart';
import 'package:notodo/util/database_client.dart';
import 'package:notodo/util/date_formatter.dart';

class NoToDoScreen extends StatefulWidget {
  @override
  _NoToDoScreenState createState() => _NoToDoScreenState();
}

class _NoToDoScreenState extends State<NoToDoScreen> {
  final TextEditingController _textController = new TextEditingController();
  var db = new DatabaseHelper();
  final List<NoDoItem> _itemList = <NoDoItem>[];

  @override
  void initState() {
    super.initState();
    _readNoDoList();

  }



  void _handleSubmitted(String text) async {
    _textController.clear();

    NoDoItem noDoItem = new NoDoItem(text, dateFormatted());

    int savedItemId = await db.saveItem(noDoItem);

    NoDoItem addedItem = await db.getItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: false,
                  itemCount: _itemList.length,
                  itemBuilder: (_, int index) {
                      return Card(
                        color: Colors.white10,
                        child: new ListTile(
                          title: _itemList[index],
                          onLongPress: () {
                            _textController.text = _itemList[index].itemName;
                            _updateItem(_itemList[index], index);
                          },
                          trailing: new Listener(
                            key: Key(_itemList[index].itemName),
                            child: new Icon(Icons.remove_circle,
                            color: Colors.redAccent,),
                            onPointerDown: (pointerEvent) =>
                                _deleteNoDo(_itemList[index].id, index),
                          ),
                        ),
                      );
                  }
              )),
          Divider(
            height: 1.0,
          )
        ],
      ),


      floatingActionButton: new FloatingActionButton(
        tooltip: "Add Item",
        backgroundColor: Colors.redAccent,
        child: new ListTile(
          title: Icon(Icons.add),
        ),
        onPressed: _showFormDialog,
      ),
    );
  }

  void _showFormDialog() {
    _textController.clear();
    var alert = new AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
                controller: _textController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Item',
                  hintText: 'e.g: Walk the dog',
                  icon: Icon(Icons.note_add)
                ),
              )
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _handleSubmitted(_textController.text);
            _textController.clear();
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            _textController.clear();
          },
          child: Text("Cancel"),
        ),
      ],
    );
    showDialog(context: context,
        builder: (_) {
            return alert;
        });
  }
  
  _readNoDoList() async {
    List items = await db.getAllItems();
    items.forEach((item) {
      //NoDoItem noDoItem = NoDoItem.map(item);
      setState(() {
        _itemList.add(NoDoItem.map(item));
      });
      //print("Db items: ${noDoItem.itemName}");
    });
  }

  _deleteNoDo(int id, int index) async {
    //  debugPrint("Deleted");

      await db.deleteItem(id);
      setState(() {
        _itemList.removeAt(index);
      });
  }

  _updateItem(NoDoItem item, int index) {
    var alert = new AlertDialog(
      title: new Text("Update Item"),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: TextField(
                controller: _textController,
                autofocus: true,

                decoration: InputDecoration(
                  labelText: "Item",
                  hintText: 'e.g: Walk the dog',
                  icon: Icon(Icons.update)
                ),
              )
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            NoDoItem newItemUpdated = NoDoItem.fromMap(
              {
                "itemName": _textController.text,
                "dateCreated": dateFormatted(),
                "id" : item.id,
              }
            );
            
            _handleSubmittedUpdate(index, item);
            await db.updateItem(newItemUpdated);
            setState(() {
              _readNoDoList();
            });
          },
          child: Text("Update"),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            _textController.clear();
          },
          child: Text("Cancel"),
        )
      ],
    );
    showDialog(context: context, builder: (_) {
      return alert;
    });
  }

  void _handleSubmittedUpdate(int index, NoDoItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == item.itemName;
      });
      _textController.clear();
      Navigator.pop(context);
    });
  }
}
