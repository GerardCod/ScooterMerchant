import 'dart:ui';

import 'package:flutter/material.dart';

String fontFamily = 'Aspira';
String fontFamilySecondary = 'Slant';
String location = "America/Mexico_City";

String baseUrl = 'https://www.scooterdev.tech/appback/api/v1/';
String baseUri = "www.scooterdev.tech";

// String urlComplement = "/api/v1/";
// String baseUrl = "https://www.scooter-app.team/appback/api/v1/";
// String baseUri = "www.scooter-app.team";

// final Map<String, int> status = {
//   'incoming': 14,
//   'in_process': 15,
//   'order_ready': 16
// };
const sizeIconsDetails = 28.0;

const backgroundColor = Color(0xfff2f6fc);
const primaryColor = Color(0xffff724e);
const primaryColorSecondary = Color(0xffff894e);
const secondaryColor = Color(0xff2A2F3A);

const textColorTF = Color(0xffFF724C);
const backgroundBtnFacebook = Color(0xFF3B5998);
const textColorWhite = Colors.white;
const colorSuccess = Color(0xff56C568);
const colorDanger = Color(0xffEB5757);
const colorInformation = Color(0xff3FA2F7);

final paddingButtons = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
final radiusButtons = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(20.0),
);

final paddingChips = EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0);
final radiusChips = BorderRadius.circular(20.0);

final textStyleSnackBar = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    color: Colors.white,
    fontWeight: FontWeight.bold);

final textStyleStatusChip = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.0,
    color: Colors.white,
    fontWeight: FontWeight.bold);

final textStyleLinkTile = TextStyle(
    fontFamily: fontFamily,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
    fontSize: 12.0);

final textStyleOrderDetailsSectionTitle = TextStyle(
  fontFamily: fontFamily,
  color: Colors.black,
  fontWeight: FontWeight.w800,
  fontSize: 17.0,
);

final textStyleOrderDetailsText = TextStyle(
    fontFamily: fontFamily,
    color: Colors.grey[700],
    fontWeight: FontWeight.normal,
    fontSize: 16.0);

final textStyleScooter = TextStyle(
    color: Colors.white, fontSize: 50.0, fontFamily: fontFamilySecondary);

final textStyleBtnFacebook = TextStyle(
    color: Colors.white,
    letterSpacing: 1.5,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily);

final textAddressFromandTO = TextStyle(
  color: Colors.grey[600],
  fontFamily: fontFamily,
  fontSize: 12,
);

final textAddress = TextStyle(
  color: Colors.black,
  fontFamily: fontFamily,
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

final kHintTextStyle = TextStyle(
  color: Colors.grey[400],
  fontFamily: fontFamily,
);

final textStyleSubtitleListTile = TextStyle(
  color: Colors.grey[600],
  fontSize: 14,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final textStyleWordDescListTile = TextStyle(
  color: Colors.grey[600],
  fontSize: 16,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final textStyleTitleListTile = TextStyle(
  color: Colors.black,
  fontSize: 17,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final textStyleTermsAndConditions =
    TextStyle(color: Colors.grey[600], fontSize: 14);

final textHypervincule = TextStyle(
  color: Colors.grey[600],
  fontSize: 14,
  decoration: TextDecoration.underline,
  fontWeight: FontWeight.bold,
);

final textHypervinculeWhite = TextStyle(
  color: Colors.white,
  fontSize: 14,
  decoration: TextDecoration.underline,
  fontWeight: FontWeight.bold,
);

final kLabelStyle =
    TextStyle(color: Colors.black, fontSize: 17, fontFamily: fontFamily);

final signinLogin =
    TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFFe8769c),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

int borderErrorColorTF() {
  int color = 0xFF000000;
  return color;
}

final textStyleAppBarHomePage = TextStyle(
  color: primaryColor,
  fontFamily: fontFamily,
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

final textStyleModalBottomMenuHomeHello = TextStyle(
  color: Colors.white,
  fontFamily: fontFamily,
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
);

final textStyleModalBottomMenuHomeAccount = TextStyle(
  color: Colors.black,
  fontFamily: fontFamily,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
);

final textStyleModalBottomLisTile = TextStyle(
  color: Colors.black,
  fontFamily: fontFamily,
  fontSize: 18.0,
);

final textStyleModalisTile = TextStyle(
    color: Colors.black,
    fontFamily: fontFamily,
    fontSize: 18.0,
    wordSpacing: 12,
    letterSpacing: 5);

const backgroundColorNeed = Color(0xFFEAEAEA);

final textStyleAppBarComprasPage = TextStyle(
  color: Colors.white,
  fontFamily: fontFamily,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

final textStyleNeed = TextStyle(
  color: Colors.black,
  fontFamily: fontFamily,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);
final textStyleNeed2 = TextStyle(
  color: Colors.black,
  fontFamily: fontFamily,
  fontSize: 15.0,
);

final textStyleDescription = TextStyle(
  color: Colors.black,
  fontFamily: fontFamily,
  fontSize: 18.0,
);

final textStyleBtnComprar = TextStyle(
    color: Colors.white,
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.bold);

final textStyleBtnFloating = TextStyle(
    color: Colors.white,
    fontFamily: fontFamily,
    fontSize: 17.0,
    fontWeight: FontWeight.bold);

final textStyleCartPage = TextStyle(
  color: Colors.grey[600],
  fontSize: 17,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);
final textStyleCartPage2 = TextStyle(
  color: primaryColor,
  fontSize: 14,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final textStyleAproximatePrice = TextStyle(
  color: Colors.black,
  fontSize: 19,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final textStyleAproximatePrice2 = TextStyle(
  color: Colors.grey[600],
  fontSize: 14,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final textStylePhoneNumberPage = TextStyle(
  color: Colors.grey[400],
  fontSize: 14,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final textStyleInputsLabels = TextStyle(
    color: Colors.black,
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    height: -4,
    wordSpacing: 5,
    letterSpacing: 2);

final textStyleBtnFloatingPicture = TextStyle(
    color: Colors.white,
    fontFamily: fontFamily,
    fontSize: 15.0,
    fontWeight: FontWeight.bold);

final textFormFielInformation = InputDecoration(
  border: InputBorder.none,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
);

final textStyleForAppBar = TextStyle(
  color: Colors.white,
  fontFamily: fontFamilySecondary,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

final textStyleNameAddress = TextStyle(
  color: Colors.grey[800],
  fontSize: 17,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final textStyleDataAddress = TextStyle(
  color: Colors.grey[400],
  fontSize: 14,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final textStyleDetailCardTitle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);
final textStyleDetailCardSubtitle = TextStyle(
  color: Colors.black,
  fontSize: 17,
  fontFamily: fontFamily,
);

final textStyleDetailOrderTitle = TextStyle(
  color: Colors.white,
  fontSize: 35,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final textStyleDetailOrder = TextStyle(
  color: Colors.white,
  fontSize: 22,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final textStyleDetailOrderTitleAdrres = TextStyle(
  color: Colors.black,
  fontSize: 22,
  fontFamily: fontFamily,
  // fontWeight: FontWeight.bold,
);

final textStyleDetailOrderAdrres = TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontFamily: fontFamily,
  // fontWeight: FontWeight.bold,
);

final textStylePageAwaitOrder = TextStyle(
  color: Colors.black,
  fontFamily: fontFamily,
  fontSize: 25.0,
  // fontWeight: FontWeight.bold,
);

final textStyleBottomSheetAddress = TextStyle(
  color: Colors.black,
  fontFamily: fontFamily,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

final textStyleYourScooter = TextStyle(
  color: Colors.grey[600],
  fontSize: 14,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);
