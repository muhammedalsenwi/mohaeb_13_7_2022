import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'main.dart';

class Settings extends StatefulWidget {
  const Settings({required Key key}) : super(key: key);

  @override
  SettingsState createState() => new SettingsState();
}

class SettingsState extends State<Settings> {
  late SharedPreferences prefs;
 // List dd ;
  static  bool counter =false;
//  bool _isRow ;

//  List<Color>color=[
//    Colors.white,
//    Colors.black87,
//    Color(0xff291747),
//    Colors.grey.shade800,
//    Color(0xff291755),
//  ];
//  List<Color>color1=[
//    Colors.black,
//    Colors.white,
//    Colors.blue[700],
//    Color(0xff6c48AB),
//    Colors.blue[700],
//  ];

  @override
  void initState() {
    BackButtonInterceptor.add(back);
    super.initState();
   // dd=color;
    _loadCounter();
  }
  @override
  void dispose() {
    BackButtonInterceptor.remove(back);
    super.dispose();
  }
  _loadCounter() async {
     prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = (prefs.getBool('counter') ?? false);
    });
  }
  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('counter', counter);
    });
  }
//  Future<Null> _setBooleanPref(bool val) async {
//    await this.prefs.setBool('counter', val);
//  }

  @override
  Widget build(BuildContext context) {
  //  final appbarButtons =_getBottomBar();
//    if(counter ==true) {
//      dd = color;
//      _isRow=counter;
//    }
//    else {
//      dd = color1;
//      _isRow=counter;
//    }
    return Scaffold(
      appBar: AppBar(
        title: Text("The Mode"+counter.toString()),//style: TextStyle(color:dd[0],fontSize: 20.0),),
       // backgroundColor: dd[2],
      ),
      body: _buildBody(),
   //   bottomNavigationBar: appbarButtons,
    );
  }

  Widget _buildBody() => Row(children: <Widget>[
      Text("اضهار العملات"),
      Switch(
        onChanged:(bool value){
      setState(() {
        counter=value;

      });
      this._incrementCounter();},
        value: counter,
      ),
  ]);
       //_isRow
//         Scaffold(
//        //? Scaffold(
//    //  backgroundColor:dd[1],
//    )
//        //: Scaffold(
//    //  backgroundColor:  dd[1],
//   // ),
//  );

//  Widget _getBottomBar() {
//    return Material(
//      //color:  dd[4],
//      // color: Theme.of(context).primaryColorLight,
//      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
//        Row(
//          children: <Widget>[
//            Row(
//              children: <Widget>[
//                Radio<bool>(
//                    value: false,
//                    activeColor: dd[3],
//                    groupValue: _isRow,
//                    onChanged: (bool value) {
//                      setState(() {
//                        _isRow =value;
//                        counter =false;
//                        _incrementCounter();
//                      });}),
//                Text('LightMode',style: TextStyle(color: dd[0]),),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Radio<bool>(
//                    value: true,
//                    groupValue: _isRow,
//                    activeColor: dd[3],
//                    onChanged: (bool value) {
//                      setState(() {
//                        _isRow =value;
//                        counter=true;
//                        _incrementCounter();
//                      });}),
//                Text('DarkMode',style: TextStyle(color:dd[0])),
//              ],
//            ),
//          ],
//        ),
//      ]),
//    );
//  }

  bool back(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pushReplacement(context, new MaterialPageRoute(
        builder: (BuildContext context) => MyTabsState()));
    return true;
  }
}