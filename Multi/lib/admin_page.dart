import 'package:flutter/material.dart';

class Adminpage extends StatefulWidget {
  const Adminpage({Key key}) : super(key: key);

  @override
  _AdminpageState createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Center(
        child: Container(
          child: Text('Admin/Provider Page')
        ),
      ),
    );
  }
}
