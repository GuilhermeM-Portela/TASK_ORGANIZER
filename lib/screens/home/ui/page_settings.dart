import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';
import 'package:taskmanager/screens/auth/auth.dart';

import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final User user;

  SettingsPage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  linkendlin() async {
    const url = 'https://www.linkedin.com/in/guilherme-portela-41948b1a1/';
    await launch(url);
  }

  rateApp() async {
    LaunchReview.launch(
        androidAppId: "com.huextrat.taskist", iOSAppId: "1435481664");
  }

  _launchURL() async {
    const url = 'https://github.com/GuilhermeM-Portela/';
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
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
                              'Settings',
                              style: new TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
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
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                color: Colors.white,
                elevation: 2.0,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.cogs,
                        color: Colors.grey,
                      ),
                      title: Text("Version"),
                      trailing: Text("1.0.0"),
                    ),
                    ListTile(
                      onTap: linkendlin,
                      leading: Icon(
                        FontAwesomeIcons.linkedin,
                        color: Colors.blue,
                      ),
                      title: Text("Linkedlin"),
                      trailing: Icon(Icons.arrow_right),
                    ),
                    ListTile(
                      onTap: _launchURL,
                      leading: Icon(
                        FontAwesomeIcons.github,
                        color: Colors.black,
                      ),
                      title: Text("GitHub"),
                      trailing: Icon(Icons.arrow_right),
                    ),
                    ListTile(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacement(AuthScreen.route);
                      },
                      leading: Icon(
                        FontAwesomeIcons.user,
                        color: Colors.black,
                      ),
                      title: Text("Logout"),
                      trailing: Icon(Icons.arrow_right),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
