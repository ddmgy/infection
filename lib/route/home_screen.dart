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
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: _showAboutDialog,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: InkWell(
                child: Container(
                  child: const Text("Play game"),
                  height: 48,
                  alignment: Alignment.center,
                ),
                onTap: () => Navigator.pushNamed(context, Routes.setup),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
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