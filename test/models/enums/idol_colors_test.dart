import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/enums/idol_colors.dart';

void main() {
  test('IdolColors enum', (){
    expect(IdolColors.red.rgb, Colors.red);
    expect(IdolColors.blue.rgb, Colors.blue);
    expect(IdolColors.lightBlue.rgb, Colors.lightBlue);
    expect(IdolColors.cyan.rgb, Colors.cyan);
    expect(IdolColors.blueAccent.rgb, Colors.blueAccent);
    expect(IdolColors.green.rgb, Colors.green);
    expect(IdolColors.lime.rgb, Colors.lime);
    expect(IdolColors.lightGreen.rgb, Colors.lightGreen);
    expect(IdolColors.teal.rgb, Colors.teal);
    expect(IdolColors.yellow.rgb, Colors.yellow);
    expect(IdolColors.amber.rgb, Colors.amber);
    expect(IdolColors.pink.rgb, Colors.pink);
    expect(IdolColors.white.rgb, Colors.white);
    expect(IdolColors.indigo.rgb, Colors.indigo);
    expect(IdolColors.purple.rgb, Colors.purple);
    expect(IdolColors.orange.rgb, Colors.orange);
    expect(IdolColors.deepOrange.rgb, Colors.deepOrange);
    expect(IdolColors.brown.rgb, Colors.brown);
    expect(IdolColors.grey.rgb, Colors.grey);
  });
}
