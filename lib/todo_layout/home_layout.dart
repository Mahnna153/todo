import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

class HomeLayOutScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
        if (state is InsertDataBaseState) {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        final items = <Widget>[
          const Icon(Icons.menu, size: 30),
          const Icon(Icons.check_circle_outline, size: 30),
          const Icon(Icons.archive_outlined, size: 30),
        ];

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
          ),
          body: cubit.screens[cubit.currentIndex],

          ////////////////////////////////////////////////////////////

          floatingActionButton: FloatingActionButton(
            child: Icon(
              cubit.fabIcon,
              color: Colors.white,
            ),
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState!.validate()) {
                  AppCubit.get(context)
                      .insertToDataBase(
                          title: titleController.text,
                          date: dateController.text,
                          time: timeController.text)
                      .then((value) {
                    titleController.clear();
                    dateController.clear();
                    timeController.clear();
                  });
                }
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet(
                      (context) {
                        ///////////////////////
                        return Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: titleController,
                                    keyboardType: TextInputType.text,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'title must not be empty :(';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Title :)',
                                      prefixIcon: Icon(Icons.title),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'date must not be empty :(';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2022-03-12'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Date :)',
                                      prefixIcon: Icon(Icons.calendar_today),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                    controller: timeController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Time must not be empty :(';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context);
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Time :)',
                                      prefixIcon:
                                          Icon(Icons.watch_later_outlined),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        //////////////////////
                      },
                      elevation: 15.0,
                    )
                    .closed
                    .then((value) {
                      cubit.changeBottomSheetState(
                          isShown: false, icon: Icons.edit);
                    });
                cubit.changeBottomSheetState(isShown: true, icon: Icons.add);
              }
            },
          ),

          /////////////////////////////////////////////////////////////

          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            child: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: Colors.cyanAccent,
              animationCurve: Curves.easeInOut,
              color: Colors.cyan,
              animationDuration: const Duration(milliseconds: 300),
              height: 60.0,
              index: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: items,
            ),
          ),
        );
      }),
    );
  }
}
