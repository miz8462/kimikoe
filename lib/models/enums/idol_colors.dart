import 'package:flutter/material.dart';

enum IdolColors {
  red(rgb: Colors.red),
  blue(rgb: Colors.blue),
  lightBlue(rgb: Colors.lightBlue),
  cyan(rgb: Colors.cyan),
  blueAccent(rgb: Colors.blueAccent),
  green(rgb: Colors.green),
  lime(rgb: Colors.lime),
  lightGreen(rgb: Colors.lightGreen),
  teal(rgb: Colors.teal),
  yellow(rgb: Colors.yellow),
  amber(rgb: Colors.amber),
  pink(rgb: Colors.pink),
  white(rgb: Colors.white),
  indigo(rgb: Colors.indigo),
  purple(rgb: Colors.purple),
  orange(rgb: Colors.orange),
  deepOrange(rgb: Colors.deepOrange),
  brown(rgb: Colors.brown),
  grey(rgb: Colors.grey);

  final Color rgb;
  
  const IdolColors({required this.rgb});
}
