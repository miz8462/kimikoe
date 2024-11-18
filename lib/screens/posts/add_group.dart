import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/providers/idol_group_list_providere.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/utils/date_formatter.dart';
import 'package:kimikoe_app/utils/image_utils.dart';
import 'package:kimikoe_app/utils/pickers/year_picker.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';
import 'package:kimikoe_app/widgets/buttons/image_input_button.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/widgets/forms/drum_roll_form.dart';
import 'package:kimikoe_app/widgets/forms/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/forms/text_input_form.dart';

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
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  String? _groupNameValidator(String? value) {
    return textInputValidator(value, 'グループ名');
  }

  void _pickYear() async {
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
    setState(() {
      _isSending = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      setState(() {
        _isSending = false;
      });
      return;
    }

    FocusScope.of(context).unfocus();

    String? imagePath;
    late String? imageUrl;
    // 画像を登録しない場合
    if (_selectedImage == null && !_isEditing) {
      imageUrl = noImage;
    } else if (_isEditing && !_isImageChanged) {
      imageUrl = _group.imageUrl;
    } else {
      // e.g. /aaa/bbb/ccc/image.png
      imagePath = getImagePath(
          isEditing: _isEditing,
          isImageChanged: _isImageChanged,
          imageUrl: _group.imageUrl,
          imageFile: _selectedImage);
    }
    if (_selectedImage != null && imagePath != null) {
      await uploadImageToStorage(
          table: TableName.images.name, path: imagePath, file: _selectedImage!);
    }
    if (imagePath != null) {
      imageUrl = fetchImageUrl(imagePath);
    }

    if (_isEditing) {
      // 修正
      updateIdolGroup(
        name: _enteredName,
        imageUrl: imageUrl,
        year: _selectedYear,
        officialUrl: _enteredOfficialUrl,
        twitterUrl: _enteredTwitterUrl,
        instagramUrl: _enteredInstagramUrl,
        scheduleUrl: _enteredScheduleUrl,
        comment: _enteredComment,
        id: (_group.id).toString(),
      );
    } else {
      // 登録
      insertIdolGroupData(
        name: _enteredName,
        imageUrl: imageUrl,
        year: _selectedYear,
        officialUrl: _enteredOfficialUrl,
        twitterUrl: _enteredTwitterUrl,
        instagramUrl: _enteredInstagramUrl,
        scheduleUrl: _enteredScheduleUrl,
        comment: _enteredComment,
      );
    }

    setState(() {
      _isSending = false;
    });

    await ref.read(idolGroupListProvider.notifier).fetchGroupList();
    if (!mounted) {
      return;
    }

    context.pushReplacement(RoutingPath.groupList);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: TopBar(
        pageTitle: _isEditing ? 'グループ編集' : 'グループ登録',
        showLeading: _isEditing ? true : false,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenHeight),
          child: Padding(
            padding: screenPadding,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '*必須項目',
                    style: TextStyle(color: textGray),
                  ),
                  InputForm(
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
                    label: 'グループ画像',
                  ),
                  const Gap(spaceS),
                  PickerForm(
                    label: '結成年',
                    controller: _yearController,
                    picker: _pickYear,
                    onSaved: (value) {
                      _selectedYear = value;
                    },
                  ),
                  const Gap(spaceS),
                  InputForm(
                    initialValue: _isEditing ? _group.officialUrl : '',
                    label: '公式サイト URL',
                    keyboardType: TextInputType.url,
                    validator: (value) => urlValidator(value),
                    onSaved: (value) {
                      _enteredOfficialUrl = value!;
                    },
                  ),
                  const Gap(spaceS),
                  InputForm(
                    initialValue: _isEditing ? _group.twitterUrl : '',
                    label: 'Twitter URL',
                    keyboardType: TextInputType.url,
                    validator: (value) => urlValidator(value),
                    onSaved: (value) {
                      _enteredTwitterUrl = value!;
                    },
                  ),
                  const Gap(spaceS),
                  InputForm(
                    initialValue: _isEditing ? _group.instagramUrl : '',
                    label: 'Instagram Url',
                    keyboardType: TextInputType.url,
                    validator: (value) => urlValidator(value),
                    onSaved: (value) {
                      _enteredInstagramUrl = value!;
                    },
                  ),
                  const Gap(spaceS),
                  InputForm(
                    initialValue: _isEditing ? _group.scheduleUrl : '',
                    label: 'Schedule Url',
                    keyboardType: TextInputType.url,
                    validator: (value) => urlValidator(value),
                    onSaved: (value) {
                      _enteredScheduleUrl = value!;
                    },
                  ),
                  const Gap(spaceS),
                  ExpandedTextForm(
                    initialValue: _isEditing ? _group.comment : null,
                    onTextChanged: (value) {
                      _enteredComment = value!;
                    },
                    label: '備考',
                  ),
                  const Gap(spaceS),
                  StyledButton(
                    '登録',
                    onPressed: _isSending ? null : _submitGroup,
                    isSending: _isSending,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
