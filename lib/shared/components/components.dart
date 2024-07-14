import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../style/icon_broken.dart';

navigateTo(context, widget, {bool backOrNo = true}) =>
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => widget), (route) {
      return backOrNo;
    });

TextButton defaultTextButton({
  required var onPress,
  required String text,
}) =>
    TextButton(onPressed: onPress, child: Text(text.toUpperCase()));

Widget defaultButton({
  double width = double.infinity,
  Color color = Colors.blue,
  required var function,
  required String text,
}) =>
    Container(
      width: width,
      color: color,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultFormFeild({
  required TextEditingController controller,
  required TextInputType inputType,
  required String labelText,
  required IconData prefixIcon,
  required var validat,
  bool isPassword = false,
  bool readOnly = false,
  var inSubmit,
  var onChanged,
  var suffixOnPressed,
  Function()? onTap,
}) =>
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixOnPressed == null
            ? null
            : IconButton(
                icon: isPassword
                    ? const Icon(Icons.visibility_off_outlined)
                    : const Icon(Icons.visibility_outlined),
                onPressed: suffixOnPressed),
      ),
      keyboardType: inputType,
      obscureText: isPassword,
      onFieldSubmitted: inSubmit,
      onChanged: onChanged,
      validator: validat,
      onTap: onTap,
      readOnly: readOnly,
    );

showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { succes, error, warning }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.succes:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}




defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) =>
    AppBar(
   backgroundColor: Colors.white,
    title: title == null ? null : Text(title.toString()),
      titleSpacing: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(IconBroken.Arrow___Left_2),
      ),
      actions: actions,
    );
