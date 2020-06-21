import 'package:flutter/material.dart';

import 'package:package_info/package_info.dart';

import 'package:infection/route/routes.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Infection"),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              child: const Text("Play Game"),
              onPressed: () {
                Navigator.pushNamed(context, Routes.setup);
              },
            ),
            RaisedButton(
              child: const Text("About"),
              onPressed: () {
                _showAboutDialog();
              },
            )
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() async {
    var packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    showAboutDialog(
      context: context,
      applicationName: appName,
      applicationVersion: "$version+$buildNumber",
    );
  }
}