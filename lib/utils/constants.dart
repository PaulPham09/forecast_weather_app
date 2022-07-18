// Weather forecast API
import 'package:flutter/material.dart';

// ERRORS WHEN CONNECTING TO SERVICE
const INVALID_RESPONSE = 100;
const NO_INTERNET = 101;
const INVALID_FORMAT = 102;
const UNKNOWN_ERRORS = 103;

// Spacing unit
const spacing = 8.0;

// Custom text style in app
// Regular style
const regularStyle = TextStyle(
    color: Color.fromRGBO(42, 42, 42, 1.0),
    fontFamily: 'Roboto',
    fontSize: spacing * 2);

// Thin style
const thinStyle = TextStyle(
  color: Color.fromRGBO(85, 103, 153, 1.0),
  fontFamily: 'RobotoThin',
  fontSize: spacing * 4,
  letterSpacing: 0.0,
);

// Bold style
const boldStyle = TextStyle(
  color: Color.fromRGBO(42, 42, 42, 1.0),
  fontFamily: 'RobotoBlack',
  fontSize: spacing * 12,
  letterSpacing: 0.0,
);
