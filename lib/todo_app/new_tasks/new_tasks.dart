import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/components/components.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).newTasks;
          if (tasks.length > 0) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  return buildTaskItem(tasks[index], context);
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20.0),
                    child: Container(
                      height: 1.0,
                      color: Colors.grey[300],
                      width: double.infinity,
                    ),
                  );
                },
                itemCount: tasks.length);
          } else {
            return noTasksYet();
          }
        });
  }
}
