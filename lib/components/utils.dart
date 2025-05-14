import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color modeColor(BuildContext context, Color light, Color dark) =>
    isDark(context) ? dark : light;

Widget platformWidget({required Widget android, required Widget ios}) {

  if (Platform.isIOS || Platform.isMacOS) {
    return ios;
  }
  return android;
}

String? validateRequired(String value, String name, {int? minLength}) {
  if (value == null || value.trim() == '') {
    return '$name is required';
  }

  if (minLength != null && value.length < minLength) {
    return '$name requires at least $minLength characters';
  }

  return null;
}


String? validateEmail(String email, {String label = 'Email'}) {
  if (email == null || email.trim() == '') {
    return '$label is required';
  }
  email = email.trim();
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern as String);
  if (!regex.hasMatch(email)) {
    if (email.indexOf('@') > -1) {
      String username = email.substring(0, email.indexOf('@'));
      if (username.endsWith('.')) {
        return 'Email username cannot end with a period';
      }
    }
    return 'Enter a valid $label address';
  }

  return null;
}

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }
}

String? validatePassword(String? password) {
  if (password == null || password == '') {
    return 'Password is required';
  } else if (password.length < 8) {
    return 'Password must be 8 or more characters';
  } else if (['password', 'Password', '12345', '123456', '12345678']
      .contains(password)) {
    return 'Use a more secure (strong) password';
  }

  return null;
}

showPlatformDialog<T>({
  BuildContext? context,
  Widget? title,
  Widget? content,
  Widget? accept,
  Widget? reject,
  Function? onAccept,
  Function? onReject,
}) async {

  if (Platform.isIOS || Platform.isMacOS) {
    return showCupertinoDialog<T>(
      context: context!,
      useRootNavigator: true,
      builder: (context) {
        return CupertinoAlertDialog(
          scrollController: ScrollController(),
          actionScrollController: ScrollController(),
          title: title,
          content: content,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: false,
              isDestructiveAction: true,
              onPressed: () {
                if (onReject is Function) {
                  onReject();
                } else {
                  // App.pop(false);
                }
              },
              child: reject!,
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              isDestructiveAction: false,
              onPressed: () {
                if (onAccept is Function) {
                  onAccept();
                } else {
                  // App.pop(true);
                }
              },
              child: accept!,
            ),
          ],
        );
      },
    );
  }

  /// This builds material date picker in Android
  void buildMaterialDatePicker(
      {required BuildContext context, required var date}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    if (picked != null && picked != date) {
      date(DateFormat.yMMMEd().format(picked));
    }
  }

  double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  void buildCupertinoDatePicker(
      {required BuildContext context, required var date}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Theme(
              data: ThemeData.light(),
              child: SizedBox(
                height: getHeight(context) / 3,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  backgroundColor: Theme.of(context).cardColor,
                  onDateTimeChanged: (picked) {
                    if (picked != date) {
                      date(DateFormat.yMMMEd().format(picked));
                    }
                  },
                  initialDateTime: DateTime.now(),
                  minimumYear: 2000,
                  maximumYear: 2025,
                ),
              ));
        });
  }

// ignore: unused_element
  Future pickDate(
      {required BuildContext context,
      required ValueChanged<String> onChange}) async {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context: context, date: onChange);
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker;
      case TargetPlatform.iOS:
        return buildMaterialDatePicker(context: context, date: onChange);
    }
  }

  return showDialog<T>(
    context: context!,
    useRootNavigator: true,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: title,
        scrollable: true,
        content: content,
        actions: <Widget>[
          const SizedBox(height: 6,),
          ElevatedButton(
            onPressed: () {
              if (onReject is Function) {
                onReject();
              } else {
                // App.pop(false);
              }
            },
            child: reject!,
          ),
          const SizedBox(height: 8,),
          ElevatedButton(
            onPressed: () {
              if (onReject is Function) {
                onReject();
              } else {
                // App.pop(false);
              }
            },
            child: reject,
          ),
        ],
      );
    },
  );
}