import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/widgets/group_card_l.dart';

class IdolGroupListScreen extends StatefulWidget {
  const IdolGroupListScreen({super.key});

  @override
  State<IdolGroupListScreen> createState() => _IdolGroupListScreenState();
}

class _IdolGroupListScreenState extends State<IdolGroupListScreen> {
  late Stream _groupStream;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() {
    _groupStream = fetchDatabyStream(
      table: TableName.idolGroups.name,
      id: ColumnName.id.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(
        imageUrl: 'assets/images/Kimikoe_Logo.png',
        showLeading: false,
      ),
      body: StreamBuilder(
        stream: _groupStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /* 
          テーブルにデータが一件も無い状態の snapshot.data は "[]" となる。snapshot.dataに対しhasDataすると "[]" というデータがあると判断される。なので空のリストを文字列にすることでlengthが2になりデータがないことを判断する。
          */
          if (snapshot.data.toString().length == 2) {
            return const Center(child: Text('登録データはありません'));
          } else {
            final groups = snapshot.data;
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
                // IdolGroupクラスを初期化
                final group = groups[index];
                final imageUrl =
                    fetchPublicImageUrl(group[ColumnName.imageUrl.name]);
                final groupInfo = IdolGroup(
                  id: group[ColumnName.id.name],
                  name: group[ColumnName.cName.name],
                  imageUrl: imageUrl,
                  year: group[ColumnName.yearFormingGroups.name],
                  comment: group[ColumnName.comment.name],
                );

                return GroupCardL(group: groupInfo);
              },
            );
          }
        },
      ),
    );
  }
}
