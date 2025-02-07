import 'package:flutter/material.dart';
import 'package:todo/cubit/cubit.dart';

Widget defButton({
  Color bgColor = Colors.blue,
  double width = double.infinity,
  bool isUpper = true,
  double radius = 5.0,
  required String text,
  required Function function,
  double height = 40.0,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          function();
        },
      ),
    );

// Widget defFormField({
//   //required context,
//   required TextEditingController? controller,
//   required String label,
//   required IconData? prefix,
//   String? initialValue,
//   TextInputType? keyboardType,
//   Function(String)? onSubmit,
//   onChange,
//   onTap,
//   required String? Function(String?) validate,
//   bool isPassword = false,
//   bool enabled = true,
//   IconData? suffix,
//   suffixPressed,
// }) =>
//     TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       obscureText: isPassword,
//       textAlign: TextAlign.start,
//       onFieldSubmitted: onSubmit,
//       enabled: enabled,
//       onChanged: onChange,
//       onTap: onTap,
//       validator: validate,
//       textCapitalization: TextCapitalization.words,
//       textAlignVertical: TextAlignVertical.center,
//       //style: Theme.of(context).textTheme.bodyText1,
//       initialValue: initialValue,
//       //textCapitalization: TextCapitalization.words,
//       decoration: InputDecoration(
//         fillColor: Colors.white,
//         filled: true,
//         label: Text(label),
//         border: const OutlineInputBorder(),
//         prefixIcon: Icon(
//           prefix,
//         ),
//         suffixIcon: suffix != null
//             ? IconButton(onPressed: suffixPressed, icon: Icon(suffix))
//             : null,
//       ),
//     );

Widget defAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(title ?? ''),
      titleSpacing: 5.0,
      actions: actions,
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key('${model['ID']}'),
      onDismissed: (direction) => AppCubit.get(context).DeleteDataFromDatabase(
        id: model['ID'],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['Time']}'),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['Title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    '${model['Date']}',
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .upDateDataFromDatabase(status: 'done', id: model['ID']);
              },
              icon: const Icon(Icons.check_circle),
              color: Colors.green,
              iconSize: 30.0,
            ),
            const SizedBox(
              width: 10.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).upDateDataFromDatabase(
                    status: 'archived', id: model['ID']);
              },
              icon: const Icon(Icons.archive),
              color: Colors.grey,
              iconSize: 30.0,
            ),
          ],
        ),
      ),
    );

Widget noTasksYet() => const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100.0,
            color: Colors.grey,
          ),
          Text(
            'No Tasks Yet :( , PLS Add Some Tasks.',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
        ],
      ),
    );

Widget divider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Container(
        height: 1.0,
        color: Colors.grey,
      ),
    );

void navigateTo(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigateAndKill(context, widget) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => widget), (route) => false);
}
