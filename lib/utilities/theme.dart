// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:vmerge/utilities/constants.dart';

//themes
ThemeData appTheme = ThemeData(
  fontFamily: 'RobotoMono',
  primaryColor: kPrimaryColor,
  primaryColorDark: kPrimaryColorDark,
  primaryColorLight: kPrimaryWhiteColor,
  scaffoldBackgroundColor: kPrimaryColorDark,
  cardColor: kPrimaryColorDark,
  shadowColor: Colors.transparent,
  iconTheme: const IconThemeData(color: kPrimaryWhiteColor),
  appBarTheme: const AppBarTheme(color: kPrimaryColor),
  textTheme: const TextTheme(
    displayLarge: TextStyle(),
    displayMedium: TextStyle(),
    displaySmall: TextStyle(),
    headlineMedium: TextStyle(),
    headlineSmall: TextStyle(),
    titleLarge: TextStyle(),
    titleMedium: TextStyle(),
    titleSmall: TextStyle(),
    bodyLarge: TextStyle(),
    bodyMedium: TextStyle(),
    bodySmall: TextStyle(),
    labelLarge: TextStyle(),
    labelSmall: TextStyle(),
  ).apply(
    bodyColor: kPrimaryWhiteColor,
    displayColor: kPrimaryWhiteColor,
  ),
  colorScheme: const ColorScheme.dark()
      .copyWith(
        primary: kPrimaryWhiteColor,
        secondary: kTimelineControllerColor,
      )
      .copyWith(background: kPrimaryColor),
);
