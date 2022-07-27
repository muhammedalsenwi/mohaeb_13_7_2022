import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:math_expressions/math_expressions.dart';

import 'add.dart';


abstract class HomeContract {
  void screenUpdate();
}
late File? images =new Image(image: AssetImage("images/calendar.png")) as File;
// late XFile? images =new Image(image: AssetImage("images/calendar.png")) as FileImage;
late String? value ="";
class AddUserDialog {
  HomeContract _view;


  AddUserDialog(this._view);
  final textControllerInput = TextEditingController();
  final textControllerResult = TextEditingController();
  bool bb=false;
  bool ok=false;
  /////// the textfiled


  updateScreen() {
    _view.screenUpdate();
  }

  Widget buildAboutDialog(BuildContext context, StateAdd, double size1,double size, String text) {
    if(text != ""){
      bb = true;
      textControllerInput.text=text;
    }else if(text ==""){bb = false;
    textControllerInput.text = text;
    }
    return new AlertDialog(
      backgroundColor: Colors.grey[400],
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
      content:Container(
        height:size/1.5,
        width: size1/1.0,
        child:ListView(
          children: <Widget>[
            Container(decoration:BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
                alignment: Alignment.centerRight,
                height: size/11,
                child:Padding(padding: EdgeInsets.symmetric(horizontal:10.0),
                    child: new TextField(
                      decoration: new InputDecoration.collapsed(
                          hintText: "0",
                          hintStyle: TextStyle(
                            fontSize: 28,color: Colors.black,
                            fontFamily: 'RobotoMono',
                          )),
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'RobotoMono',
                      ),
                      textAlign: TextAlign.right,
                      controller: textControllerInput,
                      onTap: () =>
                          FocusScope.of(context).requestFocus(new FocusNode()),
                    ))),Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  // decoration: new InputDecoration.collapsed(hintText: 'mm'),
                  decoration: new InputDecoration.collapsed(hintText:null),
                  textInputAction: TextInputAction.none,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  controller: textControllerResult,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
              btn('7', Colors.white,size1),
              btn('8', Colors.white,size1),
              btn('9', Colors.white,size1),
              btnClear(size1),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: <Widget>[
              btn('4', Colors.white,size1),
              btn('5', Colors.white,size1),
              btn('6', Colors.white,size1),
              btn1("*",Colors.black12,context,StateAdd,size1),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: <Widget>[
              btn('1', Colors.white,size1),
              btn('2', Colors.white,size1),
              btn('3', Colors.white,size1),
              btn1("-",Colors.black12,context,StateAdd,size1),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: <Widget>[
              btn(".", Colors.white,size1),
              btn('0', Colors.white,size1),
              btnAC("C",Colors.white,size1),
              btn1("+",Colors.black12,context,StateAdd,size1),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: <Widget>[
              btn1("OK",Colors.black12,context,StateAdd,size1),
              btn1("/",Colors.black12,context,StateAdd,size1),
              btnEqual('=',context,StateAdd),
            ])
          ],
        ),
      ),
    );
  }
  Widget btnAC(btntext, Color btnColor,double size1) {
    return Container(
      width: size1/6.3,
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Text(
          btntext,
          style: TextStyle(
              fontSize: 28.0, color: Colors.black, fontFamily: 'RobotoMono'
          ),
        ),
        onPressed: () {
          textControllerInput.text = "";
          textControllerResult.text = "";
          bb=false;
        },
        color: btnColor,
        padding: EdgeInsets.all(10.0),
        splashColor: Colors.black,
        shape: CircleBorder(side: BorderSide()),
      ),
    );
  }
  Widget btnEqual(btnText,BuildContext context,StateAdd) {
    return GradientButton(
      child: Text(
        btnText,
        style: TextStyle(fontSize: 35.0),
      ),
      increaseWidthBy: 20.0,
      increaseHeightBy: 8.0,
      callback: () {
        if((textControllerInput.text != "" || textControllerInput.text == "") && ok ==true){
          value = textControllerInput.text.trim().toString();
          Navigator.of(context).pop();
          updateScreen();
        }
        try{
          Parser p = new Parser();
          ContextModel cm = new ContextModel();
          Expression exp = p.parse(textControllerInput.text);
          textControllerResult.text =
              exp.evaluate(EvaluationType.REAL, cm).toString();
          textControllerInput.text=textControllerResult.text;
          textControllerResult.clear();
        }catch(e){}},
      gradient: Gradients.jShine,
    );
  }
  Widget btn(btntext, Color btnColor,double size1) {
    ok=true;
    return Container(
      width: size1/6.2,
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Text(
          btntext,
          style: TextStyle(
              fontSize: 30.0, color: Colors.black, fontFamily: 'RobotoMono'
          ),
        ),
        onPressed: () {
          textControllerInput.text = textControllerInput.text + btntext;
          bb=true;
        },
        color: btnColor,
        padding: EdgeInsets.all(10.0),
        splashColor: Colors.black,
        shape: CircleBorder(side: BorderSide()),
      ),
    );
  }
  Widget btn1(btntext, Color btnColor,BuildContext context,StateAdd,double size1) {
    return Container(
      width: size1/6.3,
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Text(btntext,
            style: TextStyle(
                fontSize: size1/12.9, color: Colors.black, fontFamily: 'RobotoMono')
        ),
        onPressed: () {
          if(bb==true) {
            if(btntext=="OK"){
              if(ok==false && textControllerInput.text.length>1){
                Parser p = new Parser();
                ContextModel cm = new ContextModel();
                Expression exp = p.parse(textControllerInput.text);
                textControllerResult.text =exp.evaluate(EvaluationType.REAL, cm).toString();
                textControllerInput.text=textControllerResult.text;
                textControllerResult.clear();
                value = textControllerInput.text;
                textControllerInput.clear();
                Navigator.of(context).pop();
                updateScreen();
              }
            }else{
              textControllerInput.text = textControllerInput.text + btntext;
              bb=false;
              ok=false;
            }}else if(btntext=="OK" && textControllerInput.text.isEmpty)
            Navigator.of(context).pop();
        },
        color: btnColor,
        padding: EdgeInsets.all(10.0),
        splashColor: Colors.black,
        shape: CircleBorder(side: BorderSide()),
      ),
    );
  }

  Widget btnClear(double size1) {
    return Container(
      width: size1/6.3,
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.backspace, size:size1/12, color: Colors.black),
        onPressed: () {
          textControllerInput.text = (textControllerInput.text.length > 0)
              ? (textControllerInput.text.substring(0, textControllerInput.text.length - 1))
              : "";
          if(textControllerInput.text.isEmpty)
            bb=false;
          else
            bb=true;
        },
        color: Colors.black12,
        padding: EdgeInsets.all(10.0),
        splashColor: Colors.black,
        shape: CircleBorder(side: BorderSide()),
      ),
    );
  }

  ///////////////////////////////////////////////\




  Widget buildAlertDialog(BuildContext context) {

    return new AlertDialog(
      backgroundColor: Colors.grey[400],
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
      content:Container(
          height:MediaQuery.of(context).size.width/2.5,
          width: MediaQuery.of(context).size.height/1.0,
          child:ListView(
              children: <Widget>[
                Container(alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width/11,
                  child:Text("أخذ الصورة",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,),
                ),
                SizedBox(height: 10,),
                Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
                  // Directionality(textDirection: TextDirection.rtl, child:
                  // listTile(context,"الكاميرا",Icons.camera_alt ,20.0,pickImageFromCamera)),
                  // Directionality(textDirection: TextDirection.rtl, child:
                  // listTile(context,"الهاتف",Icons.photo,20.0, pickImageFromGallery))
                ]),
              ])),
    );
  }
  // pickImageFromGallery() async {
  //   ImagePicker pp = new ImagePicker();
  //   try{
  //     XFile? imageFile = await pp.pickImage(source: ImageSource.gallery);
  //     images = imageFile as File;
  //     updateScreen();
  //   }catch(e){print("Error");}}
  //
  // pickImageFromCamera() async {
  //   ImagePicker pp = new ImagePicker();
  //   XFile? imageFile =
  //   await pp.pickImage(source: ImageSource.camera);
  //   images = imageFile as File;
  //   updateScreen();
  // }

  ListTile listTile(BuildContext context,String title,IconData icon ,double size, function){
    var listtile =  ListTile(
      leading:Icon(icon,color: Colors.black87,size: 30,),
      title: Text(title,
        style: TextStyle(fontSize: size),
      ),
      onTap: () async {
        Navigator.of(context).pop();
        await function();
      },);
    return listtile;
  }

}