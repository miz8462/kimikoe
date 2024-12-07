import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/idol_colors.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/bool_check.dart';
import 'package:kimikoe_app/utils/color_code_to_string_hex.dart';
import 'package:kimikoe_app/utils/date_formatter.dart';
import 'package:kimikoe_app/utils/image_utils.dart';
import 'package:kimikoe_app/utils/pickers/custom_picker.dart';
import 'package:kimikoe_app/utils/pickers/int_picker.dart';
import 'package:kimikoe_app/utils/supabase_service.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';
import 'package:kimikoe_app/widgets/button/circular_button.dart';
import 'package:kimikoe_app/widgets/button/image_input_button.dart';
import 'package:kimikoe_app/widgets/button/styled_button.dart';
import 'package:kimikoe_app/widgets/form/dropdown_menu_group_list.dart';
import 'package:kimikoe_app/widgets/form/drum_roll_form.dart';
import 'package:kimikoe_app/widgets/form/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/form/text_input_form.dart';

List<Color> colorsList = IdolColors.values.map((color) => color.rgb).toList();

class AddIdolScreen extends StatefulWidget {
  const AddIdolScreen({
    super.key,
    this.idol,
    this.isEditing,
  });

  final Idol? idol;
  final bool? isEditing;

  @override
  State<AddIdolScreen> createState() => _AddIdolScreenState();
}

class _AddIdolScreenState extends State<AddIdolScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _groupNameController;
  late TextEditingController _birthYearController;
  late TextEditingController _birthDayController;
  late TextEditingController _heightController;
  late TextEditingController _debutYearController;
  late Idol _idol;
  late Color color;

  var _enteredIdolName = '';
  Color _selectedColor = Colors.lightBlue;
  File? _selectedImage;
  String? imageUrl;
  String? _selectedBirthYear;
  String? _selectedBirthDay;
  String? _selectedHeight;
  String? _enteredHometown;
  String? _selectedDebutYear;
  String? _enteredComment;

  late List<Map<String, dynamic>> _groupIdAndNameList;
  var _isSending = false;
  var _isFetching = true;
  var _isImageChanged = false;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _fetchIdAndNameGroupList();

    if (widget.idol != null) {
      _idol = widget.idol!;
      _isEditing = true;
      _selectedColor = _idol.color ?? Colors.lightBlue;
    } else {
      _idol = Idol(name: '', imageUrl: noImage); // デフォルト値で初期化
      _isEditing = false;
      _selectedColor = Colors.lightBlue;
    }

    if (_idol.color == null) {
      color = Colors.lightBlue;
    }
    _selectedColor = _isEditing ? color : Colors.lightBlue;

    _groupNameController = TextEditingController(
      text: _isEditing ? _idol.group?.name : '',
    );
    _birthYearController = TextEditingController(
      text: _isEditing ? _idol.birthYear.toString() : '',
    );
    _birthDayController = TextEditingController(
      text: _isEditing ? _idol.birthDay : '',
    );
    _heightController = TextEditingController(
      text: _isEditing ? _idol.height.toString() : '',
    );
    _debutYearController = TextEditingController(
      text: _isEditing ? _idol.debutYear.toString() : '',
    );
  }

  Future<void> _fetchIdAndNameGroupList() async {
    final groupIdAndNameList = await fetchIdAndNameList(TableName.idolGroups);
    setState(() {
      _groupIdAndNameList = groupIdAndNameList;
      _isFetching = false;
    });
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _birthYearController.dispose();
    _birthDayController.dispose();
    _heightController.dispose();
    _debutYearController.dispose();
    super.dispose();
  }

  Future<void> _submitIdol() async {
    logger.i('アイドル登録フォーム送信開始');

    setState(() {
      _isSending = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      logger.i('ヴァリデーションに成功しました');
    } else {
      logger.w('ヴァリデーションに失敗しました');
      setState(() {
        _isSending = false;
      });
      return;
    }

    FocusScope.of(context).unfocus();

    final imageUrl = await processImage(
      isEditing: _isEditing,
      isImageChanged: _isImageChanged,
      existingImageUrl: _idol.imageUrl,
      selectedImage: _selectedImage,
      context: context,
    );

    if (imageUrl == null) {
      // 画像URLが取得できなかった場合の処理
      logger.e('画像URLが取得できませんでした。');
    } else {
      logger.i(imageUrl);
    }

    int birthYear;
    if (_selectedBirthYear == null || _selectedBirthYear!.isEmpty) {
      birthYear = 0;
    } else {
      birthYear = int.parse(_selectedBirthYear!);
    }

    if (_selectedBirthDay == null || _selectedBirthDay!.isEmpty) {
      _selectedBirthDay = '';
    }

    int height;
    if (_selectedHeight == null || _selectedHeight!.isEmpty) {
      height = 0;
    } else {
      height = int.parse(_selectedHeight!);
    }

    int debutYear;
    if (_selectedDebutYear == null || _selectedDebutYear!.isEmpty) {
      debutYear = 0;
    } else {
      debutYear = int.parse(_selectedDebutYear!);
    }
    // 入力グループ名がDBにない場合、グループ名とNo Imageを登録する
    int? selectedGroupId;
    final groupName = _groupNameController.text;

    final isSelectedGroupInList = isInList(_groupIdAndNameList, groupName);
    if (!isSelectedGroupInList && groupName.isNotEmpty) {
      if (!mounted) return;
      await insertIdolGroupData(
        name: groupName,
        imageUrl: noImage,
        year: '',
        comment: '',
        context: context,
      );
      await _fetchIdAndNameGroupList();
    }
    if (groupName.isNotEmpty) {
      selectedGroupId = fetchSelectedDataIdFromName(
        list: _groupIdAndNameList,
        name: groupName,
      );
    }

    // MaterialColor(primary value: Color(0xff2196f3))という表記から"0xff2196f3"を抜き出す
    final selectedColor = colorCodeToStringHex(_selectedColor);

    if (!mounted) return;
    if (_isEditing) {
      await updateIdol(
        name: _enteredIdolName,
        id: _idol.id!,
        groupId: selectedGroupId,
        color: selectedColor,
        imageUrl: imageUrl,
        birthday: _selectedBirthDay,
        birthYear: birthYear,
        height: height,
        hometown: _enteredHometown,
        debutYear: debutYear,
        comment: _enteredComment,
        context: context,
      );
    } else {
      await insertIdolData(
        name: _enteredIdolName,
        groupId: selectedGroupId,
        color: selectedColor,
        imageUrl: imageUrl,
        birthday: _selectedBirthDay,
        birthYear: birthYear,
        height: height,
        hometown: _enteredHometown,
        debutYear: debutYear,
        comment: _enteredComment,
        context: context,
      );
    }

    setState(() {
      _isSending = false;
    });

    if (!mounted) {
      return;
    }

    context.pushReplacement(RoutingPath.groupList);
  }

  String? _nameValidator(String? value) {
    return textInputValidator(value, '名前');
  }

  String? _hometownValidator(String? value) {
    return nullableTextInputValidator(value, '出身地');
  }

  Future<void> _pickBirthYear() async {
    await picker.DatePicker.showPicker(
      context,
      showTitleActions: false,
      pickerModel: CustomYearPicker(
        currentTime: DateTime(2000),
        minTime: DateTime(1990),
        maxTime: DateTime.now(),
        locale: picker.LocaleType.jp,
      ),
      onChanged: (date) {
        _selectedBirthYear = date.toIso8601String();
        _birthYearController.text = formatDateTimeToXXXX(
          date: date,
          formatStyle: 'yyyy',
        );
      },
    );
  }

  Future<void> _pickBirthday() async {
    await picker.DatePicker.showPicker(
      context,
      showTitleActions: false,
      pickerModel: CustomMonthDayPicker(
        currentTime: DateTime(2000, 6, 15),
        minTime: DateTime(1990),
        maxTime: DateTime.now(),
        locale: picker.LocaleType.jp,
      ),
      onChanged: (date) {
        _selectedBirthDay = date.toIso8601String();
        _birthDayController.text = formatStringDateToMMdd(date.toString());
      },
    );
  }

  Future<void> _pickHeight() async {
    await showModalBottomSheet<Widget>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: IntPicker(
            startNum: 100,
            endNum: 200,
            initialNum: 160,
            controller: _heightController,
          ),
        );
      },
    );
  }

  Future<void> _pickDebutYear() async {
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
        _selectedDebutYear = date.toIso8601String();
        _debutYearController.text = formatDateTimeToXXXX(
          date: date,
          formatStyle: 'yyyy',
        );
      },
    );
  }

  Future<void> _pickColor() async {
    await showModalBottomSheet<Widget>(
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
    return _isFetching
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: TopBar(
              pageTitle: _isEditing ? 'アイドル編集' : 'アイドル登録',
              showLeading: _isEditing,
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
                        initialValue:
                            _isEditing ? _idol.name : _enteredIdolName,
                        label: '*名前',
                        validator: _nameValidator,
                        onSaved: (value) {
                          _enteredIdolName = value!;
                        },
                      ),
                      const Gap(spaceS),
                      CustomDropdownMenu(
                        label: 'グループ選択',
                        dataList: _groupIdAndNameList,
                        controller: _groupNameController,
                      ),
                      const Gap(spaceS),
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
                      const Gap(spaceS),
                      ImageInput(
                        imageUrl: _idol.imageUrl,
                        onPickImage: (image) {
                          _selectedImage = image;
                          _isImageChanged = true;
                        },
                        label: 'イメージ画像',
                      ),
                      const Gap(spaceS),
                      PickerForm(
                        label: '生まれた年',
                        controller: _birthYearController,
                        initialValue: '2000',
                        picker: _pickBirthYear,
                        onSaved: (value) {
                          setState(
                            () {
                              _selectedBirthYear = value;
                            },
                          );
                        },
                      ),
                      const Gap(spaceS),
                      PickerForm(
                        label: '生まれた日付',
                        controller: _birthDayController,
                        initialValue: '06-15',
                        picker: _pickBirthday,
                        onSaved: (value) {
                          setState(
                            () {
                              _selectedBirthDay = value;
                            },
                          );
                        },
                      ),
                      const Gap(spaceS),
                      PickerForm(
                        label: '身長',
                        controller: _heightController,
                        picker: _pickHeight,
                        onSaved: (value) {
                          setState(
                            () {
                              _selectedHeight = value;
                            },
                          );
                        },
                      ),
                      const Gap(spaceS),
                      InputForm(
                        initialValue:
                            _isEditing ? _idol.hometown : _enteredHometown,
                        label: '出身地',
                        validator: _hometownValidator,
                        onSaved: (value) {
                          _enteredHometown = value;
                        },
                      ),
                      const Gap(spaceS),
                      PickerForm(
                        label: 'デビュー年',
                        controller: _debutYearController,
                        picker: _pickDebutYear,
                        initialValue: '2020',
                        onSaved: (value) {
                          setState(
                            () {
                              _selectedDebutYear = value;
                            },
                          );
                        },
                      ),
                      const Gap(spaceS),
                      ExpandedTextForm(
                        initialValue:
                            _isEditing ? _idol.comment : _enteredComment,
                        onTextChanged: (value) {
                          setState(() {
                            _enteredComment = value;
                          });
                        },
                        label: '備考',
                      ),
                      const Gap(spaceS),
                      StyledButton(
                        '登録',
                        onPressed: _isSending ? null : _submitIdol,
                        isSending: _isSending,
                      ),
                      const Gap(spaceS),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
