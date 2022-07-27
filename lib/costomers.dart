import 'package:get/get.dart';

import 'SqliteExample.dart';
import 'package:flutter/material.dart';
import 'add.dart';
import 'home.dart';
import 'main.dart';

class Costomers extends StatefulWidget {
  int i;
  Costomers(this.i);
  @override
  State<StatefulWidget> createState() => StateCostomers();
}

late int? forme = 0;
late int? aboutrme = 0;

class StateCostomers extends State<Costomers> {
 late Size screen;
  late var customer1 = [];
 final  sql = Get.put(SqliteExample1());
  @override
  void initState() {
    // sql.initDb();
    // sql.asyncInit1();
    sql.updateUI();
    getCustomer(widget.i);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size;
    return new Scaffold(
      body: Padding(
          padding: EdgeInsets.only(bottom: screen.height / 6.5),
          child: ListView.builder(
              itemCount: customer1.length,
              itemBuilder: (context, int position) {
                return new Card(
                  child: ListTile(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) => HomeScreen(
                                  customer1[position].id,
                                  customer1[position].name)),
                        );
                      },
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MyTabs.group_id != null
                                ? Icon(Icons.keyboard_arrow_up,
                                    color: Colors.red, size: 30)
                                : Icon(Icons.keyboard_arrow_down,
                                    color: Colors.green, size: 30),
                            Text(
                              customer1[position].id.toString(),
                            ),
                            CircleAvatar(
                              child:
                                  Text(customer1[position].group_id.toString()),
                              radius: 10,
                              backgroundColor: Colors.blue[100],
                            ),
                            Text(
                              customer1[position].name,
                              style: TextStyle(
                                  fontStyle: MyTabs.isDone
                                      ? FontStyle.italic
                                      : null,
                                  color:
                                  MyTabs.isDone ? Colors.grey : null,
                                  decoration: MyTabs.isDone
                                      ? TextDecoration.underline
                                      : null),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Colors.blue[900],
                                ),
                                onPressed: (){
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Add(customer1[position].id))); //widget.i)));
                                }),
                          ])), // new Text('${custem[position].name}'),
                  color: Colors.grey[200],
                  elevation: 3.0,
                );
              })),
      bottomSheet: appBar(forme!, aboutrme!),
    );
  }

  appBar(int x, int y) {
    return Padding(
        padding: EdgeInsets.only(bottom: screen.height / 15),
        child: BottomAppBar(
          color: Colors.blue[900],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HomeScreen(1, "hhhhhh")),
                    );
                  },
                  child: Text(
                    "?",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15.0,
                    ),
                  )),
              Text(
                "عليــك:=" + "$x" + " لــك:=" + "$y",
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.green,
                  size: 35.0,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => Add(widget.i)),
                  );
                },
              ),
            ],
          ),
        ));
  }

  refearsh() {
    setState(() {});
  }

  void getCustomer(int id) async {
    await sql.initDb();
    await sql.asyncInit1();
    customer1 = await sql.getAllCustomer(id);
    forme = (await getSum(-1, id));
    aboutrme = (await getSum(1, id));
    if (forme == null) forme = 0;
    if (aboutrme == null) aboutrme = 0;
    setState(() {});
  }

  Future<int?> getSum(int state, int group_id) async {
    return await sql.getSum(state, group_id);
  }
}
