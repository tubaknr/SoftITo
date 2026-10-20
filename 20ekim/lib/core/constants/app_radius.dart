import 'package:flutter/material.dart';

class AppRadius {
  const AppRadius._();

  static const double smValue = 10;
  static const double mdValue = 16;
  static const double lgValue = 24;
  static const double sheetValue = 28;
  static const double pillValue = 999;

  static const BorderRadius sm = BorderRadius.all(Radius.circular(smValue));
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdValue));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgValue));
  static const BorderRadius sheet = BorderRadius.only(
    topLeft: Radius.circular(sheetValue),
    topRight: Radius.circular(sheetValue),
  );
  static const BorderRadius pill = BorderRadius.all(Radius.circular(pillValue));
}
