
import 'dart:io';

import 'package:dictionary_flutter/data/word_data.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  late final Database _db;

  Future<void> init() async{
    var dirPath = await getDatabasesPath();
    final dbFile = File('${dirPath}eng_uz_dictionary.db');
      if(!await dbFile.exists()){
        final byteDate = await rootBundle.load("assets/eng_uz_dictionary.db");
        await dbFile.writeAsBytes(byteDate.buffer.asUint8List(
          byteDate.offsetInBytes,
          byteDate.lengthInBytes
        ));
      }
      _db = await openDatabase('${dirPath}eng_uz_dictionary.db',version: 1);
  }

  Future<List<WordModel>> findByUz(String query) async{
    final list = await _db.rawQuery("select * from dictionary where uzbek like \"$query%\"");
    return list.map((e) => WordModel.fromJson(e)).toList();
  }
  Future<List<WordModel>> findByEng(String query) async{
    final list = await _db.rawQuery("select * from dictionary where english like \"$query%\"");
    return list.map((e) => WordModel.fromJson(e)).toList();
  }
  Future<List<WordModel>> getAll() async{
    final list = await _db.rawQuery("select * from dictionary");
    return list.map((e) => WordModel.fromJson(e)).toList();
  }
}