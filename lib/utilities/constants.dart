import 'package:flutter/material.dart';

enum Layers { textOverlay, imageOverlay, videoOverlay, frame, music }

enum Options { media, text, music, overlay, blank, sound }

enum SubOptions {
  edit,
  fonts,
  align,
  crop,
  opacity,
  volume,
  speed,
  transform,
  color,
  background,
  duration,
  reverse,
  split,
  reorder,
  replace,
  down,
  up,
  duplicate,
  delete
}

const List<Color> colorList = [
  Colors.transparent,
  Color(0xff000000),
  Color(0xff1a1a1a),
  Color(0xff333333),
  Color(0xff4c4c4c),
  Color(0xff666666),
  Color(0xff808080),
  Color(0xff999999),
  Color(0xffb2b2b2),
  Color(0xffcccccc),
  Color(0xffe6e6e6),
  Color(0xffffffff),
  Color(0xffffe6e6),
  Color(0xffffcccc),
  Color(0xffffb2b2),
  Color(0xffff9999),
  Color(0xffff8080),
  Color(0xffff6666),
  Color(0xffff4c4c),
  Color(0xffff3333),
  Color(0xffff1a1a),
  Color(0xffff0000),
  Color(0xfff60404),
  Color(0xffed0808),
  Color(0xffe40d0d),
  Color(0xffdb1111),
  Color(0xffd21515),
  Color(0xffc91919),
  Color(0xffc01d1d),
  Color(0xffb72222),
  Color(0xffae2626),
  Color(0xffa52a2a),
  Color(0xffae3f26),
  Color(0xffb75522),
  Color(0xffc06a1d),
  Color(0xffc97f19),
  Color(0xffd29415),
  Color(0xffdbaa11),
  Color(0xffe4bf0d),
  Color(0xffedd408),
  Color(0xfff6ea04),
  Color(0xffffff00),
  Color(0xffe6f200),
  Color(0xffcce600),
  Color(0xffb2d900),
  Color(0xff99cc00),
  Color(0xff80c000),
  Color(0xff66b300),
  Color(0xff4ca600),
  Color(0xff339900),
  Color(0xff1a8d00),
  Color(0xff008000),
  Color(0xff00731a),
  Color(0xff006633),
  Color(0xff005a4c),
  Color(0xff004d66),
  Color(0xff004080),
  Color(0xff003399),
  Color(0xff0026b2),
  Color(0xff001acc),
  Color(0xff000de6),
  Color(0xff0000ff),
  Color(0xff0e00ff),
  Color(0xff1c00ff),
  Color(0xff2a00ff),
  Color(0xff3800ff),
  Color(0xff4600ff),
  Color(0xff5400ff),
  Color(0xff6200ff),
  Color(0xff7000ff),
  Color(0xff7e00ff),
  Color(0xff8b00ff)
];

const List<String> fontList = [
  "Bangers",
  "Eater",
  "Flavors",
  "HennyPenny",
  "Honk",
  "Kablommo",
  "Kalnia",
  "MarkoOne",
  "Modak",
  "Nabla",
  "NewRocker",
  "Nosifer",
  "NotoColor",
  "Nunito",
  "Pacifico",
  "Paddana",
  "RobotoSlab",
  "RubikBeastly",
  "RubikBurned",
  "Gemstones",
  "WetPaint",
  "RuslanDisplay",
  "Shadows",
  "Shrikhand",
  "SingleDay",
  "Sixtyfour",
  "Sriacha",
  "TradeWinds",
];
