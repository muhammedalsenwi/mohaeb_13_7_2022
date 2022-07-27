import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'SqliteExample.dart';
import 'package:flutter/material.dart';
import 'Search.dart';
import 'add.dart';
import 'costomers.dart';
import 'settengs.dart';
import 'package:shared_preferences/shared_preferences.dart';

late int group_length =0;
void main() async{
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyTabsState(),//MyTabs(),
    // home: const MyHomePage(title: 'Flutter Demo Home Page'),
  ));
}

class MyTabsState extends StatefulWidget {
  @override
  MyTabs createState() => new MyTabs();
}
class MyTabs extends State<MyTabsState> with TickerProviderStateMixin {//Single
  final sql = Get.put(SqliteExample1());

  late TabController controller;
  static int group_id = 0;
  static bool isDone = false;
  List<ListTile>alert=[];
  List<String>titles=[];
  List<Widget>pages = [];
  bool stru=false;
  late SharedPreferences _prefs;



  @override
  void initState(){
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._prefs = prefs);
        _loadBooleanPref();
      });
    sql.asyncInit1();
    group_length = sql.groups.length;
    // refresh(true);
    if(group_length >0) {
      for (int i = pages.length; i <= group_length; i++) {
        if (group_length > pages.length) {
          pages.add(Costomers(i));
          titles.add(sql.groups[i].name);
        }
      }
    }else{
      group_length =3;
      for (int i = 0; i < group_length; i++) {
        pages.add(Costomers(i));
      }
      titles.add("عام");
      titles.add("سعودي");
      titles.add("دولار");
    }
    controller = new TabController(length:group_length,vsync:this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _loadBooleanPref() {
    setState(() {
      this.stru = this._prefs.getBool('counter') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    sql.getcustomers();
    group_length=sql.groups.length;
    controller.addListener(() {
      setState(() {});
    });
    group_id=controller.index;
    return DefaultTabController(length:group_length, child:
    Scaffold(
        appBar: appBar(titles[group_id]),
        body: Container(
          child: TabBarView(
            physics: ScrollPhysics(),
            controller: controller,
            children:pages,
          ),
        ),
        drawer:Padding(//stru?null:
          padding: EdgeInsets.only(top: 25.0),
          child: drawer(),
        )
    ));
  }

  AppBar appBar(String title) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.blue[900],
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: () {
          showSearch(context: context, delegate: DataSearch());
        }),
        IconButton(
          icon: Icon(Icons.arrow_drop_down_circle),
          onPressed: () {
            alirt();
          },
        )
      ],);
  }

  Drawer drawer() {
    return Drawer(child:ListView(
      children: <Widget>[
        mnuelist("إضافة مبلغ", Icons.add, Colors.green, Add(1)),
        mnuelist("تقرير-إجمالي المبالغ", Icons.settings, Colors.green,
            Costomers(1)),
        mnuelist("تقرير-تفاصيل كل المبالغ", Icons.settings, Colors.green,
            Costomers(1)),
        mnuelist("تقرير-إجمالي المبالغ شهريا", Icons.settings, Colors.green,
            Costomers(1)),
        mnuelist("تقرير-إجمالي التصنيفات", Icons.settings, Colors.green,
            Costomers(1)),
        mnuelist(
            "حفظ نسخة احتياطية", Icons.settings, Colors.green, Costomers(1)),
        mnuelist("إسترجاع قاعدة البيانات", Icons.settings, Colors.green,
            Costomers(1)),
        mnuelist("جوجل دريف ", Icons.settings, Colors.green, Costomers(1)),
        // mnuelist("إعدادات", Icons.settings, Colors.green, Settings()),
        mnuelist("للتواصل والدعم", Icons.share, Colors.green, Costomers(1)),
        mnuelist("حول البرنامج", Icons.share, Colors.green, Costomers(1)),
        mnuelist("مشاركة البرنامج", Icons.share, Colors.green, Costomers(1)),
        mnuelist("خروج", Icons.exit_to_app, Colors.green, Costomers(1))
      ],
    ),
    );
  }

  ListTile mnuelist(String title, IconData lead, Color c, var to_class) {
    return ListTile(
      title:Card(child:Row(children: <Widget>[
        Icon(lead, color: c,),
        SizedBox(width: MediaQuery.of(context).size.width/20,),
        Text(title,
          style: new TextStyle(fontStyle: FontStyle.normal, fontSize: 20),
        ),])),
      onTap: () {
        setState(() {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext) {
            return to_class;
          }));
        });},
    );
  }
  void alirt() {
    refresh(false);
    showDialog<String>(
        context: this.context,
        builder: (BuildContext context) =>
            SimpleDialog(
                children: alert));
  }

  void restart(String title, int index) {
    if (!controller.indexIsChanging) {
      controller.animateTo(index);
    }
    Navigator.pop(context, title);
  }

  ListTile listTile(Icon icons, String title, double size, function, String,
      int x) {
    var listtile = new ListTile(
      leading: icons,
      title: Text(title,
        style: TextStyle(fontSize: size),
      ),
      onTap: () {
        function("jj", x);
      },);
    return listtile;
  }

  void refresh(bool contrl) async{
    await sql.initDb();
    await sql.getcustomers();
    group_length= await sql.groups.length;
    if(contrl==true) {
      controller = new TabController(length: sql.groups.length, vsync: this);
    }
    setState(() {
      for (int i = alert.length; i < group_length; i++) {
        if (group_length > pages.length) {
          pages.add(Costomers(i));
        }
        alert.add(listTile(
            Icon(Icons.account_circle), sql.groups[i].name,
            23.0, restart, "", i));}

    });

  }

}



//////////////////////////
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() async {
      //
      // Fluttertoast.showToast(
      //   msg: group_length.toString(),
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1);
      _counter++;
    });
  }
  @override
  Future<void> setState(VoidCallback fn) async {
    var sql=await SqliteExample1();
    await sql.initDb();
    await sql.getcustomers();
    group_length=await sql.groups.length;
    super.setState(fn);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}