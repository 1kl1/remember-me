import 'package:flutter/material.dart';
import 'widgets/app_scaffold.dart'; // Import the new AppScaffold
import 'constants.dart'; // Import constants

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory App',
      theme: ThemeData(
        primarySwatch: Colors.amber, // This will be overridden by other specific colors
        scaffoldBackgroundColor: kAppBgColor,
        fontFamily: 'Roboto', // You can use any preferred font
        appBarTheme: AppBarTheme(
          backgroundColor: kAppBgColor,
          elevation: 0,
          iconTheme: IconThemeData(color: kInactiveNavTextTeal),
          titleTextStyle: TextStyle(color: kDefaultTextColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: AppScaffold(), // Use the new AppScaffold
      debugShowCheckedModeBanner: false,
    );
  }
}