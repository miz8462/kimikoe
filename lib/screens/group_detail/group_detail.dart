import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/favorite/favorite_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/group_detail/widget/group_info.dart';
import 'package:kimikoe_app/screens/group_detail/widget/group_members.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_services.dart';
import 'package:kimikoe_app/widgets/delete_alert_dialog.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  const GroupDetailScreen({
    required this.group,
    super.key,
  });

  final IdolGroup group;

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen> {
  final _isEditing = true;
  final _isGroup = true;
  var _isStarred = false;

  @override
  void initState() {
    super.initState();
    // 初期化時に非同期でお気に入り状態を確認
    _initializeStarred();
  }

  Future<void> _initializeStarred() async {
    final favoriteGroupsAsync =
        ref.read(favoriteNotifierProvider(FavoriteType.groups));
    final favoriteGroups = favoriteGroupsAsync.valueOrNull ?? [];
    setState(() {
      _isStarred = favoriteGroups.contains(widget.group.id);
    });
  }

  void _deleteGroup() {
    showDialog<Widget>(
      context: context,
      builder: (context) {
        final supabaseServices = SupabaseServices();
        return DeleteAlertDialog(
          onDelete: () async {
            await supabaseServices.delete.deleteDataById(
              table: TableName.idolGroups,
              id: widget.group.id.toString(),
              context: context,
              supabase: supabase,
            );
          },
          successMessage: '${widget.group.name}のデータが削除されました',
          errorMessage: '${widget.group.name}のデータの削除に失敗しました',
        );
      },
    );
  }

  void _toggleStarred() {
    final id = widget.group.id;
    if (id == null) return;
    setState(() {
      _isStarred = !_isStarred;
    });

    final notifier =
        ref.read(favoriteNotifierProvider(FavoriteType.groups).notifier);

    if (_isStarred) {
      notifier.add(id);
    } else {
      notifier.remove(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    final data = {
      'group': group,
      'isEditing': _isEditing,
    };

    final favoriteGroupsAsync = ref.watch(
      favoriteNotifierProvider(FavoriteType.groups),
    );

    return Scaffold(
      appBar: favoriteGroupsAsync.when(
        data: (favoriteGroups) {
          // お気に入り状態を最新に保つ（必要なら）
          if (_isStarred != favoriteGroups.contains(group.id)) {
            _isStarred = favoriteGroups.contains(group.id);
          }
          return TopBar(
            pageTitle: group.name,
            isEditing: _isEditing,
            isGroup: _isGroup,
            editRoute: RoutingPath.addGroup,
            delete: _deleteGroup,
            data: data,
            isStarred: _isStarred,
            hasFavoriteFeature: true,
            onStarToggle: _toggleStarred,
          );
        },
        loading: () => TopBar(
          pageTitle: group.name,
          isEditing: _isEditing,
          isGroup: _isGroup,
          editRoute: RoutingPath.addGroup,
          delete: _deleteGroup,
          data: data,
          isStarred: _isStarred,
          hasFavoriteFeature: true,
        ),
        error: (error, stack) => TopBar(
          pageTitle: group.name,
          isEditing: _isEditing,
          isGroup: _isGroup,
          editRoute: RoutingPath.addGroup,
          delete: _deleteGroup,
          data: data,
          isStarred: _isStarred,
          hasFavoriteFeature: true,
        ),
      ),
      body: Padding(
        padding: screenPadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(spaceS),
              GroupInfo(
                group: group,
              ),
              Divider(
                color: mainColor.withValues(alpha: 0.3),
                thickness: 2,
              ),
              GroupMembers(group: group),
            ],
          ),
        ),
      ),
    );
  }
}
