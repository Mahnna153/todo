import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/cubit/states.dart';
import 'package:todo/todo_app/archived_tasks/archived_tasks.dart';
import 'package:todo/todo_app/done_tasks/done_tasks.dart';
import 'package:todo/todo_app/new_tasks/new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 1;
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done',
    'Archived',
  ];

  void changeIndex(index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  void createDataBase() {
    openDatabase(
      'DB_T0D0.db',
      version: 1,
      onCreate: (database, version) {
        print('DataBase Created :)');
        database
            .execute(
                'CREATE TABLE Tasks ( ID INTEGER PRIMARY KEY , Title TEXT , Date TEXT , Time TEXT , Status TEXT)')
            .then((value) {
          print('Table Created :) ');
        }).catchError((error) {
          print('Error : ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('DataBase Opened ?!?!?!');
      },
    ).then((value) {
      database = value;
      emit(CreateDataBaseState());
    });
  }

  Future insertToDataBase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO Tasks (Title,Date,Time,Status) VALUES ("$title","$date","$time","new")');
    }).then((value) {
      print('Inserted');
      emit(InsertDataBaseState());

      getDataFromDatabase(database);
    }).catchError((error) {
      print('Error : $error');
    });
  }

  void getDataFromDatabase(database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    await database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['Status'] == 'new') {
          newTasks.add(element);
          print(newTasks);
        } else if (element['Status'] == 'done') {
          doneTasks.add(element);
          print(doneTasks);
        } else {
          archivedTasks.add(element);
          print(archivedTasks);
        }
      });

      emit(GetDataBaseState());
    });
  }

  void upDateDataFromDatabase({
    required String status,
    required int id,
  }) async {
    await database.rawUpdate('UPDATE tasks SET Status = ? WHERE ID = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(UpDateDataBaseState());
    });
  }

  // ignore: non_constant_identifier_names
  void DeleteDataFromDatabase({
    required int id,
  }) async {
    await database
        .rawUpdate('DELETE FROM tasks WHERE ID = ?', ['$id']).then((value) {
      getDataFromDatabase(database);
      emit(DeleteDataBaseState());
    });
  }

  void changeBottomSheetState({
    required bool isShown,
    required IconData icon,
  }) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }
}
