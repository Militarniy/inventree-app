import 'package:flutter/material.dart';

import 'login_settings.dart';

import 'package:package_info/package_info.dart';

class InvenTreeSettingsWidget extends StatefulWidget {
  // InvenTree settings view

  @override
  _InvenTreeSettingsState createState() => _InvenTreeSettingsState();

}


class _InvenTreeSettingsState extends State<InvenTreeSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("InvenTree Settings"),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
                title: Text("Server Settings"),
                subtitle: Text("Configure server and login settings"),
                onTap: _editServerSettings,
            ),
            Divider(),
            ListTile(
              title: Text("About"),
              subtitle: Text("App details"),
              onTap: _about,
            ),
          ],
        )
      )
    );
  }

  void _editServerSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => InvenTreeLoginSettingsWidget()));
  }

  void _about() async {

    PackageInfo.fromPlatform().then((PackageInfo info) {
      showDialog(
        context: context,
        child: new SimpleDialog(
            title: new Text("About InvenTree"),
            children: <Widget>[
                ListTile(
                  title: Text("App Name"),
                  subtitle: Text("${info.appName}"),
                ),
                ListTile(
                  title: Text("App Version"),
                  subtitle: Text("${info.version}"),
                ),
                ListTile(
                  title: Text("Package Name"),
                  subtitle: Text("${info.packageName}"),
                ),
                ListTile(
                  title: Text("Build Number"),
                  subtitle: Text("${info.buildNumber}")
                ),
            ]
        ),
      );
    });
  }
}