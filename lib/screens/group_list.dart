import 'package:flutter/material.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/widgets/group_card.dart';

class GroupListScreen extends StatefulWidget {
  const GroupListScreen({super.key});

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  late Future _future;
  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() {
    _future = supabase.from('group').select('name, image_url');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final groups = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 横に表示する数
            crossAxisSpacing: 18, // 横のスペース
            mainAxisSpacing: 15, // 縦のスペース
            childAspectRatio: 1.0, // カードのアスペクト比
          ),
          itemCount: groups.length,
          itemBuilder: (BuildContext context, int index) {
            final group = groups[index];
            var imageUrl = group['image_url'];
            imageUrl ??= "";
            return GroupCard(
              name: group['name'],
              imageUrl: imageUrl,
            );
          },
        );
      },
    );
  }
}
