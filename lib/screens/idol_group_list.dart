import 'package:flutter/material.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/widgets/group_card_l.dart';

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
    _groupFuture = supabase.from(TableName.idolGroups.name).select();
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

          /* 
          テーブルにデータが一件も無い状態の snapshot.data は "[]" となる。snapshot.dataに対しhasDataすると "[]" というデータがあると判断される。なので空のリストを文字列にすることでlengthが2になりデータがないことを判断する。
          */
          if (snapshot.data.toString().length == 2) {
            return Center(child: Text('登録データはありません'));
          } else {
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
                // todo: バケットはパブリックでいいの？
                // IdolGroupクラスを初期化
                final group = groups[index];
                final id = group[ColumnName.id.colname];
                final name = group[ColumnName.name.colname];
                final imageUrl = supabase.storage
                    .from(TableName.images.name)
                    .getPublicUrl(group[ColumnName.imageUrl.colname]);
                final comment = group[ColumnName.comment.colname];
                final groupInfo = IdolGroup(
                  id: id,
                  name: name,
                  imageUrl: imageUrl,
                  comment: comment,
                );

                return GroupCardL(
                  group: groupInfo,
                );
              },
            );
          }
        },
      ),
    );
  }
}
