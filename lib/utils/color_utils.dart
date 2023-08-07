import 'package:flutter/material.dart';

class ColorUtils {
// Convertir un objet Color en chaîne héxadécimale (sans le préfixe #)
  static String colorToString(Color color) {
    String hexColor = color.value.toRadixString(16);
    return hexColor.substring(2).toUpperCase();
  }

// Convertir une chaîne héxadécimale en objet Color
  static Color stringToColor(String hexColor) {
    if (hexColor.isEmpty) {
      return Colors.transparent;
    }

// Vérifier si la chaîne commence par #
    if (hexColor[0] != '#') {
      hexColor = '#$hexColor';
    }

// Convertir la chaîne en objet Color
    return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
