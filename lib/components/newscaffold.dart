// import 'package:bot_toast/bot_toast.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prodrivers/components/utils.dart';

class HVScaffold extends StatelessWidget {
  /// Cupertino-specific options
  final ObstructingPreferredSizeWidget? navigationBar;

  /// Material-specific options
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final PreferredSizeWidget? appPreBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? drawerScrimColor;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final AppBar? preferredAppBar;
  final bool primary;
  final bool? showProcessingBar;

  final Function()? callback;
  final bool? pageViewEnabled;
  /////

  final DragStartBehavior drawerDragStartBehavior;
  final double? drawerEdgeDragWidth;

  /// general options
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final bool left;
  final bool top;
  final bool right;
  final bool bottom;
  final bool showBar;
  final EdgeInsets minimum;
  final Widget? title;

  const HVScaffold({
    this.pageViewEnabled,
    this.navigationBar,
    this.callback,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.appPreBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.drawerScrimColor,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerEdgeDragWidth,
    this.left = false,
    this.top = true,
    this.right = false,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.title,
    this.showBar = true,
    this.preferredAppBar,
    this.showProcessingBar,
    PreferredSizeWidget? appBar,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return Scaffold(
        floatingActionButton: floatingActionButton,
        appBar: showBar == true
            ? AppBar(
                leading: IconButton(
                  onPressed: () {
                    // pageViewEnabled == true ? callback!() : App.pop(true);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_sharp,
                  ),
                ),
              )
            : showProcessingBar == true
                ? AppBar(
                    elevation: 0,
                    title: title,
                    centerTitle: true,
                    bottomOpacity: 0.4,
                    bottom: const PreferredSize(
                      preferredSize: Size(0, 3),
                      child: SizedBox(
                        height: 3,
                      ),
                    ),
                  )
                : appPreBar,
        body: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                body!,
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: PreferredSize(
                    preferredSize: Size(0, 0),
                    child: SizedBox(
                      height: 3,
                      // child:
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      );
    }
    return Scaffold(
      appBar: showBar
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  // pageViewEnabled == true ? callback!() : App.pop(true);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_sharp,
                ),
              ),
            )
          : showProcessingBar == true
              ? AppBar(
                  elevation: 0,
                  title: title,
                  centerTitle: true,
                  bottomOpacity: 0.4,
                  bottom: const PreferredSize(
                    preferredSize: Size(0, 3),
                    child: SizedBox(
                      height: 3,
                    ),
                  ),
                )
              : appPreBar,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: SafeArea(
        child: body!,
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      drawer: drawer,
      endDrawer: endDrawer,
      drawerScrimColor: drawerScrimColor,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      primary: primary,
      drawerDragStartBehavior: drawerDragStartBehavior,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
    );
  }
}

/// creates a tab scaffold depending on the environment.
class HVTabScaffold extends HVScaffold {
  /// Cupertino-specific options
  final CupertinoTabBar? tabBar;
  final CupertinoTabController? controller;
  final IndexedWidgetBuilder? tabBuilder;

  /// Android-specific options
  final double elevation;
  final BottomNavigationBarType? type;
  final double iconSize;
  final Color selectedItemColor;
  final Color? unselectedItemColor;
  final IconThemeData selectedIconTheme;
  final IconThemeData unselectedIconTheme;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;
  final double selectedFontSize;
  final double unselectedFontSize;
  final bool showUnselectedLabels;
  final bool showSelectedLabels;

  Color get fixedColor => selectedItemColor;

  // General options
  final List<BottomNavigationBarItem> items;
  final ValueChanged<int> onTap;
  final int currentIndex;

  static final GlobalKey<NavigatorState> cupertinoNavKey =
      GlobalKey<NavigatorState>();

  HVTabScaffold({
    Key? key,
    BuildContext? context,

    // Cupertino Data
    this.tabBar,
    this.controller,
    this.tabBuilder,
    bool resizeToAvoidBottomInset = true,
    required this.items,
    required this.onTap,
    this.currentIndex = 0,
    this.elevation = 0,
    this.type,
    this.iconSize = 24.0,
    this.selectedItemColor = Colors.black,
    this.unselectedItemColor,
    this.selectedIconTheme = const IconThemeData(),
    this.unselectedIconTheme = const IconThemeData(),
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    // general data
    Color? backgroundColor,
    Widget? title,
    // super data
    bool extendBody = false,
    bool extendBodyBehindAppBar = false,

    // super data2
    PreferredSizeWidget? appBar,
    ObstructingPreferredSizeWidget? navigationBar,
    bool? showProcessingBar,
    PreferredSizeWidget? appPreBar,

    /////
    required Widget body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    List<Widget>? persistentFooterButtons,
    Widget? drawer,
    Widget? endDrawer,
    Color? drawerScrimColor,
    Widget? bottomSheet,
    bool? primary,
    DragStartBehavior? drawerDragStartBehavior,
    double? drawerEdgeDragWidth,
    bool left = false,
    bool top = true,
    bool right = false,
    bool bottom = true,
    EdgeInsets minimum = EdgeInsets.zero,
    bool showBar = true,
  }) : super(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          extendBody: extendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          appBar: appBar,
          showProcessingBar: showProcessingBar,
          showBar: showBar,
          appPreBar: appPreBar,
          body: body,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButtonAnimator: floatingActionButtonAnimator,
          persistentFooterButtons: persistentFooterButtons,
          drawer: drawer,
          endDrawer: endDrawer,
          drawerScrimColor: drawerScrimColor,
          bottomNavigationBar: BottomNavigationBar(
            items: items,
            type: BottomNavigationBarType.fixed,
            backgroundColor: backgroundColor,
            onTap: onTap,
            elevation: elevation,
            currentIndex: currentIndex,
            selectedItemColor: selectedItemColor,
            iconSize: iconSize,
            selectedFontSize: selectedFontSize,
            unselectedItemColor: unselectedItemColor ??
                Theme.of(context!).textTheme.bodyMedium!.color!,
            selectedIconTheme: selectedIconTheme,
            unselectedIconTheme: unselectedIconTheme,
            unselectedFontSize: unselectedFontSize,
            selectedLabelStyle: selectedLabelStyle,
            unselectedLabelStyle: unselectedLabelStyle,
            showSelectedLabels: showSelectedLabels,
            showUnselectedLabels: showUnselectedLabels,
          ),
          bottomSheet: bottomSheet,
          primary: primary ?? true,
          drawerDragStartBehavior:
              drawerDragStartBehavior ?? DragStartBehavior.start,
          drawerEdgeDragWidth: drawerEdgeDragWidth,
          navigationBar: navigationBar,
          backgroundColor: backgroundColor,
          left: left,
          top: top,
          right: right,
          bottom: bottom,
          minimum: minimum,
          title: title,
        );

  @override
  Widget build(BuildContext context) {
    return platformWidget(
      android: super.build(context),
      ios: CupertinoTabScaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: backgroundColor,
        tabBar: CupertinoTabBar(
          items: items,
          backgroundColor: backgroundColor,
          onTap: onTap,
          currentIndex: currentIndex,
          activeColor: selectedItemColor,
          // inactiveColor: unselectedItemColor ?? Color(),
          iconSize: iconSize,
        ),
        // controller: controller!,
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(builder: (context) {
            return super.build(context);
          });
        },
      ),
    );
  }
}
