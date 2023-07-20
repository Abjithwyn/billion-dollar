import 'package:flutter/material.dart';

class CustomWidgets {
  Text boldTextbox(String textdata, double fontsize, Color colors) => Text(
        textdata,
        style: TextStyle(
          overflow: TextOverflow.clip,
          fontSize: fontsize,
          fontFamily: 'light',
          fontWeight: FontWeight.bold,
          color: colors,
        ),
      );
  Text boldTextboxFade(String textdata, double fontsize, Color colors) => Text(
        textdata,
        style: TextStyle(
          overflow: TextOverflow.fade,
          fontSize: fontsize,
          fontFamily: 'light',
          fontWeight: FontWeight.bold,
          color: colors,
        ),
      );
  Text normalTextbox(String textdata, double fontsize, Color colors) => Text(
        textdata,
        style: TextStyle(
          overflow: TextOverflow.clip,
          fontSize: fontsize,
          fontFamily: 'light',
          fontWeight: FontWeight.normal,
          color: colors,
        ),
      );
  Text mediumTextbox(String textdata, double fontsize, Color colors) => Text(
        textdata,
        style: TextStyle(
          overflow: TextOverflow.clip,
          fontSize: fontsize,
          fontFamily: 'karla',
          fontWeight: FontWeight.w600,
          color: colors,
        ),
      );
  Text wardtext(
    String textdata,
  ) =>
      Text(
        textdata,
        style: const TextStyle(
          overflow: TextOverflow.clip,
          fontSize: 80,
          fontWeight: FontWeight.bold,
          color: Color(0xff5E5699),
        ),
      );
}
