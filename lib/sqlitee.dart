import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';




class Items {
   final int id;
   String? title;
   String? image;
   int? mouny;
   int? state;
   String? datetime;
   int? customer_id;
  //  Blob? imagee;
  Items({
    required this.id,
    this.title,
    this.image,
    this.mouny,
    this.state,
    this.datetime,
    this.customer_id,
  });

  Items copyWith({
    int? id,
    String? title,
    String? image,
    int? mouny,
    int? state,
    String? datetime,
    int? customer_id,
  }) {
    return Items(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      mouny: mouny ?? this.mouny,
      state: state ?? this.state,
      datetime: datetime ?? this.datetime,
      customer_id: customer_id ?? this.customer_id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    if(title != null){
      result.addAll({'title': title});
    }
    if(image != null){
      result.addAll({'image': image});
    }
    if(mouny != null){
      result.addAll({'mouny': mouny});
    }
    if(state != null){
      result.addAll({'state': state});
    }
    if(datetime != null){
      result.addAll({'datetime': datetime});
    }
    if(customer_id != null){
      result.addAll({'customer_id': customer_id});
    }
  
    return result;
  }

  factory Items.fromMap(Map<String, dynamic> map) {
    return Items(
      id: map['id']?.toInt() ?? 0,
      title: map['title'],
      image: map['image'],
      mouny: map['mouny']?.toInt(),
      state: map['state']?.toInt(),
      datetime: map['datetime'],
      customer_id: map['customer_id']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Items.fromJson(String source) => Items.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Items(id: $id, title: $title, image: $image, mouny: $mouny, state: $state, datetime: $datetime, customer_id: $customer_id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Items &&
      other.id == id &&
      other.title == title &&
      other.image == image &&
      other.mouny == mouny &&
      other.state == state &&
      other.datetime == datetime &&
      other.customer_id == customer_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      image.hashCode ^
      mouny.hashCode ^
      state.hashCode ^
      datetime.hashCode ^
      customer_id.hashCode;
  }
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
