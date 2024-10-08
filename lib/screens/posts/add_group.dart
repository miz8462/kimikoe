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
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/widgets/buttons/image_input_button.dart';
import 'package:kimikoe_app/screens/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/screens/widgets/forms/drum_roll_form.dart';
import 'package:kimikoe_app/screens/widgets/forms/expanded_text_form.dart';
import 'package:kimikoe_app/screens/widgets/forms/text_input_form.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/utils/formatter.dart';
import 'package:kimikoe_app/utils/image_utils.dart';
import 'package:kimikoe_app/utils/pickers/year_picker.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';

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

  Future<void> _saveGroup() async {
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

    // e.g. /aaa/bbb/ccc/image.png
    String? imagePath = getImagePath(
        isEditing: _isEditing,
        isImageChanged: _isImageChanged,
        imageUrl: _group.imageUrl,
        imageFile: _selectedImage);

    // todo: グループリストのプロバイダー化
    // ref.read(idolGroupsProvider.notifier).addGroup(
    //       _enteredName,
    //       _selectedImage == null
    //           ? defaultPathNoImage
    //           : imagePathWithCreatedAtJPG,
    //       _selectedYear == null ? null : int.tryParse(_selectedYear!),
    //       _enteredComment,
    //     );

    if (_isEditing) {
      // 修正
      updateIdolGroup(
        name: _enteredName,
        imageUrl: imagePath,
        year: _selectedYear,
        comment: _enteredComment,
        id: (_group.id).toString(),
      );
    } else {
      // 登録
      insertIdolGroupData(
        name: _enteredName,
        imageUrl: imagePath,
        year: _selectedYear,
        comment: _enteredComment,
      );
    }

    if (_selectedImage != null) {
      uploadImageToStorage(
          table: TableName.images.name,
          path: imagePath!,
          file: _selectedImage!);
    }

    setState(() {
      _isSending = false;
    });

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
        title: _isEditing ? 'グループ編集' : 'グループ登録',
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
                      setState(
                        () {
                          _selectedYear = value;
                        },
                      );
                    },
                  ),
                  const Gap(spaceS),
                  ExpandedTextForm(
                    initialValue: _isEditing ? _group.comment : null,
                    onTextChanged: (value) {
                      setState(() {
                        _enteredComment = value!;
                      });
                    },
                    label: '備考',
                  ),
                  const Gap(spaceS),
                  StyledButton(
                    '登録',
                    onPressed: _isSending ? null : _saveGroup,
                    isSending: _isSending,
                    buttonSize: buttonL,
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
