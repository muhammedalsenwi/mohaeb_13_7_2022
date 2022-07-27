import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoItem {
  int? id;
 final String title;
 final String image;
 final int mouny;
 final int state;
 final String datetime;
 final int customer_id;

  TodoItem({required this.id,required this.title,required this.image,required this.state,required this.datetime,required this.mouny,required this.customer_id});
  TodoItem.fromJsonMap(Map<String, dynamic> map)
        : id = map['id'],
        title = map['title'],
        image = map['image'],
        state = map['state'],
        datetime =map['datatime'],
        mouny = map['mouny'],
        customer_id = map['customer_id'];

  Map<String, dynamic> toJsonMap() => {
    'id': id,
    'title': title,
    'image': image,
    'state': state,
    'datatime':datetime,
    'mouny': mouny,
    'customer_id': customer_id,
  };
}
class Customer{
  int? id;
  final String name;
  final String phone;
  final int group_id;
  final int currency_id;

  Customer({required this.id,required this.name, required this.phone, required this.group_id, required this.currency_id});
  Customer.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        phone = map['phone'],
        group_id = map['group_id'],
        currency_id =map['currency_id'];

  Map<String, dynamic> toJsonMap() => {
    'id': id,
    'name': name,
    'phone': phone,
    'group_id': group_id,
    'currency_id': currency_id,

  };
}
class Group {
  int? id;
  final String name;
  Group({required this.id,required this.name});
  Group.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'];
  Map<String, dynamic> toJsonMap() => {
    'id': id,
    'name': name,
  };
}
class SqliteExample extends StatefulWidget {
  const SqliteExample({required Key key}) : super(key: key);
  @override
  SqliteExampleState createState() => SqliteExampleState();
}
late var db;
class SqliteExampleState extends State<SqliteExample> {
  static const DBName = 'market.db';
  static const TableName = 'customer';
  static const CUSTOMER = 'customers';
  static const GroupTable = 'group1';
  final AsyncMemoizer memoizer = AsyncMemoizer();
  static late Database db;
  // Type db = Database;
  static List<TodoItem> todos = [];
  static List<Customer> customers = [];
  static List<Group> groups = [];
  // Opens a db local file. Creates the db table if it's not yet created.
  Future<void> initDb() async {
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, DBName);
    db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (Database db, int version) async {
//        await db.execute('''CREATE TABLE $TableName(
//          id INTEGER PRIMARY KEY,state INTEGER NOT NULL,title TEXT,image TEXT,mouny TEXT,customer_id INTEGER,
//          datetime INTEGER)
//          '''); //  FOREIGN KEY (customer_id) REFERENCES $CUSTOMER (id))     default '0'
          await db.execute('''
        CREATE TABLE $TableName(
          id INTEGER PRIMARY KEY, 
          title TEXT,image TEXT,state INTEGER NOT NULL,mouny INTEGER,customer_id INTEGER,datatime TEXT)''');

          await db.execute('''CREATE TABLE $CUSTOMER(
          id INTEGER PRIMARY KEY,group_id INTEGER,currency_id INTEGER,name TEXT UNIQUE,
          phone TEXT)''');//REFERENCES $GroupTable(id)//FOREIGN KEY (group_id)   REFERENCES $GroupTable (id))

          await db.execute('''
        CREATE TABLE $GroupTable(id INTEGER PRIMARY KEY,name TEXT UNIQUE)''');

          await db.rawInsert('''INSERT INTO $GroupTable(name)VALUES("عام")''');
          await db.rawInsert('''INSERT INTO $GroupTable(name)VALUES("عملاء")''');
          await db.rawInsert('''INSERT INTO $GroupTable(name)VALUES("موردين")''');
        }
    );
  }
  // Retrieves rows from the db table.
  Future<void> getTodoItems() async {
    List jsons = await db.rawQuery('SELECT * FROM $TableName');//WHERE id < $id
    print('${jsons.length} rows retrieved from $TableName!'+jsons.toString());
    todos = jsons.map((json) => TodoItem.fromJsonMap(json)).toList();
  }
  Future<void> getcustomers() async {
    List json = await db.rawQuery('SELECT * FROM $GroupTable');
    List jsons = await db.rawQuery('SELECT * FROM $CUSTOMER ');//WHERE group_id = $id
    print('${json.length} rows retrieved from $CUSTOMER!'+jsons.toString());
    groups = json.map((json) => Group.fromJsonMap(json)).toList();
    customers = jsons.map((json) => Customer.fromJsonMap(json)).toList();
  }
  // Inserts records to the db table.
  // Note we don't need to explicitly set the primary key (id), it'll auto
  // increment.

  Future<void> addTodoItem(TodoItem todo) async {
    await db.transaction(
          (Transaction txn) async {
        int id = await txn.rawInsert('''
          INSERT INTO $TableName
            (title,image,mouny,customer_id,state, datatime)
          VALUES
            (
              "${todo.title}",
              "${todo.image}",
               ${todo.mouny},
              ${todo.customer_id},
              ${todo.state}, 
              "${todo.datetime}"
            )''');
        print('Inserted todo item with id=$id.');
      },
    );
  }
  Future<void> addGroup(Group group) async {
    await db.transaction(
          (Transaction txn) async {
        int id = await txn.rawInsert('''
          INSERT INTO $GroupTable
            (name)
          VALUES
            (
              "${group.name}"
            )''');
        print('Inserted todo item with id=$id.');
      },
    );
  }
  Future<void> addCustomer(Customer customer) async {
    await db.transaction(
          (Transaction txn) async {
        int id = await txn.rawInsert('''
          INSERT INTO $CUSTOMER
            (name,phone,currency_id,group_id)
          VALUES
            (
              "${customer.name}",
              "${customer.phone}", 
               ${customer.currency_id},
               ${customer.group_id}
            )''');
        print('Inserted todo item with id=$id.');
      },
    );
  }
  // Updates records in the db table.
  Future<void> toggleTodoItem(TodoItem todo) async {
    int count = await db.rawUpdate(
      /*sql=*/ '''UPDATE $TableName
                    SET state = ?
                    WHERE id = ?''',
      /*args=*/ [todo.state, todo.id],
    );
    print('Updated $count records in db.');
  }
  Future<void> toggleCustomer(Customer customer) async {
    int count = await db.rawUpdate(
      '''UPDATE $CUSTOMER
              SET name = ?
              WHERE id = ?''',
      [customer.name, customer.id],
    );
    print('Updated $count records in db.');
  }
  // Deletes records in the db table.
  Future<void> deleteTodoItem(TodoItem todo) async {
    final count = await db.rawDelete('''
        DELETE FROM $TableName
        WHERE id = ${todo.id}
      ''');
    print('Updated $count records in db.');
  }
  Future<void> deleteCustomer(Customer customer) async {
    final count = await db.rawDelete('''
        DELETE FROM $CUSTOMER
        WHERE id = ${customer.id}
      ''');
    print('Updated $count records in db.');
  }
  Future<void> deletegroup(Group group) async {
    final count = await db.rawDelete('''
        DELETE FROM $GroupTable
        WHERE id = ${group.id}
      ''');
    print('Updated $count records in db.');
  }

  Future<bool> asyncInit() async {
    await memoizer.runOnce(() async {
      await initDb();
      await getTodoItems();
    });
    return true;
  }

  Future<bool> asyncInit1() async {
    await memoizer.runOnce(() async {
      await initDb();
      await getcustomers();
    });
    return true;
  }
  Future<void> updateUI() async {
    await getTodoItems();
    await getcustomers();
    setState(() {});
  }
  @override
  Widget build(BuildContext context){
    return Container();
  }
  Future<int> getMax() async{
    print(groups.length.toString()+"  llllllllllll");
    print(customers.length.toString()+"  cccccccccccccccccc");
    print(todos.length.toString()+"  ttttttttttttttttttt");
    var dbClient = await  db;
    var sql = "SELECT MAX(id) FROM $CUSTOMER";

    return await Sqflite.firstIntValue(await dbClient.rawQuery(sql))!;
  }
  Future<int?> getSum(int state,int id) async{
    var dbClient = await  db;
    var sql = "SELECT SUM(mouny) FROM $TableName WHERE state= $state AND customer_id =("
        "SELECT id FROM $CUSTOMER WHERE group_id = $id)";
    return  Sqflite.firstIntValue(await dbClient.rawQuery(sql)) ;
  }
  Future<int?> getCount() async{
    var dbClient = await  db;
    await db.rawInsert('''INSERT INTO $TableName(title, image, state, datatime, mouny, customer_id)VALUES("tttt","iimmm",1,"jjkkkk",155,1)''');
    await addTodoItem(
      TodoItem(title: "title", image: "image", state: 1, datetime: "datetime", mouny: 555, customer_id: await getMax(), id: null)
    );
    print("hhhhhhhhhhhhhhhhhhhhhkkkkkkkkkk");
    var sql = "SELECT COUNT(*) FROM $GroupTable";
    return  Sqflite.firstIntValue(await dbClient.rawQuery(sql)) ;
  }
  Future<List> getAllCustomer(int id) async{
    var dbClient = await  db;
    var sql1 = "SELECT * FROM $CUSTOMER WHERE group_id = $id";
    List result = await dbClient.rawQuery(sql1);
    result =result.map((json) => Customer.fromJsonMap(json)).toList();
    return result;
    // return result.toList();
  }
  Future<List> getAllCustomers(int id) async{
    var dbClient = await  db;
    var sql = "SELECT * FROM $TableName WHERE customer_id = $id";
    List result = await dbClient.rawQuery(sql);
    result =result.map((json) => TodoItem.fromJsonMap(json)).toList();
    return result;
  }

/*
  CREATE VIEW cus_curr as SELECT a.b_id as ID, a.b_name as name,a.gsm gsm ,a.c_name g_name ,
      sum(case when not(a.[in] = 1 and (a.t_cus_id!=a.b_id or a.t_cus_id is null))then a.out else 0 end )
  *1.0 as cr ,
      sum ( case when a.[in] = 1 and (a.t_cus_id!=a.b_id or a.t_cus_id is null)then a.out else 0 end)
  *1.0 as db ,
      ifnull( (sum(case when (a.t_cus_id=a.b_id) then -1*a.out else(a.[in]*a.out) end)),0)
  AS balance,
      ifnull( a.d_name, (select name from currency where id=0))
  curr ,a.curr_id as curr_id,a.gsm as phone ,
      max(strftime('%Y-%m-%d',
  substr(a.date_,7,4)||'-' ||substr(a.date_,4,2)||'-'||substr(a.date_,1,2) )) d ,
  ( (select julianday(strftime('%Y-%m-%d','now'))
  -julianday(max(strftime('%Y-%m-%d',substr(c.date_,7,4)||'-' ||substr(c.date_,4,2)||'-'||substr(c.date_,1,2) )))
  from transactions as c where (c.cus_id=a.b_id or c.t_cus_id=a.b_id)) ) as days_late, ifnull(max(a.a_id),0)
  max_id FROM cus_tr_curr_view a GROUP BY a.b_name, a.b_id,a.d_name,a.d_id union select a.id,a.name,a.gsm,
  (select name from groups where id=a.g_id)
  g_name,0,0,0, (select name from currency where id=0),0,
  a.gsm,strftime('%Y-%m-%d','now'),0,0 from customers a where a.id not in (select distinct b_id
  from cus_tr_curr_view) ORDER BY d DESC,max_id desc
  */
}