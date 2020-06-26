import 'dart:math' as Math;

import 'package:flutter/material.dart';

extension ListExtensions<T> on List<T> {
  int maxBy(int get(T element)) {
    if (this.length == 0) {
      return null;
    }
    int result = get(this[0]);
    this.forEach((T e) {
      int test = get(e);
      result = Math.max(result, test);
    });
    return result;
  }
}

double clamp(double n, {double min: 0.0, double max: 1.0}) {
  return n.clamp(min, max);
}

extension ColorExtensions on Color {
  double get brightness {
    return (red * .299 + green * .587 + blue * .114);
  }

  bool get isDark => brightness < 128.0;

  bool get isLight => !isDark;

  Color get foregroundColor {
    if (isLight) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  // These methods were copied from [tinycolor package](https://github.com/FooStudio/tinycolor/blob/master/lib/tinycolor.dart).

  Color lighten({int amount: 10}) {
    final hsl = HSLColor.fromColor(this);
    double l = hsl.lightness + (amount / 100);
    l = clamp(l);
    double s = hsl.saturation;
    if (this == Colors.black) {
      // Special case for black, as lightening black makes red.
      s = 0.0;
    }
    return hsl.withLightness(l).withSaturation(s).toColor();
  }

  Color darken({int amount: 10}) {
    final hsl = HSLColor.fromColor(this);
    double l = hsl.lightness - (amount / 100);
    l = clamp(l);
    double s = hsl.saturation;
    if (this == Colors.black) {
      // Special case for black, as lightening black makes red.
      s = 0.0;
    }
    return hsl.withLightness(l).withSaturation(s).toColor();
  }
}