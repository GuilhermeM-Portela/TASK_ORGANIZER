import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskmanager/config/palette.dart';
import 'package:taskmanager/screens/home/model/element_Workspace.dart';
import 'package:taskmanager/screens/home/ui/page_add_workspace.dart';
import 'package:taskmanager/screens/home/ui/page_detail_workspace.dart';
import 'package:taskmanager/screens/home/ui/page_settings.dart';

class WorkspacePage extends StatefulWidget {
  WorkspacePage({Key key}) : super(key: key);

  static MaterialPageRoute get route => MaterialPageRoute(
        builder: (context) => WorkspacePage(),
      );

  final user = FirebaseAuth.instance.currentUser;

  @override
  State<StatefulWidget> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage>
    with SingleTickerProviderStateMixin {
  int index = 1;
  int _currentIndex = 0;

  Widget futureIndex() {
    if (_currentIndex == 0) {
      return listWorkspace();
    } else if (_currentIndex == 1) {
      return SettingsPage(
        user: FirebaseAuth.instance.currentUser,
      );
    }
  }

  Widget listWorkspace() {
    return ListView(
      children: <Widget>[
        //_getToolbar(context),
        new Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Workspace',
                            style: new TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                          // Text(
                          //   'Manager',
                          //   style: new TextStyle(
                          //       fontSize: 28.0, color: Colors.grey),
                          // )
                        ],
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: new Column(
                children: <Widget>[
                  new Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.all(Radius.circular(7.0))),
                    child: new IconButton(
                      icon: new Icon(Icons.add),
                      onPressed: _addWorkspacePressed,
                      iconSize: 30.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text('Add Workspace',
                        style: TextStyle(color: Colors.black45)),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Container(
            height: 360.0,
            padding: EdgeInsets.only(bottom: 25.0),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
              },
              child: new StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Workspace")
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return new Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ));
                    return new ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(left: 40.0, right: 40.0),
                      scrollDirection: Axis.horizontal,
                      children: getExpenseItems(snapshot),
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          fixedColor: Palette.darkBlue,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: new Icon(FontAwesomeIcons.borderAll), label: ("")),
            BottomNavigationBarItem(
                icon: new Icon(FontAwesomeIcons.cogs), label: ("")),
            // BottomNavigationBarItem(
            //     icon: new Icon(FontAwesomeIcons.slidersH), label:(""))
          ],
        ),
        body: futureIndex());
  }

  @override
  void dispose() {
    super.dispose();
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ElementWorkspace> listElement = new List(), listElement2;
    Map<String, List<ElementWorkspace>> userMap = new Map();

    List<String> cardColor = [];

    if (widget.user.uid.isNotEmpty) {
      cardColor.clear();
      snapshot.data.docs.map((f) {
        String color;
        f.data().forEach((a, b) {
          if (b.runtimeType == bool) {
            if (f["user"] == widget.user.email) {
              listElement.add(new ElementWorkspace(a, b, f.data()['taskType']));
            }
          }
          if (b.runtimeType == String && a == "color") {
            color = b;
          }
        });
        listElement2 = new List<ElementWorkspace>.from(listElement);
        for (int i = 0; i < listElement2.length; i++) {
          if (listElement2 == "user") {
            userMap[f.id] = listElement2;
            cardColor.add(color);
            break;
          }
        }
        if (listElement2.length == 0) {
          if (f["user"].contains(widget.user.email)) {
            userMap[f.id] = listElement2;
            cardColor.add(color);
          }
        }
        listElement.clear();
      }).toList();

      return new List.generate(userMap.length, (int index) {
        return new GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              new PageRouteBuilder(
                pageBuilder: (_, __, ___) => new WorkspaceDetailPage(
                  user: widget.user,
                  i: index,
                  currentEmail: userMap,
                  color: cardColor.elementAt(index),
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        new ScaleTransition(
                  scale: new Tween<double>(
                    begin: 1.5,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Interval(
                        0.50,
                        1.00,
                        curve: Curves.linear,
                      ),
                    ),
                  ),
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Interval(
                          0.00,
                          0.50,
                          curve: Curves.linear,
                        ),
                      ),
                    ),
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            color: Color(int.parse(cardColor.elementAt(index))),
            child: new Container(
              width: 220.0,
              //height: 100.0,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                      child: Container(
                        child: Text(
                          userMap.keys.elementAt(index),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.only(left: 50.0),
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 30.0, left: 15.0, right: 5.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 220.0,
                            child: ListView.builder(
                                //physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    userMap.values.elementAt(index).length,
                                itemBuilder: (BuildContext ctxt, int i) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                      ),
                                      Flexible(
                                        child: Text(
                                          userMap.values
                                              .elementAt(index)
                                              .elementAt(i)
                                              .users[i],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _addWorkspacePressed() async {
    Navigator.of(context).push(
      new PageRouteBuilder(
        pageBuilder: (_, __, ___) => new NewWorkspacePage(
          user: widget.user,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            new ScaleTransition(
          scale: new Tween<double>(
            begin: 1.5,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.50,
                1.00,
                curve: Curves.linear,
              ),
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.00,
                  0.50,
                  curve: Curves.linear,
                ),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
    //Navigator.of(context).pushNamed('/new');
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
