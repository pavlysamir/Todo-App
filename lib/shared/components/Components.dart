import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:pavlyprivateapp/shared/cupit/Cupit.dart';

Widget BuildTaskItem(Map models,context)=> Dismissible(
  key: Key(models['id'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40.0,

          child: Text(

              '${models['time']}'

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text('${models['title']}',

                style: TextStyle(

                  fontWeight: FontWeight.bold,

                  fontSize: 18.0,

                ),),

              Text('${models['data']}',

                style: TextStyle(

                  color: Colors.grey,

                ),),

            ],

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        IconButton(

          onPressed: (){

          AppTodoCubit.get(context).Updatedatabase(status: 'done', id: models['id']);

        },

          icon: Icon(Icons.check_box),

        color: Colors.green,

        ),

        IconButton(

          onPressed: (){

          AppTodoCubit.get(context).Updatedatabase(status: 'archive', id: models['id']);

        },

          icon: Icon(Icons.archive),

        color: Colors.black45,

        ),

      ],

    ),

  ),
  onDismissed: (direction){
    AppTodoCubit.get(context).Deletedatabase(id: models['id']);
  },
);

Widget BuildconditionList({required  List<Map> tasks})=>ConditionalBuilder(condition: tasks.isNotEmpty,
  builder: (context)=>ListView.separated(
      itemBuilder: (context,index)=> BuildTaskItem(tasks[index],context),
      separatorBuilder: (contex,index)=> Container(
        height: 1.0,
        width: double.infinity,
        color: Colors.grey,
      ),
      itemCount: tasks.length),
  fallback: (context)=>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu,color: Colors.black45,size: 100.0,),
            Text('No Tasks Yet, Please Add Some Tasks', style: TextStyle(color: Colors.black45,))
          ],
        ),
      ),

);