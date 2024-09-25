import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/provider/idol_groups_notifier.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/create_image_name_with_jpg.dart';
import 'package:kimikoe_app/utils/formatter.dart';
import 'package:kimikoe_app/utils/pickers/year_picker.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';
import 'package:kimikoe_app/screens/widgets/buttons/image_input_button.dart';
import 'package:kimikoe_app/screens/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/screens/widgets/forms/drum_roll_form.dart';
import 'package:kimikoe_app/screens/widgets/forms/expanded_text_form.dart';
import 'package:kimikoe_app/screens/widgets/forms/text_input_form.dart';

class AddGroupScreen extends ConsumerStatefulWidget {
  const AddGroupScreen({super.key});

  @override
  ConsumerState<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends ConsumerState<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _yearController = TextEditingController();

  var _enteredName = '';
  File? _selectedImage;
  String? _selectedYear;
  var _enteredComment = '';

  var _isSending = false;

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
    final imagePathWithCreatedAtJPG = createImageNameWithJPG(_selectedImage);
    ref.read(idolGroupsProvider.notifier).addGroup(
          _enteredName,
          _selectedImage == null
              ? defaultPathNoImage
              : imagePathWithCreatedAtJPG,
          _selectedYear == null ? null : int.tryParse(_selectedYear!),
          _enteredComment,
        );

    await supabase.from('idol-groups').insert({
      'name': _enteredName,
      'image_url': _selectedImage == null
          ? defaultPathNoImage
          : imagePathWithCreatedAtJPG,
      'year_forming_group':
          _selectedYear == null ? null : int.tryParse(_selectedYear!),
      'comment': _enteredComment
    });

    if (_selectedImage != null) {
      await supabase.storage
          .from('images')
          .upload(imagePathWithCreatedAtJPG!, _selectedImage!);
    }

    setState(() {
      _isSending = false;
    });

    if (!mounted) {
      return;
    }

    context.pushReplacement('/group_list');
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: TopBar(
        title: 'グループ登録',
        showLeading: false,
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
                    label: '*グループ名',
                    validator: _groupNameValidator,
                    onSaved: (value) {
                      _enteredName = value!;
                    },
                  ),
                  const Gap(spaceWidthS),
                  ImageInput(
                    onPickImage: (image) {
                      _selectedImage = image;
                    },
                    label: 'グループ画像',
                  ),
                  const Gap(spaceWidthS),
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
                  const Gap(spaceWidthS),
                  ExpandedTextForm(
                    onTextChanged: (value) {
                      setState(() {
                        _enteredComment = value!;
                      });
                    },
                    label: '備考',
                  ),
                  const Gap(spaceWidthS),
                  StyledButton(
                    '登録',
                    onPressed: _isSending ? null : _saveGroup,
                    isSending: _isSending,
                    buttonSize: buttonL,
                  ),
                  const Gap(spaceWidthS),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}