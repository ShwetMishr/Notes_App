import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  //Singleton - it has a only one static object made
  DBHelper._();
  //instance should be static(COMPILE TIME memory allocation)
  static final  DBHelper getInstance=DBHelper._();
  static final String TABLE_NOTE="note";
  static final String COLUMN_NOTE_SNO="s_no";
  static final String COLUMN_NOTE_TITLE="title";
  static final String COLUMN_NOTE_DESC="desc";

  Database? myDB; //? it can null or nullable database // path package(use to get application directory)// and path provider package(operations on path
  // )
  //db(database) Open(path-> if exist then open else create )also known as cache management
  Future<Database> getDB() async{
    myDB??=await openDB();
    return myDB!;
    // if(myDB!=null){
    //   return myDB!;
    // }else{
    //   myDB=await openDB();
    //   return myDB!;
    // }
  }
  Future<Database> openDB () async{
    Directory appDir=await getApplicationDocumentsDirectory();
    String dbPath=join(appDir.path,"noteDB.db");
    return await openDatabase(dbPath,onCreate:(db,version){

      //Create all Your Tables Here
      db.execute("create table $TABLE_NOTE ($COLUMN_NOTE_SNO integer primary key autoincrement,$COLUMN_NOTE_TITLE text,$COLUMN_NOTE_DESC text)");
    //
    //
    //
    //   create many tables you want

    },version: 1);
  }

  /// all queries
  /// insertion
  Future<bool> addNote({required String mTitle,required String mDesc}) async{
    var db=await getDB();
    int rowsEffected=await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE:mTitle,
      COLUMN_NOTE_DESC:mDesc
    });

    return rowsEffected>0;

  }
  ///Reading all data
  Future<List<Map<String,dynamic>>> getAllNotes()async{

    var db=await getDB();
    ///Select * from note
    List<Map<String,dynamic>> mData=await db.query(TABLE_NOTE,);
    return mData;

  }

  ///update note

  Future<bool> updateNote({required String mtitle,required String mdesc, required int sno}) async{
    var db=await getDB();
   int rowsEffected =await db.update(TABLE_NOTE,{
      COLUMN_NOTE_TITLE:mtitle,
      COLUMN_NOTE_DESC:mdesc
    },where: "$COLUMN_NOTE_SNO=$sno");
   return rowsEffected>0;

}

///delete

Future<bool> deleteNote({required int sno})async {

  var db=await getDB();
  int rowsEffected=await db.delete(TABLE_NOTE,where: "$COLUMN_NOTE_SNO=?",whereArgs: ['$sno']);
  return rowsEffected>0;

}




}