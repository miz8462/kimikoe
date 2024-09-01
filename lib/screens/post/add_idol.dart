import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/enums/idol_colors.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/formatter.dart';
import 'package:kimikoe_app/utils/pickers/int_picker.dart';
import 'package:kimikoe_app/utils/pickers/year_picker.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';
import 'package:kimikoe_app/widgets/buttons/circular_button.dart';
import 'package:kimikoe_app/widgets/buttons/image_input_button.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/widgets/forms/drum_roll_form.dart';
import 'package:kimikoe_app/widgets/forms/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/forms/text_input_form.dart';

List<Color> colorsList = IdolColors.values.map((color) => color.rgb).toList();

class AddIdolScreen extends StatefulWidget {
  const AddIdolScreen({super.key});

  @override
  State<AddIdolScreen> createState() => _AddIdolScreenState();
}

class _AddIdolScreenState extends State<AddIdolScreen> {
  final _formKey = GlobalKey<FormState>();
  final _birthdayController = TextEditingController();
  final _heightController = TextEditingController();
  final _debutYearController = TextEditingController();

  var _enteredIdolName = '';
  var _enteredGroup = '';
  Color _selectedColor = Colors.lightBlue;
  File? _selectedImage;
  String? _selectedBirthday;
  String? _formattedBirthday;
  String? _selectedHeight;
  var _enteredHometown = '';
  String? _selectedDebutYear;
  String _enteredComment = '';

  var _isSending = false;

  String? _idolNameValidator(String? value) {
    return textInputValidator(value, '名前');
  }

  String? _groupNameValidator(String? value) {
    return textInputValidator(value, 'グループ名');
  }

  String? _hometownValidator(String? value) {
    return textInputValidator(value, '出身地');
  }

  void _pickBirthday() async {
    await picker.DatePicker.showDatePicker(
      context,
      showTitleActions: false,
      minTime: DateTime(1900),
      maxTime: DateTime.now(),
      currentTime: DateTime(2000, 6, 15),
      locale: picker.LocaleType.jp,
      onChanged: (date) {
        _selectedBirthday = formatDateTimeToXXXX(
          date: date,
          formatStyle: 'yyyy/MM/dd',
        );
        _birthdayController.text = _selectedBirthday!;
      },
    );
  }

  void _pickHeight() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: IntPicker(
            startNum: 100,
            endNum: 190,
            controller: _heightController,
          ),
        );
      },
    );
  }

  void _pickDebutYear() async {
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
        _selectedDebutYear = formatDateTimeToXXXX(
          date: date,
          formatStyle: 'yyyy',
        );
        _debutYearController.text = _selectedDebutYear!;
      },
    );
  }

  void _pickColor() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: BlockPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
              });
              context.pop();
            },
            availableColors: colorsList,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'アイドル登録',
        showLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '*必須項目',
                  style: TextStyle(color: textGray, fontSize: fontSS),
                ),
                InputForm(
                  label: '*名前',
                  validator: _idolNameValidator,
                  onSaved: (value) {
                    _enteredIdolName = value!;
                  },
                ),
                const Gap(spaceWidthS),
                InputForm(
                  label: '*所属グループ',
                  validator: _groupNameValidator,
                  onSaved: (value) {
                    _enteredGroup = value!;
                  },
                ),
                const Gap(spaceWidthS),
                // 歌詞で表示する個人カラー選択
                Row(
                  children: [
                    CircularButton(
                      color: _selectedColor,
                      onPressed: _pickColor,
                    ),
                    const Text(
                      '*カラー選択',
                      style: TextStyle(
                        color: textGray,
                        fontSize: fontM,
                      ),
                    ),
                  ],
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
                  label: '生年月日',
                  controller: _birthdayController,
                  picker: _pickBirthday,
                  onSaved: (value) {
                    setState(
                      () {
                        _selectedBirthday = value!;
                      },
                    );
                  },
                ),
                const Gap(spaceWidthS),
                PickerForm(
                  label: '身長',
                  controller: _heightController,
                  picker: _pickHeight,
                  onSaved: (value) {
                    setState(
                      () {
                        _heightController.text = value!;
                      },
                    );
                  },
                ),
                const Gap(spaceWidthS),
                InputForm(
                    label: '出身地',
                    validator: _hometownValidator,
                    onSaved: (value) {
                      _enteredHometown = value!;
                    }),
                const Gap(spaceWidthS),
                PickerForm(
                  label: 'デビュー年',
                  controller: _debutYearController,
                  picker: _pickDebutYear,
                  onSaved: (value) {
                    setState(
                      () {
                        _selectedDebutYear = value!;
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
                  onPressed: () {
                    context.go('/group_list');
                  },
                  isSending: _isSending,
                  buttonSize: buttonL,
                ),
                const Gap(spaceWidthS),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
