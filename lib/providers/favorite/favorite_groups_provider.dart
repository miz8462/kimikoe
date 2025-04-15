import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/favorite/favorite_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase/supabase_services_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_groups_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<IdolGroup>> favoriteGroups(Ref ref) async {
  return _favoriteGroups(ref);
}

Future<List<IdolGroup>> _favoriteGroups(Ref ref) async {
  final favoriteIdsAsync =
      ref.watch(favoriteNotifierProvider(FavoriteType.groups));
  final favoriteIds = favoriteIdsAsync.value ?? [];

  final supabaseServices = ref.read(supabaseServicesProvider);
  if (favoriteIds.isEmpty) return [];

  try {
    final response =
        await supabaseServices.fetch.fetchFavoriteGroups(favoriteIds);

    final groups = response.map<IdolGroup>((group) {
      return IdolGroup(
        id: group[ColumnName.id],
        name: group[ColumnName.name],
        imageUrl: group[ColumnName.imageUrl],
        year: group[ColumnName.yearFormingGroups],
        officialUrl: group[ColumnName.officialUrl],
        twitterUrl: group[ColumnName.twitterUrl],
        instagramUrl: group[ColumnName.instagramUrl],
        scheduleUrl: group[ColumnName.scheduleUrl],
        comment: group[ColumnName.comment],
      );
    }).toList();
    return groups;
  } catch (e) {
    logger.e('お気に入りグループの取得中にエラーが発生しました', error: e);
    return [];
  }
}
