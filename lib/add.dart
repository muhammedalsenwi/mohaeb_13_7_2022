import 'dart:io';
import 'package:get/get.dart';

// import 'sqlite.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mohaeb_13_7_2022/sqlitee.dart';
import 'Calculator.dart';
import 'home.dart';
import 'main.dart';
import 'SqliteExample.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

late int cust_id =0;
class Add extends StatefulWidget {
  late int i;
  Add(this.i);

  @override
  State<StatefulWidget> createState() {
    return StateAdd();
  }
}

class StateAdd extends State<Add> implements HomeContract {
  final  sql = Get.put(SqliteExample1());
  late List<Items> customers=[];
  HomeState homeState = new HomeState();
  final year = DateTime.now().year.toString();
  var month = DateTime.now().month.toString();
  var day = DateTime.now().day.toString();
 late String date;
  late bool controll=false;
  int control = 0;
  int sta=1;
 late double border;
  bool error=false,error1=false,error2=false;
 late Size Screen;
  final TextEditingController Name =  TextEditingController();
  TextEditingController Mauny = TextEditingController();
  final Phone = TextEditingController();
  final Titles =TextEditingController();
  final Gruop = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String paths='/storage/emulated/0/Market_CUS/pictures';
late  AddUserDialog  addUserDialog;
late  String selectedCustomer;
  int groupes = 0;
 late XFile? imageFile = null;
  @override
  void initState() {
    addUserDialog = new AddUserDialog(this);
    cust_id=0;
    //  if(day.length==1)day="0"+"$day";
    //  if(month.length==1) month="0"+"$month";
    String data=year+"-"+month+"-"+day;
    date = data.toString();
    border = 10.0;
    BackButtonInterceptor.add(back);
    super.initState();
  }
  @override
  void dispose() {
    BackButtonInterceptor.remove(back);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(value !="" && Mauny.text =="") {
      Mauny.text = value!;
      value = "";
    }

    Screen = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text("إضافة مبلغ"),
          backgroundColor: Colors.blue[900],
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search, color: Colors.white), onPressed: (){}),
          ],),
        body: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(width: Screen.width/1.9,
                      child:TypeAheadFormField(
                        hideOnEmpty: true,
                        textFieldConfiguration: TextFieldConfiguration(
                          autofocus: true,
                          onChanged: (value){
                            setState(() {
                              if(value.isEmpty)
                                controll=false;
                              else {
                                controll = true;
                                if (!this._formKey.currentState!.validate()) {
                                  this._formKey.currentState!.deactivate();
                                }
                              }
                            });
                          },
                          decoration: InputDecoration(hintText: "الاسـم"),//labelText: 'City'
                          controller: this.Name,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        suggestionsCallback: (pattern) {
                          if (controll) {
                            return getSuggestions(pattern);
                          } else {
                            return List.empty();
                          }
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion.toString(),style: TextStyle(),textDirection: TextDirection.rtl,),
                          );
                        },
                        transitionBuilder: (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        onSuggestionSelected: (suggestion) {
                          this.Name.text = suggestion.toString();
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'Please select a city';
                          }
                        },
                        onSaved: (value) => this.selectedCustomer = value.toString(),
                      ), ),
                    getTextField(Screen.width,"المبلغ",error1, Mauny, 3, TextInputType.number),
                    Container(
                      width: Screen.width /8,
                      child: GestureDetector(
                        child: Image(image:AssetImage("images/calendar.png")),
                        onTap:(){
                          if (Mauny.text == ""){
                            alert_cal("");
                          }else{
                            alert_cal(Mauny.text);
                            Mauny.text="";
                          }
                        },
                      ),
                    )
                  ]),
              SizedBox(height: 10.0,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getTextField(Screen.width,"التفاصيـل",error2, Titles, 1.9, TextInputType.text),
                      // addUserDialog.camera(Screen.width),
                    Container(width:Screen.width/7.5,child:
                    GestureDetector(
                      child: imageFile == null ?
                      Image.asset("images/camera.png"):
                      Image.file(File(imageFile!.path),width: 50.0, height: 50.0,
                          fit: BoxFit.cover),// == null ? Placeholder() :
                      onTap: () { alirt();},
                    )),
                    Container(
                        width: Screen.width/3,
                        child: FlatButton(
                          child: Text(date),
                          onPressed: dialog_date,
                        )),]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    getAppBorderButton(Screen.width,"عليـه",1,EdgeInsets.only(right: 10.0, top: 15.0),
                        Icons.arrow_drop_down,Colors.red),
                    getAppBorderButton(Screen.width,"لـه",-1,EdgeInsets.only(left: 10.0, top: 15.0),
                        Icons.arrow_drop_up,Colors.green),
                  ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(width: Screen.width/1,
                      margin:EdgeInsets.only(top: 20) ,
                      height: Screen.height/2,
                      color: Colors.red,
                      child: listview(),
                    )])
            ])));
  }

  void dialog_date() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2040),
    ).then<DateTime?>((value){
      if (value != null) {
        String day=value.day.toString();
        String month=value.month.toString();
        //  if(day.length==1)day="0"+"$day";
        //  if(month.length==1) month="0"+"$month";
        String data= value.year.toString()+"-"+month+"-"+day ;
        date =data;
        referch();
      }
    });
  }

  void referch() {
    setState(() {});
  }

  void alert_dialog(String name) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("إضافة الإسـم#",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontStyle.italic.toString()),
            textDirection: TextDirection.rtl),
        content: Text("إضافة الإسـم#" + name, textDirection: TextDirection.rtl),
        actions: <Widget>[
          FlatButton(
            child: Text('لا',
                style: TextStyle(color: Colors.red),
                textDirection: TextDirection.rtl),
            onPressed: () {Navigator.pop(context, 'لا');
            },),
          FlatButton(
              child: Text('نعم',
                  style: TextStyle(color: Colors.red),
                  textDirection: TextDirection.rtl),
              onPressed: () {
               Navigator.pop(context, 'نعم');
                alert_phone();
              }),
        ],
      ),
    );
  }


  void alert_phone() async{
    cust_id = await saveCust_id();
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
            title: Container(
                height: Screen.height/3.5,
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
                    ),
                    gradient: LinearGradient(
                        colors: [Colors.grey.shade100, Colors.grey.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(Name.text),
                    TextField(
                      controller: Phone,
                      keyboardType: TextInputType.phone,
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: "رقم التلفون", labelText: "رقم التلفون",icon:Icon(Icons.phone_android,color: Colors.green,)),
                      textAlign: TextAlign.center,
                    ),
                    TextField(
                      controller: Gruop,
                      decoration: InputDecoration(hintText:"عام",),
                      textAlign: TextAlign.center,
                    ),],
                )),
            actions: <Widget>[Container( height: Screen.height/20,
              child:Row(children: <Widget>[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: FlatButton(
                    child: Text('إلغاء', style: TextStyle(color: Colors.red,fontSize: 18)),
                    onPressed: () {
                      Navigator.pop(context, 'إلغاء');
                      referch();
                    },
                  ),
                ),
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: FlatButton(
                        child: Text(
                          'موافق',
                          style: TextStyle(
                              color: Colors.red,fontSize: 18
                          ),
                        ),
                        onPressed: () async{
                          await sql.getcustomers();
                          if ((Titles.text.isNotEmpty &&Phone.text.isNotEmpty) ||
                              (Titles.text.isEmpty && Phone.text.isNotEmpty) ||
                              (Titles.text.isNotEmpty && Phone.text.isEmpty)) {
                            Navigator.pop(context, 'موافق');
                            insert(cust_id, sta, date, int.parse(Mauny.text), Titles.text);
                            for(int i=0;i<sql.groups.length;i++)
                              if(Gruop.text !="" && Gruop.text == sql.groups[i].name){
                                groupes = sql.groups[i].id!;
                                 widget.i=groupes-1;
                              }
                            if(groupes == 0 && Gruop.text !=""){
                              await sql.addGroup(Group(
                                name:Gruop.text,
                                id: null,
                              ),);
                               widget.i=sql.groups.length;
                            }
                            // print(widget.i.toString()+"  gggggggggggggggggg");
                            await sql.addCustomer(
                              Customer(
                                  name: Name.text,
                                  phone: Phone.text,
                                  group_id: widget.i,
                                  currency_id: 0,
                                  id: null
                              ),
                            );
                            toest("تم الإضافة بنجاح!");
                            getCustomers(cust_id);
                            Phone.clear();
                            Gruop.clear();
                          } else {
                            Navigator.pop(context, 'موافق');
                            toest("يجب عليك ملئ حقل التفاصيل");
                            control = 1;
                            referch();
                          }
                        })),
              ],
              ),
            )]));
  }

  void toest(String title) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }

  Future alert_cal(String text) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => addUserDialog.buildAboutDialog(context,this,Screen.width, Screen.height,text),
    );
  }

  bool back(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pushReplacement(context, new MaterialPageRoute(
        builder: (BuildContext context) => MyTabsState()));
    return true;
  }

  Future<int> saveCust_id()async{
    // await sql.initDb();
    // await sql.asyncInit1();
    // await sql.asyncInit();
    // await sql.getcustomers();
    // cust_id = await sql.getMax();
    if(cust_id == null)
    {
      cust_id=0;
    }
    cust_id=cust_id+1;
    return cust_id;
  }
  Future<Null> _pickImageFromGallery() async {
    ImagePicker pc = new ImagePicker();
    final XFile? image =
    await pc.pickImage(source: ImageSource.gallery);
    setState(() => this.imageFile = image);
    setState(() {
      this.imageFile = image;
    });
  }

  Future<Null> _pickImageFromCamera() async {
    ImagePicker pc = new ImagePicker();
    final XFile? image =
    await pc.pickImage(source: ImageSource.camera);
    setState(() => this.imageFile = image);
  }

  void alirt() {
    showDialog<String>(
        context: this.context,
       builder: (BuildContext context)=>
           SimpleDialog(
               backgroundColor: Colors.grey[300],
               shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
             title: Text("أخذ الصورة",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,),
               children:<Widget>[Directionality(textDirection: TextDirection.rtl, child:
                 listTile("الكاميرا",Icons.camera_alt ,20.0,_pickImageFromCamera)),
       Directionality(textDirection: TextDirection.rtl, child:
                 listTile("الهاتف",Icons.photo,20.0, _pickImageFromGallery))
               ]));
  }
  ListTile listTile(String title,IconData icon ,double size, function){
    var listtile =  ListTile(
      leading:Icon(icon,color: Colors.black87,size: 30,),
      title: Text(title,
        style: TextStyle(fontSize: size),
      ),
      onTap: () async {
        Navigator.pop(context);
        await function();
      },);
    return listtile;
  }

  Future<List<String>> getSuggestions(String query) async {
  await sql.getcustomers();
    List<String> matches = [];
    for(int i=0;i<sql.customers.length;i++){
      matches.add(sql.customers[i].name);
    }
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  Widget listview() {
    sql.asyncInit1();
    return ListView.builder(
        itemCount: customers.length,
        itemBuilder: (_, int position) {
          return new Card(
            child: new ListTile(
                onTap: (null),
                title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[MyTabs.group_id != null ?Icon(Icons.keyboard_arrow_up,
                        color: Colors.red,size: 30):Icon(Icons.keyboard_arrow_down,color: Colors.green,size: 30),
                      Text(customers[position].mouny.toString()),
                      CircleAvatar(child: Text(customers[position].id.toString(),),radius:10,backgroundColor: Colors.blue[100],),
                      Text(customers[position].title.toString(),
                        style: TextStyle(
                            fontStyle: MyTabs.isDone ? FontStyle.italic : null,
                            color: MyTabs.isDone ? Colors.grey : null,
                            decoration: MyTabs.isDone ? TextDecoration.underline : null),),
                      Text(customers[position].datetime.toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                    ])),// new Text('${custem[position].name}'),
            color: Colors.grey[200],
            elevation: 3.0,
          );
        });
  }
  void getCustomers(int id) async{
    customers = await sql.getAllCustomers(id) as List<Items>;
    setState(() {
    });
  }

  @override
  void screenUpdate() {
    setState(() {
    });
  }

  Widget getTextField(double Screen,String inputBoxName,bool icon, TextEditingController inputBoxController,double size,TextInputType key) {
    var loginBtn = new  Container(
      width: Screen / size,
      child: TextFormField(
        cursorColor: Colors.red,
        keyboardType: key,
        autofocus: true,
        controller: inputBoxController,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:Colors.red),),
          prefixIcon:icon?Icon(Icons.error,color: Colors.red,size: 20.0):null ,
          hintText: inputBoxName,
        ),
        onChanged: (text) {
          if(text != null && (error==true||error1==true||error2==true))
            setState(() {
              if(key == TextInputType.number) {
                error1 = false;
              }
              else if(key==TextInputType.text && inputBoxName=="الاسـم")
                error=false;
              else
                error2=false;
            });
        },
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,//decoration: TextDecoration.underline,
        ),
        textAlign: TextAlign.center,
        // textDirection:key == TextInputType.number ? TextDirection.ltr: null,
      ),
    );
    return loginBtn;
  }
  Widget getAppBorderButton(double Screen,String buttonLabel,int stat,EdgeInsets margin,IconData icon,Color color){
    var loginBtn = new Container(
        width: Screen / 2.8,
        height: Screen/ 12,
        margin: margin,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(border),
                bottomRight: Radius.circular(border),
                topRight: Radius.circular(border),
                topLeft: Radius.circular(border)),
            gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade900],
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight)),
        child: FlatButton(
            onPressed: () async {
              // print(await saveCust_id().toString()+"  hhhhhhhhhhhhhhhhhhhh");
              int id = 0 ;
              sta=stat;
              cust_id = await saveCust_id();
              new Directory('/storage/emulated/0/Market_CUS').create().then((Directory d){});

//              if (controll == false) {
//                _formKey.currentState.save();
//              }
              if (control == 0) {
                if (Name.text.isNotEmpty && Mauny.text.isNotEmpty) {
                  for(int i=0;i<sql.customers.length;i++){
                    if(Name.text == sql.customers[i].name){
                      id=sql.customers[i].id!;
                      break;
                    }
                  }
                  if(id == 0)
                    alert_dialog(Name.text);
                  else{
                    insert(id, stat, date, int.parse(Mauny.text), Titles.text);
                  }
                }else if((Name.text.isEmpty && Mauny.text.isEmpty)||Name.text.isEmpty){
                  setState(() {
                    error=error1=error2=true;
                  });
                }else if(Mauny.text.isEmpty ){
                  setState(() {
                    error1=true;
                  });
                }else if(Titles.text.isEmpty)
                  setState(() {
                    error2=true;
                  });
              } else if (Name.text.isNotEmpty &&
                  Titles.text.isNotEmpty &&
                  Mauny.text.isNotEmpty) {
                if(id != 0)
                  cust_id = id;
                insert(cust_id, stat, date, int.parse(Mauny.text), Titles.text);
              } else {
                toest("يجب ملئ كل الحقول");
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(buttonLabel,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Screen/20,
                    )),
                Icon(icon,
                  size: Screen / 9,
                  color: color,
                )
              ],
            )));
    return loginBtn;
  }
  void insert(int cus_id,int state,String date,int mouny,String title) async {
    String? imagedate ;
    new Directory(paths).create().then((Directory d){});
    if(imageFile != null) {
      imagedate = DateTime.now().hour.toString()+'_'+DateTime.now().minute.toString()+'_'+DateTime.now().second.toString();
      imagedate=imagedate + '.png';
      // imageFile.copy(paths+'/'+imagedate);
      (File(imageFile!.path)).copy(paths+'/'+imagedate);
    }else {
      imagedate = null;
    };
    await sql.addTodoItem(
      Items(

        customer_id:cus_id,
        state: state,
        datetime:date,
        mouny:mouny,
        title: title,
        image:imagedate.toString(),
        id: 0,
      ),
    );
    // toest("تمت الإضافة بنجاح!");
    getCustomers(cus_id);
    Titles.clear();
    Mauny.clear();
    imageFile = null;
    control = 0;
    await sql.getcustomers();
    referch();
  }

}

