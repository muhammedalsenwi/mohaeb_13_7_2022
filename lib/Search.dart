import 'package:flutter/material.dart';
import 'main.dart';
import 'sqlite.dart';


class DataSearch extends SearchDelegate<String> {
  SqliteExampleState sql = new SqliteExampleState();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [if(query != "")
      IconButton(icon: Icon(Icons.clear), onPressed: () {
        if (query != "") {
          query = "";
        }
        else {
          close(context, "");
        }
      },)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow,
      progress: transitionAnimation, color: Colors.black,),
      onPressed: () {
        close(context, "");
      },);
  }

  // @override
  // Widget buildResults(BuildContext context) {
  //   return ;
  // }

  @override
  Widget buildSuggestions(BuildContext context) {
    sql.asyncInit1();
    final suggestionList = query.isEmpty ? SqliteExampleState.customers : SqliteExampleState.customers.where((d) =>
    d.name.contains(query)|| d.id.toString().contains(query)).toList();
    return ListView.builder(itemCount: suggestionList.length, itemBuilder: (ctx, index) {
      String suggestion = suggestionList[index].name;
      final String id = suggestionList[index].id.toString();
      String qury;
      if(query=="")
        qury=" ";
      else
        qury=query;
      final style = TextStyle(color: Colors.red);
      final spans = _getSpans(id,qury, style);
      final spans1 = _getSpans(suggestion,qury, style);

      return ListTile(title: Container(decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
          ),
          gradient: LinearGradient(
              colors: [Colors.grey.shade100, Colors.grey.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[ IconButton(
                icon: Icon(MyTabs.isDone ? (Icons.arrow_drop_down):
                (Icons.arrow_drop_up)),
                color:MyTabs.isDone ? Colors.green:Colors.red,
                iconSize: 40.0,
                onPressed: () async {
                  sql.initDb();
                  // await sql.toggleCustomer(suggestionList[index]);
                  sql.updateUI();
                },),
              RichText(
                text: TextSpan(style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight:FontWeight.bold),
                    children:spans), ),
              CircleAvatar(child: Text(suggestionList[index].group_id.toString()),radius:10,backgroundColor: Colors.blue[100],),
              RichText(
                  text: TextSpan(style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight:FontWeight.bold),
                      children:spans1)),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    sql.initDb();
                  //   await sql.deletegroup(suggestionList[index]);
                    sql.updateUI();
                  })
                ,
              ]
          )),);
    });
  }
  List<TextSpan> _getSpans(String text, String matchWord, TextStyle style) {
    List<TextSpan> spans = [];
    int spanBoundary = 0;
    int x=1;
    do {
      final startIndex = text.indexOf(matchWord, spanBoundary);
      if (startIndex == -1) {
        spans.add(TextSpan(text: text.substring(spanBoundary)));
        return spans;
      }
      if (startIndex > spanBoundary) {
        spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
      }
      final endIndex = startIndex + matchWord.length;
      final spanText =text.substring(startIndex,endIndex);
      if(x==1) {
        spans.add(TextSpan(text: spanText, style: style));
        x=2;
      }else {
        spans.add(TextSpan(text: spanText));
      }
      spanBoundary = endIndex;
    } while (spanBoundary< text.length);

    return spans;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();

  }

}