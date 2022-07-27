import 'dart:convert';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'sqlite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Calculator.dart';
import 'add.dart';
import 'main.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';


class HomeScreen extends StatefulWidget {
  int id;String name;
  HomeScreen(this.id,this.name);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}
late var customers=[];

class HomeState extends State<HomeScreen> implements HomeContract {
  String paths='/storage/emulated/0/Market_CUS/pictures';
  late Size screen;
 late SqliteExampleState sql = new SqliteExampleState();
  late AddUserDialog  addUserDialog;

  var imageFile;

  @override
  void initState() {
    addUserDialog = new AddUserDialog(this);
    getCustomers(widget.id);
    BackButtonInterceptor.add(back);
    super.initState();
  }
  @override
  void dispose() {
    BackButtonInterceptor.remove(back);
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    screen = MediaQuery.of(context).size;
    sql.asyncInit();
    return Scaffold(
      appBar: AppBar(title:Text(widget.name),
      backgroundColor: Colors.blue[900],),
      body: ListView.builder(
          padding: EdgeInsets.only(bottom: screen.height/10),
          itemCount: customers.length,
          itemBuilder: (_, int position) {
            return new Card(
              child: new ListTile(
                  onTap: (){alert_dialog(widget.name);},
                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[ MyTabs.group_id != null ?
                     Icon(Icons.keyboard_arrow_up,color: Colors.red,size: 30)
                     :Icon(Icons.keyboard_arrow_down,color: Colors.green,size: 30),
                      Text(customers[position].mouny.toString()),
                      CircleAvatar(child: Image.file(File(paths+'/'+customers[position].image)),radius:15,),
                      Text(customers[position].title,
                        style: TextStyle(
                            fontStyle: MyTabs.isDone ? FontStyle.italic : null,
                            color: MyTabs.isDone ? Colors.grey : null,
                            decoration: MyTabs.isDone ? TextDecoration.underline : null),
                      ),
                        Text(MyTabs.group_id.toString()),
                      ])),
              color: Colors.grey[200],
              elevation: 3.0,
              );
          }),
      bottomSheet: appBar(5000, 5000),
    );
  }

   appBar(int x,int y){
    return Padding(padding:EdgeInsets.only(bottom:screen.height/15) ,
        child:BottomAppBar(
         color: Colors.blue[900],
         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
            FlatButton(onPressed:(){alert_dialog("hhhhh");},
             child: Text("?",style: TextStyle(color: Colors.grey[400],fontSize: 15.0,),)),
             Text("عليــك:=" + "$x" + " لــك:=" + "$y",
               style: TextStyle(color: Colors.white),),
             IconButton(icon: Icon(
               Icons.add_circle_outline, color: Colors.green,
               size: 35.0,)
               , onPressed: () {
                 Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => Add(widget.id)),
                 );
               },),
         ],),));
  }
  refearsh() {
    setState(() {
    });
  }
  void alirt() {
    showDialog<String>(
        context: this.context,
        builder: (BuildContext context)=>addUserDialog.buildAlertDialog(context));
  }

  void alert_dialog(String title) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.grey[300],
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
        content:Directionality(
          textDirection: TextDirection.rtl,
          child:Container(height: screen.height/3,width: screen.width/1,
              child:Column(children: <Widget>[
                Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                SizedBox(height: 2,),
          Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
          StateAdd().getTextField(screen.width,"المبلغ",false, StateAdd().Mauny,3.4, TextInputType.number),
            Container(
              width: screen.width /13,
             child: GestureDetector(
                child: Image(image:AssetImage("images/calendar.png")),
                onTap:(){
                  if (StateAdd().Mauny.text == ""){
                    alert_cal("");
                  }else{
                    alert_cal(StateAdd().Mauny.text);
                    StateAdd().Mauny.text="";
                  }
                },
              ),
            ),
         FlatButton(
                child: Text("hhhh-jj-gg"),
                onPressed: StateAdd().dialog_date,
              ),],),
            //SizedBox(height: 10.0,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StateAdd().getTextField(screen.width,"التفاصيـل",false, StateAdd().Titles,2, TextInputType.text),
                  Container(width:screen.width/8,child:
                  GestureDetector(
                    child: imageFile == null ?
                    Image.asset("images/camera.png"):
                    Image.file(imageFile),//imageFile == null ? Placeholder() :
                    onTap: () { alirt();},
                  )),]),
          SizedBox(height: screen.height/15,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("5555555"),//StateAdd().getAppBorderButton(screen.width,"عليـه",1,EdgeInsets.only(right: 10.0, top: 15.0),
                     // Icons.arrow_drop_down,Colors.red),
                Text("5555555"), //StateAdd().getAppBorderButton(screen.width,"لـه",-1,EdgeInsets.only(left: 10.0, top: 15.0),
                      //Icons.arrow_drop_up,Colors.green),
              ]),

         ])),),
//        actions: <Widget>[
//          FlatButton(
//            child: Text('لا',
//                style: TextStyle(color: Colors.red),),
//            onPressed: () {
//              Navigator.pop(context, 'لا');
//            },),
//          FlatButton(
//              child: Text('نعم',
//                  style: TextStyle(color: Colors.red),),
//              onPressed: () {
//                Navigator.pop(context, 'نعم');
//              }),
//        ],
      ),
    );
  }

Future alert_cal(String text) async {
  showDialog(
    context: context,
    builder: (BuildContext context) => addUserDialog.buildAboutDialog(context,this,screen.width, screen.height,text),
  );
}


  bool back(bool stopDefaultButtonEvent, RouteInfo info) {
       Navigator.pushReplacement(context, new MaterialPageRoute(
        builder: (BuildContext context) => MyTabsState()));
    return true;
  }

 void getCustomers(int id) async{
    customers= await sql.getAllCustomers(id);
    setState(() {
    });
  }

  @override
  void screenUpdate() {
  setState(() {
    });
  }
}
//class LocalLoader {
//  Future<String> loadLocal() async {
//    return await rootBundle.loadString('assets/help.html');
//  //return await inAppWebViewController.loadFile("assets/index.html");
//  }
//}