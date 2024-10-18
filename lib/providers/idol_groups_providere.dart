import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

final idolGroupListFromSupabaseProvider =
    FutureProvider<List<dynamic>>((ref) async {
  final data = await fetchDatabyStream(
    table: TableName.idolGroups.name,
    id: ColumnName.id.name,
  ).first;
  return data.toList();
});
