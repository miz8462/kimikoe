import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/widgets/buttons/circular_button.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/widgets/forms/text_input_form.dart';
import 'package:kimikoe_app/widgets/validator/validator.dart';

class AddIdolScreen extends StatefulWidget {
  const AddIdolScreen({super.key});

  @override
  State<AddIdolScreen> createState() => _AddIdolScreenState();
}

class _AddIdolScreenState extends State<AddIdolScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredIdolName = '';
  var _enteredGroup = '';
  Color _selectedColor = Colors.white;
  File? _selectedImage;
  DateTime? _enteredBirthday;
  String? _formattedBirthday;
  var _enteredHeight = '';
  var _enteredHometown = '';
  var _enteredDebutYear = '';

  var _isSending = false;

  String? _idolNameValidator(String? value) {
    return textInputValidator(value, '名前');
  }

  String? _groupNameValidator(String? value) {
    return textInputValidator(value, 'グループ名');
  }

  String? _heightValidator(String? value) {
    return intInputValidator(value, '身長');
  }

  String? _hometownValidator(String? value) {
    return textInputValidator(value, '出身地');
  }

  String? _debutYearValidator(String? value) {
    return intInputValidator(value, 'デビュー年');
  }

  void _formatDateTimeToYYYYMMdd(DateTime date) {
    final formatter = DateFormat('yyyy/MM/dd');
    setState(() {
      _formattedBirthday = formatter.format(date);
    });
  }

  void _pickBirthday() async {
    await picker.DatePicker.showDatePicker(
      context,
      minTime: DateTime(1900, 1, 1),
      maxTime: DateTime.now(),
      currentTime: DateTime(2000, 6, 15),
      locale: picker.LocaleType.jp,
      onConfirm: (date) {
        setState(
          () {
            _enteredBirthday = date;
          },
        );
      },
    );
    if (_enteredBirthday != null) {
      _formatDateTimeToYYYYMMdd(_enteredBirthday!);
    }
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
                    CircularButton(color: Colors.pink.shade200),
                    const Text(
                      '*カラー選択',
                      style: TextStyle(color: textGray, fontSize: fontM),
                    ),
                  ],
                ),
                const Gap(spaceWidthS),
                StyledButton(
                  'メンバー画像',
                  onPressed: () {},
                  isSending: _isSending,
                  textColor: textGray,
                  backgroundColor: backgroundWhite,
                  buttonSize: buttonM,
                  borderSide: BorderSide(
                      color: backgroundLightBlue, width: borderWidth),
                ),
                const Gap(spaceWidthS),
                if (_enteredBirthday == null)
                  TextButton(
                    onPressed: _pickBirthday,
                    child: Text(
                      '生年月日',
                      style: TextStyle(
                        fontSize: fontM,
                      ),
                    ),
                  ),
                if (_enteredBirthday != null)
                  TextButton(
                    onPressed: _pickBirthday,
                    child: Text(
                      '生年月日： $_formattedBirthday',
                      style: TextStyle(
                        fontSize: fontM,
                        color: textGray,
                      ),
                    ),
                  ),
                const Gap(spaceWidthS),
                InputForm(
                  label: '身長',
                  validator: _heightValidator,
                  onSaved: (value) {
                    _enteredHeight = value!;
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
                InputForm(
                  label: 'デビュー年',
                  validator: _debutYearValidator,
                  onSaved: (value) {
                    _enteredDebutYear = value!;
                  },
                ),
                const Gap(spaceWidthS),
                // const ExpandedTextForm(label: 'その他、備考'),
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
