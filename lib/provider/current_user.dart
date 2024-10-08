import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';

final userDataProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final currentUserId = supabase.auth.currentUser!.id;
  final userData = await supabase
      .from(TableName.profiles.name)
      .select()
      .eq(ColumnName.id.name, currentUserId);
  return userData;
});
