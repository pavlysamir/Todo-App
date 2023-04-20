
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/Components.dart';
import '../../shared/cupit/Cupit.dart';
import '../../shared/cupit/States.dart';

class archiveScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTodoCubit,AppTodoStates>(
      listener: (context,state){},
      builder: (context,state){
        var tasks=AppTodoCubit.get(context).Archiletasks;
        return BuildconditionList(tasks: tasks);
      },

    );
  }
}
