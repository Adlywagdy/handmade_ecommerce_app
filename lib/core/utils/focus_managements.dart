import 'package:flutter/material.dart';

class FocusManagementTips {


  static void clearFocusBeforeNavigation(FocusNode? focusNode) {
    focusNode?.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void clearFocusBeforePush(FocusNode? focusNode) {
    clearFocusBeforeNavigation(focusNode);
  }


  static void clearFocusInBottomNav(FocusNode? focusNode, int newIndex, Function(int) setState) {
    clearFocusBeforeNavigation(focusNode);
    setState(newIndex);
  }


  static void clearFocusOnPageInactive(FocusNode? focusNode) {
    focusNode?.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }
}


mixin FocusAwareMixin<T extends StatefulWidget> on State<T>, RouteAware {
  FocusNode? get focusNode;

  @override
  void didPushNext() {
    FocusManagementTips.clearFocusOnPageInactive(focusNode);
  }

  @override
  void didPopNext() {
    FocusManagementTips.clearFocusOnPageInactive(focusNode);
  }
}















