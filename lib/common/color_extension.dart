import 'package:flutter/material.dart';

class TColor {
  static Color get primaryColor1 => const Color(0xff92A3FD);
  static Color get primaryColor2 => const Color(0xff9DCEFF);
  
  static Color get secondaryColor1 => const Color(0xffC58BF2);
  static Color get secondaryColor2 => const Color(0xffEEA4CE);
  
  static List<Color> get primaryG => [ primaryColor1, primaryColor2];
  static List<Color> get secondaryG => [ secondaryColor1, secondaryColor2];

  static Color get dark => const Color(0xff101617);
  static Color get gray => const Color(0xff786F72); 
  static Color get white => const Color(0xffFFFFFF); 
}