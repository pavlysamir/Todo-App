import 'package:flutter/material.dart';
import 'package:pavlyprivateapp/shared/cupit/States.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/archive_tasks/archiveScreen.dart';
import '../../modules/done_tasks/doneScreen.dart';
import '../../modules/new_tasks/newTasks_Screen.dart';

class AppTodoCubit extends Cubit<AppTodoStates>{
  late Database database;
  List<Map> Newtasks=[];
  List<Map> Donetasks=[];
  List<Map> Archiletasks=[];
  int currentindex=0;

  List<Widget> Screens=[
    newTasksScreen(),
    DoneScreen(),
    archiveScreen(),
  ];
  List<String> Texts=[
    'NEW tasks',
    'DONE tasks',
    'ARCHIVE tasks',
  ];

  AppTodoCubit(): super(AppInitialState());
  static AppTodoCubit get(context) => BlocProvider.of(context);

  void changebottomnavbar(index){
    currentindex = index;
    emit(AppChangenavBar());
    getDataFormDatabase(database);

  }



  void creatDataBase()
  {
    openDatabase
      (
        'todo.db',
        version: 1,
        onCreate: (database, version)
        {
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,data TEXT,time TEXT,status TEXT)'
          ).then((value)
          {
            print('table created');
          }).catchError((error)
          {
            print('Error when created table ${error.toString()}');
          });
        } ,
        onOpen: (database)
        {
          getDataFormDatabase(database);

          print('open database');
        }
    ).then((value) {
      database=value;
      emit(AppCreteDataBase());
    });

  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
    await database.transaction((txn) {
       txn.rawInsert(
        'INSERT INTO tasks (title, data, time, status) VALUES("$title","$date","$time","new")',
      ).then((value) {
        print('inserted successfully');
        emit(AppInsertDataBase());
        getDataFormDatabase(database);

      }).catchError((error){
        print('error when insert ${error.toString()}');
      });
      return Future(() => null);
    });

  }

  void getDataFormDatabase(database) {
    Newtasks=[];
    Donetasks=[];
    Archiletasks=[];
    emit(AppGetDataBaseLoadingstate());

    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element)
      {
        if (element['status'] == 'new') {
          Newtasks.add(element);
        }else if (element['status'] == 'done') {
          Donetasks.add(element);
        }  else if (element['status'] == 'archive') {
          Archiletasks.add(element);
        }
      });
      emit(AppGetDataBase());

    });
  }

  bool isSheetopeen=false;

  IconData icon= Icons.edit;


  void changeicon({
    required bool issheetopeenchange,
    required IconData icons,
})
  {
    isSheetopeen=issheetopeenchange;
    icon=icons;
    emit(AppChangenaviconbottomsheet());
  }

  void Updatedatabase
      (
      {required String status, required int id,}) {
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]
     ).then((value) {
       getDataFormDatabase(database);
       emit(AppUpdateDataBase());

     });
  }

  void Deletedatabase
      (
      { required int id,}) {
    database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id])
    .then((value) {
      getDataFormDatabase(database);
      emit(AppDeleteDataBase());

    });
  }




}