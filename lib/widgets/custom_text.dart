import 'package:flutter/material.dart';

class CustomText extends Text {

    CustomText(String data, {TextAlign? textAlign, Color? color, double? fontSize, FontStyle? fontStyle,TextOverflow? overflow }):
            super(
            (data==null?" ":data),
            textAlign: textAlign ?? TextAlign.center,
            overflow: overflow ?? TextOverflow.visible,
            style: TextStyle(
                color: color ?? Colors.white,
                fontSize: fontSize ?? 15,
                fontStyle: fontStyle ?? FontStyle.normal
            )
        );
}
