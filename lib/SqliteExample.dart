import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:async/async.dart';
import 'package:mohaeb_13_7_2022/sqlitee.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';


class SqliteExample1  extends GetxController {
  static const DBName = 'market.db';
  static const TableName = 'customer';
  static const CUSTOMER = 'customers';
  static const GroupTable = 'group1';
  static late Database  db;
  final AsyncMemoizer memoizer = AsyncMemoizer();

  // Type db = Database;
   List<Items> todos = [];
   List<Customer> customers = [];
   List<Group> groups = [];

  // Opens a db local file. Creates the db table if it's not yet created.
  Future<void> initDb() async {
    db = Database as Database;
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, DBName);

    db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (Database db, int version) async {
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
    update();
  }
  // Retrieves rows from the db table.
  Future<void> getTodoItems() async {
    db = Database as Database;
    List jsons = await db.rawQuery('SELECT * FROM $TableName');//WHERE id < $id
    print('${jsons.length} rows retrieved from $TableName!'+jsons.toString());
    todos = jsons.map((json) => Items.fromMap(json)).toList();
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

  Future<void> addTodoItem(Items todo) async {
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
  Future<void> toggleTodoItem(Items todo) async {
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
  Future<void> deleteTodoItem(Items todo) async {
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
    update();
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
      Items(title: "title", image: "image", state: 1, datetime: "datetime", mouny: 555, customer_id: await getMax(), id: null!)
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
    result =result.map((json) => Items.fromMap(json)).toList();
    return result;
  }
}
