import 'package:flutter/material.dart';

double mediaWidth(context, media) {
  return MediaQuery.of(context).size.width * media;
}

double mediaHeight(context, media) {
  return MediaQuery.of(context).size.height * media;
}
