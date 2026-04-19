import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName    = 'Aurox';
  static const String appVersion = '1.0.0+1';

  static const double spaceXS  = 4.0;
  static const double spaceSM  = 8.0;
  static const double spaceMD  = 16.0;
  static const double spaceLG  = 24.0;
  static const double spaceXL  = 32.0;
  static const double spaceXXL = 48.0;

  static const double radiusSM   = 10.0;
  static const double radiusMD   = 14.0;
  static const double radiusLG   = 20.0;
  static const double radiusXL   = 28.0;
  static const double radiusFull = 100.0;

  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  static const EdgeInsets cardPadding = EdgeInsets.all(20);
  static const EdgeInsets listItemPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 8);
  static const EdgeInsets sectionPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 8);

  static const double iconSM = 18.0;
  static const double iconMD = 22.0;
  static const double iconLG = 28.0;
  static const double iconXL = 36.0;

  static const Duration durationFast   = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow   = Duration(milliseconds: 500);

  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveSnappy  = Curves.easeOut;
  static const Curve curveSpring  = Curves.elasticOut;

  static const double cardHeight          = 190.0;
  static const double cardWidth           = 320.0;
  static const double transactionIconSize = 44.0;
  static const double bottomNavHeight     = 72.0;

  static const double chartBarWidth  = 28.0;
  static const double chartBarRadius = 6.0;
  static const double chartHeight    = 140.0;

  static const double elevationNone = 0.0;
  static const double elevationLow  = 4.0;
  static const double elevationMid  = 8.0;

  static const String usersCollection        = 'users';
  static const String transactionsCollection = 'transactions';
  static const String cardsCollection        = 'cards';
}
