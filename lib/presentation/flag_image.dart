import 'package:flutter/material.dart';
import 'package:flutter_countries_educations/src/assets/assets.gen.dart';

class FlagImage {
  static Widget getImage({String countryCode = "UZ"}) {
    return SvgGenImage(
      "assets/images/flags/${countryCode.toLowerCase()}.svg",
    ).svg(fit: BoxFit.none);
  }
}
