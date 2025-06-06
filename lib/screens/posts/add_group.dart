import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/groups_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase/supabase_services_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/date_formatter.dart';
import 'package:kimikoe_app/utils/image_utils.dart';
import 'package:kimikoe_app/utils/pickers/custom_picker.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';
import 'package:kimikoe_app/widgets/button/image_input.dart';
import 'package:kimikoe_app/widgets/button/styled_button.dart';
import 'package:kimikoe_app/widgets/form/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/form/input_form.dart';
import 'package:kimikoe_app/widgets/form/picker_form.dart';

class AddGroupScreen extends ConsumerStatefulWidget {
  const AddGroupScreen({
    super.key,
    this.group,
    this.isEditing,
  });

  final IdolGroup? group;
  final bool? isEditing;

  @override
  ConsumerState<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends ConsumerState<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _yearController;
  late IdolGroup _group;

  var _enteredName = '';
  File? _selectedImage;
  String? _selectedYear;
  var _enteredComment = '';
  var _enteredOfficialUrl = '';
  var _enteredTwitterUrl = '';
  var _enteredInstagramUrl = '';
  var _enteredScheduleUrl = '';

  var _isSending = false;
  var _isImageChanged = false;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    // 編集の場合の初期化
    if (widget.group != null) {
      _group = widget.group!;
    }

    _isEditing = widget.isEditing!;

    if (_isEditing) {
      final initialYear = widget.group!.year.toString();
      _yearController = TextEditingController(text: initialYear);
    } else {
      _yearController = TextEditingController(text: '2020');
    }

    _selectedYear = _yearController.text;
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  String? _groupNameValidator(String? value) {
    return textInputValidator(value, '名前');
  }

  Future<void> _pickYear() async {
    await picker.DatePicker.showPicker(
      context,
      showTitleActions: false,
      pickerModel: CustomYearPicker(
        currentTime: DateTime(2020),
        minTime: DateTime(1990),
        maxTime: DateTime.now(),
        locale: picker.LocaleType.jp,
      ),
      onChanged: (date) {
        _selectedYear = formatDateTimeToXXXX(
          date: date,
          formatStyle: 'yyyy',
        );
        _yearController.text = _selectedYear!;
      },
    );
  }

  Future<void> _submitGroup() async {
    logger.i('フォーム送信を開始します');

    setState(() {
      _isSending = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      logger.i('ヴァリデーションに成功しました');
    } else {
      logger.i('ヴァリデーションに失敗しました');
      setState(() {
        _isSending = false;
      });
      return;
    }

    FocusScope.of(context).unfocus();

    final storage = ref.watch(supabaseServicesProvider).storage;
    final imageUrl = await processImage(
      isEditing: _isEditing,
      isImageChanged: _isImageChanged,
      existingImageUrl: _group.imageUrl,
      selectedImage: _selectedImage,
      context: context,
      storage: storage,
    );

    if (imageUrl == null) {
      // 画像URLが取得できなかった場合の処理
      logger.e('画像URLが取得できませんでした。');
    } else {
      logger.i(imageUrl);
    }

    if (!mounted) return;
    // 登録、修正
    final service = ref.watch(supabaseServicesProvider);
    if (_isEditing) {
      await service.update.updateIdolGroup(
        name: _enteredName,
        imageUrl: imageUrl,
        year: _selectedYear,
        officialUrl: _enteredOfficialUrl,
        twitterUrl: _enteredTwitterUrl,
        instagramUrl: _enteredInstagramUrl,
        scheduleUrl: _enteredScheduleUrl,
        comment: _enteredComment,
        id: _group.id.toString(),
        context: context,
      );
    } else {
      await service.insert.insertIdolGroupData(
        name: _enteredName,
        imageUrl: imageUrl,
        year: _selectedYear,
        officialUrl: _enteredOfficialUrl,
        twitterUrl: _enteredTwitterUrl,
        instagramUrl: _enteredInstagramUrl,
        scheduleUrl: _enteredScheduleUrl,
        comment: _enteredComment,
        context: context,
      );
    }

    setState(() {
      _isSending = false;
    });

    await ref.read(groupsProvider.notifier).fetchGroupList();

    if (!mounted) {
      return;
    }

    context.pushReplacement(RoutingPath.groupList);
    // TODO: GoRouterを学んだのち、編集の場合はグループ詳細へ遷移するようにする
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        pageTitle: _isEditing ? 'グループ編集' : 'グループ登録',
        showLeading: _isEditing,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '*必須項目',
                  style: TextStyle(color: textGray),
                ),
                InputForm(
                  key: Key(WidgetKeys.name),
                  initialValue: _isEditing ? _group.name : '',
                  label: '*グループ名',
                  validator: _groupNameValidator,
                  onSaved: (value) {
                    _enteredName = value!;
                  },
                ),
                const Gap(spaceS),
                ImageInput(
                  imageUrl: _group.imageUrl,
                  onPickImage: (image) {
                    _selectedImage = image;
                    _isImageChanged = true;
                  },
                ),
                const Gap(spaceS),
                PickerForm(
                  key: Key(WidgetKeys.year),
                  label: '結成年',
                  initialValue: _selectedYear,
                  controller: _yearController,
                  picker: _pickYear,
                  onSaved: (value) {
                    _selectedYear = value;
                  },
                ),
                const Gap(spaceS),
                InputForm(
                  key: Key(WidgetKeys.official),
                  initialValue: _isEditing ? _group.officialUrl : '',
                  label: '公式サイト URL',
                  keyboardType: TextInputType.url,
                  validator: urlValidator,
                  onSaved: (value) {
                    _enteredOfficialUrl = value!;
                  },
                ),
                const Gap(spaceS),
                InputForm(
                  key: Key(WidgetKeys.twitter),
                  initialValue: _isEditing ? _group.twitterUrl : '',
                  label: 'Twitter URL',
                  keyboardType: TextInputType.url,
                  validator: urlValidator,
                  onSaved: (value) {
                    _enteredTwitterUrl = value!;
                  },
                ),
                const Gap(spaceS),
                InputForm(
                  key: Key(WidgetKeys.instagram),
                  initialValue: _isEditing ? _group.instagramUrl : '',
                  label: 'Instagram Url',
                  keyboardType: TextInputType.url,
                  validator: urlValidator,
                  onSaved: (value) {
                    _enteredInstagramUrl = value!;
                  },
                ),
                const Gap(spaceS),
                InputForm(
                  key: Key(WidgetKeys.schedule),
                  initialValue: _isEditing ? _group.scheduleUrl : '',
                  label: 'Schedule Url',
                  keyboardType: TextInputType.url,
                  validator: urlValidator,
                  onSaved: (value) {
                    _enteredScheduleUrl = value!;
                  },
                ),
                const Gap(spaceS),
                ExpandedTextForm(
                  key: Key(WidgetKeys.comment),
                  initialValue: _isEditing ? _group.comment : null,
                  onTextChanged: (value) {
                    _enteredComment = value!;
                  },
                  label: '備考',
                ),
                const Gap(spaceS),
                StyledButton(
                  key: Key(WidgetKeys.submit),
                  '登録',
                  onPressed: _isSending ? null : _submitGroup,
                  isSending: _isSending,
                ),
                const Gap(spaceM),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
