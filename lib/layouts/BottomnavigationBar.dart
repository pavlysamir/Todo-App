import 'dart:ffi';


import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pavlyprivateapp/shared/cupit/Cupit.dart';
import 'package:pavlyprivateapp/shared/cupit/States.dart';
import 'package:sqflite/sqflite.dart';

import '../modules/archive_tasks/archiveScreen.dart';
import '../modules/done_tasks/doneScreen.dart';
import '../modules/new_tasks/newTasks_Screen.dart';
import '../shared/constanse/constanse.dart';

class BottomnavigationBar extends StatelessWidget {



  var titlecontroller= TextEditingController();
  var timecontroller= TextEditingController();
  var datecontroller= TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> AppTodoCubit()..creatDataBase(),
      child: BlocConsumer<AppTodoCubit,AppTodoStates>(
        listener: (context,state){
          if(state is AppInsertDataBase){
            Navigator.pop(context);
          }
        },
        builder: (context,state)
        {
          AppTodoCubit cupitt= AppTodoCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cupitt.Texts[cupitt.currentindex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cupitt.isSheetopeen) {
                  if (formkey.currentState!.validate()) {
                    cupitt.insertToDatabase(title: titlecontroller.text,
                        time: timecontroller.text,
                        date: datecontroller.text);
                    cupitt.changeicon(issheetopeenchange: false, icons: Icons.edit);
                  }
                }
                else {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Form(
                    key: formkey,
                    child: Container(
                      color: Colors.grey[100],
                      padding: const EdgeInsetsDirectional.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'title must not be empty';
                              }
                              return null;
                            },
                            controller: titlecontroller,
                            decoration: const InputDecoration(
                              labelText: 'task title',
                              prefixIcon: Icon(Icons.title),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 15.5,
                          ),
                          TextFormField(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                timecontroller.text =
                                    value!.format(context).toString();
                              });
                            },
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'time must not be empty';
                              }
                              return null;
                            },
                            controller: timecontroller,
                            decoration: const InputDecoration(
                              labelText: 'time',
                              prefixIcon: Icon(Icons.access_time_filled),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                          const SizedBox(
                            height: 15.5,
                          ),
                          TextFormField(
                            onTap: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2023-05-01'))
                                  .then((value) {
                                datecontroller.text =
                                    DateFormat.yMMMd().format(value!);
                              });
                            },
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'time must not be empty';
                              }
                              return null;
                            },
                            controller: datecontroller,
                            decoration: const InputDecoration(
                              labelText: 'date',
                              prefixIcon: Icon(Icons.calendar_month),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                        ],
                      ),
                    ),
                  ))
                      .closed
                      .then((value) {
                    cupitt.changeicon(icons: Icons.edit, issheetopeenchange: false);

                  });
                  cupitt.changeicon(icons: Icons.add, issheetopeenchange: true);
                }
              },
              child: Icon(cupitt.icon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'archive',
                ),
              ],
              currentIndex: cupitt.currentindex,
              onTap: (index) {
                cupitt.changebottomnavbar(index);

              },
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataBaseLoadingstate,//tasks.isNotEmpty,
              builder: (context) => cupitt.Screens[cupitt.currentindex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            )
          ,
          );
        }

      ),
    );
  }

}


