import 'package:flutter/material.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/widgets/group_card.dart';

class IdolGroupListScreen extends StatefulWidget {
  const IdolGroupListScreen({super.key});

  @override
  State<IdolGroupListScreen> createState() => _IdolGroupListScreenState();
}

class _IdolGroupListScreenState extends State<IdolGroupListScreen> {
  late Future _groupFuture;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() {
    _groupFuture = supabase.from('idol-groups').select('name, image_url');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        imageUrl: 'assets/images/Kimikoe_Logo.png',
      ),
      body: FutureBuilder(
        future: _groupFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('登録データはありません'));
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
              // todo: バケットはパブリックでいいの？
              var imageUrl = supabase.storage
                  .from('images')
                  .getPublicUrl(group['image_url']);
              return GroupCard(
                name: group['name'],
                imageUrl: imageUrl,
              );
            },
          );
        },
      ),
    );
  }
}
