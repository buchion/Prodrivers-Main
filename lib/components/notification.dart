// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

// import 'package:prodrivers/components/utils.dart';
// import '../../main.dart';

class Notification extends StatefulWidget {
  final CancelFunc? cancelFunc;
  final String? content;
  final Widget? action;
  final int type;
  final bool? showClose;
  

  const Notification({super.key, 
    this.cancelFunc,
    this.action,
    this.type = 1,
    this.showClose = true,
    this.content = '',
  });

  const Notification.info(
      {super.key, 
      this.cancelFunc,
      this.content,
      this.action,
      this.showClose})
      : type = 2;

  const Notification.error(
      {super.key, 
      this.cancelFunc,
      this.content,
      this.action,
      this.showClose})
      : type = 3;

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  Color color = Colors.teal;

  @override
  void initState() {
    super.initState();

    if (widget.type == 2) {
      color = Colors.black;
    } else if (widget.type == 3) {
      color = Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return 
      SizedBox(
        width: .8 * width,
        child: Row(
          children: <Widget>[
            Expanded(
              child: 
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: const Color(0xFF054C87),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                child: Text(
                  widget.content ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white, ),
                ),
              ),
            ),
            if (widget.action != null)
              widget.action!
            else if (widget.showClose == false)
              IconButton(
                  color: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.cancel),
                  onPressed: () {}
                  ),
            const SizedBox(width: 16),
          ],
        ),
      // ),
    );
  }
}



notifySuccess({
  required String? content,
  Widget? action,
  Duration duration = const Duration(seconds: 6),
  bool persist = false,
  bool showClose = true,
}) =>
    BotToast.showCustomNotification(
      toastBuilder: (cancel) {
        return Notification(
          cancelFunc: cancel,
          content: content,
          showClose: showClose,
          action: action,
        );
      },
      duration: persist ? const Duration(days: 1000) : duration,
    );

notifyInfo({
  required String content,
  Widget? action,
  Duration duration = const Duration(seconds: 6),
  bool persist = false,
  bool showClose = true,
}) =>
    BotToast.showCustomNotification(
      toastBuilder: (cancel) {
        return Notification.info(
          cancelFunc: cancel,
          content: content,
          showClose: showClose,
          action: action,
        );
      },
      duration: persist ? const Duration(days: 1000) : duration,
    );


notifyError({
  required String? content,
  Widget? action,
  Duration duration = const Duration(seconds: 6),
  bool persist = false,
  bool showClose = true,
}) =>
    BotToast.showCustomNotification(
      toastBuilder: (cancel) {
        return Notification.error(
          cancelFunc: cancel,
          content: content,
          showClose: showClose,
          action: action,
        );
      },
      duration: persist ? const Duration(days: 1000) : duration,
    );

showDialogBox({
  @required String? content,
  Widget? action,
  required BuildContext context,
  bool persist = true,
  bool showClose = true,
  dynamic Function(String)? onConfirm,
  VoidCallback? onCancel,
}) =>
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 10),
      context: context,
      pageBuilder: (_, __, ___) {
        return const AlertDialog(
          content: Text(''),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 0), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );

showDialogUpdate({
  @required String? content,
  Widget? action,
  required BuildContext context,
  bool persist = true,
  bool showClose = true,
  dynamic Function(String)? onConfirm,
  VoidCallback? onCancel,
}) =>
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of your ProDrivers app available, please update now.";
        String btnLabel = "Update";

        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text(btnLabel, style: const TextStyle(fontSize: 15)),
                    onPressed: () {
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text(btnLabel),
                    onPressed: () {
                    },
                  ),
                ],
              );
      },
    );


showLoading() => BotToast.showLoading();

hideLoading() => BotToast.closeAllLoading();

hideNotifications() => BotToast.cleanAll();

showMoreLoading() => BotToast.showAttachedWidget(
      attachedBuilder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              color: Colors.white,
              child: Icon(Icons.more_horiz_outlined)
            ),
          ),
        ],
      ),
      target: const Offset(520, 520),
    );

void main() => runApp(const LoadingWidget());

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Nheight:
    MediaQuery.of(context).size.height;
    Nwidth:
    MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [

          ],
        ),
      ),
    );
  }
}
