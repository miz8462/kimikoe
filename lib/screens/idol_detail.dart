import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';

class IdolDetailScreen extends StatelessWidget {
  const IdolDetailScreen({
    super.key,
    required this.idol,
  });

  final Idol idol;

  @override
  Widget build(BuildContext context) {
    final data = {
      'idol': idol,
      'isEditing': true,
    };
    return Scaffold(
      appBar: TopBar(
        title: idol.name,
        hasEditingMode: true,
        // delete: _deleteIdol,
        data: data,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(idol.name),
          ],
        ),
      ),
    );
  }
}
