
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pavlyprivateapp/shared/constanse/constanse.dart';

import '../../shared/components/Components.dart';
import '../../shared/cupit/Cupit.dart';
import '../../shared/cupit/States.dart';

class newTasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
      return BlocConsumer<AppTodoCubit,AppTodoStates>(
        listener: (context,state){},
        builder: (context,state){
          var tasks=AppTodoCubit.get(context).Newtasks;
         return BuildconditionList(tasks: tasks);
        },

      );
   
  }
}
