import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskmanager/screens/home/model/element_Workspace.dart';
import 'package:taskmanager/screens/home/ui/page_task.dart';
import 'package:taskmanager/screens/home/utils/diamond_fab.dart';

class WorkspaceDetailPage extends StatefulWidget {
  final User user;
  final int i;
  final Map<String, List<ElementWorkspace>> currentEmail;
  final String color;

  WorkspaceDetailPage(
      {Key key, this.user, this.i, this.currentEmail, this.color,})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _WorkspaceDetailPageState();
}

class _WorkspaceDetailPageState extends State<WorkspaceDetailPage> {
  TextEditingController itemController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(icon: Icon(Icons.add), onPressed:
            () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Row(
                      children: <Widget>[
                        Expanded(
                          child: new TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                    borderSide:
                                    new BorderSide(color: currentColor)),
                                labelText: "TaskType",
                                hintText: "TaskType",
                                contentPadding: EdgeInsets.only(
                                    left: 16.0,
                                    top: 20.0,
                                    right: 16.0,
                                    bottom: 5.0)),
                            controller: itemController,
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      ButtonTheme(
                        //minWidth: double.infinity,
                        child: RaisedButton(
                          elevation: 3.0,
                          onPressed: () {
                            if (itemController.text.isNotEmpty &&
                                !widget.currentEmail.values
                                    .contains(itemController.text.toString())) {
                              List listTaskType = [itemController.text.toString()];
                              FirebaseFirestore.instance
                                  .collection("Workspace")
                                  .doc(widget.currentEmail.keys.elementAt(widget.i))
                                  .update(
                                  {"taskType": FieldValue.arrayUnion(listTaskType)});
                              itemController.clear();
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Add'),
                          color: currentColor,
                          textColor: const Color(0xffffffff),
                        ),
                      ),
                    ],
                  );
                },
              );
            },)],
        backgroundColor: currentColor,
      ),
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: new Stack(
        children: <Widget>[
          Container(
            child: NotificationListener<OverscrollIndicatorNotification>(
              child: new StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Workspace")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return new Center(
                          child: CircularProgressIndicator(
                        backgroundColor: currentColor,
                      ));
                    return new Container(
                      child: getExpenseItems(snapshot),
                    );
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: DiamondFab(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Row(
                  children: <Widget>[
                    Expanded(
                      child: new TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: currentColor)),
                            labelText: "Email",
                            hintText: "Email",
                            contentPadding: EdgeInsets.only(
                                left: 16.0,
                                top: 20.0,
                                right: 16.0,
                                bottom: 5.0)),
                        controller: itemController,
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  ButtonTheme(
                    //minWidth: double.infinity,
                    child: RaisedButton(
                      elevation: 3.0,
                      onPressed: () {
                        if (itemController.text.isNotEmpty &&
                            !widget.currentEmail.values
                                .contains(itemController.text.toString())) {
                          List userEmail = [itemController.text.toString()];
                          FirebaseFirestore.instance
                              .collection("Workspace")
                              .doc(widget.currentEmail.keys.elementAt(widget.i))
                              .update(
                                  {"user": FieldValue.arrayUnion(userEmail)});
                          itemController.clear();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Add'),
                      color: currentColor,
                      textColor: const Color(0xffffffff),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: currentColor,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ElementWorkspace> listElement = [];

    if (widget.user.uid.isNotEmpty) {
      snapshot.data.docs.map<Column>((f) {
        if (f.id == widget.currentEmail.keys.elementAt(widget.i)) {
          f.data().forEach((a, b) {
            if (a == "user") {
              listElement.add(new ElementWorkspace(a, b, f.data()['taskType']));
            }
          });
        }
      }).toList();

      return Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 0.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          pickerColor = currentColor;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Pick a color!'),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: pickerColor,
                                    onColorChanged: changeColor,
                                    enableLabel: true,
                                    colorPickerWidth: 300.0,
                                    pickerAreaHeightPercent: 0.7,
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Got it'),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("Workspace")
                                          .doc(widget.currentEmail.keys
                                              .elementAt(widget.i))
                                          .update({
                                        "color": pickerColor.value.toString()
                                      });

                                      setState(
                                          () => currentColor = pickerColor);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(Icons.format_paint),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder()),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(1.5)),
                          backgroundColor:
                              MaterialStateProperty.all(currentColor),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          widget.currentEmail.keys.elementAt(widget.i),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 35.0),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return new AlertDialog(
                                title: Text("Delete: " +
                                    widget.currentEmail.keys
                                        .elementAt(widget.i)
                                        .toString()),
                                content: Text(
                                  "Are you sure you want to delete this Workspace?",
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                                actions: <Widget>[
                                  ButtonTheme(
                                    //minWidth: double.infinity,
                                    child: RaisedButton(
                                      elevation: 3.0,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('No'),
                                      color: currentColor,
                                      textColor: const Color(0xffffffff),
                                    ),
                                  ),
                                  ButtonTheme(
                                    //minWidth: double.infinity,
                                    child: RaisedButton(
                                      elevation: 3.0,
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection("Workspace")
                                            .doc(widget.currentEmail.keys
                                                .elementAt(widget.i))
                                            .delete();
                                        Navigator.pop(context);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('YES'),
                                      color: currentColor,
                                      textColor: const Color(0xffffffff),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          FontAwesomeIcons.trash,
                          size: 31.0,
                          color: currentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.black,
                    width: 400.0,
                    height: 3.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Color(0xFFFCFCFC),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: listElement.elementAt(widget.i).users != null ?
                            ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: listElement.elementAt(widget.i).users.length,
                              itemBuilder: (BuildContext ctxt, int i) {
                                return new Slidable(
                                  delegate: new SlidableBehindDelegate(),
                                  actionExtentRatio: 0.25,
                                  child: GestureDetector(
                                    onTap: () {
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 50.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                            ),
                                            Flexible(
                                              child: Text(
                                                '${listElement.elementAt(widget.i).users[i]}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 27.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  secondaryActions: <Widget>[
                                    new IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.black,
                                      icon: Icons.delete,
                                      onTap: () {
                                        listElement[0].users.removeAt(i);
                                        FirebaseFirestore.instance
                                            .collection("Workspace")
                                            .doc(widget.currentEmail.keys
                                                .elementAt(widget.i))
                                            .update({"user":
                                          listElement.elementAt(0).taskType});
                                      },
                                    ),
                                  ],
                                );
                              }):Container(),
                        ),
                      ),
                      Container(
                        color: Color(0xFFFCFCFC),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: listElement.elementAt(widget.i).taskType != null ?
                          ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: listElement.elementAt(widget.i).taskType.length,
                              itemBuilder: (BuildContext ctxt, int i) {
                                return new Slidable(
                                  delegate: new SlidableBehindDelegate(),
                                  actionExtentRatio: 0.25,
                                  child: GestureDetector(
                                    onTap: () {
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 50.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                              EdgeInsets.only(left: 10.0),
                                            ),
                                            Flexible(
                                              child: Text(
                                                '${listElement.elementAt(widget.i).taskType[i]}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 27.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  secondaryActions: <Widget>[
                                    new IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.black,
                                      icon: Icons.delete,
                                      onTap: () {
                                        listElement[0].taskType.removeAt(i);
                                        FirebaseFirestore.instance
                                            .collection("Workspace")
                                            .doc(widget.currentEmail.keys
                                            .elementAt(widget.i))
                                            .update({"taskType":
                                        listElement.elementAt(0).taskType});
                                      },
                                    ),
                                  ],
                                );
                              }):Container(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: new Column(
                    children: <Widget>[
                      new ElevatedButton(
                        child: Text('Enter'),
                        onPressed: () {
                          final String workspaceName =
                              widget.currentEmail.keys.elementAt(widget.i);
                          Navigator.pushReplacement(
                              context,
                              (MaterialPageRoute(
                                  builder: (context) => TaskPage(
                                        workspaceName: workspaceName,
                                        taskType: listElement.elementAt(widget.i).taskType,
                                      ))));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: currentColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // color: Colors.blue,
                      // elevation: 4.0,
                      // splashColor: Colors.deepPurple,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    pickerColor = Color(int.parse(widget.color));
    currentColor = Color(int.parse(widget.color));
  }

  Color pickerColor;
  Color currentColor;

  ValueChanged<Color> onColorChanged;

  changeColor(Color color) {
    setState(() => pickerColor = color);
  }
}
