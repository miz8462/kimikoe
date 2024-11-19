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
import 'package:kimikoe_app/utils/check.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/utils/date_formatter.dart';
import 'package:kimikoe_app/utils/image_utils.dart';
import 'package:kimikoe_app/utils/pickers/int_picker.dart';
import 'package:kimikoe_app/utils/pickers/year_picker.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';
import 'package:kimikoe_app/widgets/buttons/circular_button.dart';
import 'package:kimikoe_app/widgets/buttons/image_input_button.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/widgets/forms/dropdown_menu_group_list.dart';
import 'package:kimikoe_app/widgets/forms/drum_roll_form.dart';
import 'package:kimikoe_app/widgets/forms/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/forms/text_input_form.dart';

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

    // 編集の場合の初期化
    if (widget.idol != null) {
      _idol = widget.idol!;
    }
    _isEditing = widget.isEditing!;

    if (_isEditing) {
      _selectedColor = _idol.color!;
      _groupNameController = TextEditingController(text: _idol.group!.name);
      _birthYearController =
          TextEditingController(text: _idol.birthYear.toString());
      _birthDayController = TextEditingController(text: _idol.birthDay);
      _heightController = TextEditingController(text: _idol.height.toString());
      final initialDebutYear = widget.idol!.debutYear.toString();
      _debutYearController = TextEditingController(text: initialDebutYear);
    } else {
      _groupNameController = TextEditingController();
      _birthYearController = TextEditingController();
      _birthDayController = TextEditingController();
      _heightController = TextEditingController();
      _debutYearController = TextEditingController();
    }
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
    logger.i('フォーム送信開始');

    setState(() {
      _isSending = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      logger.i('ヴァリデーション成功');
    } else {
      logger.w('ヴァリデーション失敗');
      setState(() {
        _isSending = false;
      });
      return;
    }

    FocusScope.of(context).unfocus();

    // e.g. /aaa/bbb/ccc/image.png
    String? imagePath = getImagePath(
      isEditing: _isEditing,
      isImageChanged: _isImageChanged,
      imageUrl: _idol.imageUrl,
      imageFile: _selectedImage,
    );

    if (_selectedImage != null) {
      await uploadImageToStorage(
        table: TableName.images,
        path: imagePath!,
        file: _selectedImage!,
      );
      logger.i('画像をストレージにアップロード');
    }

    final imageUrl = fetchImageUrl(imagePath!);

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
      insertIdolGroupData(
        name: groupName,
        imageUrl: noImage,
        year: '',
        comment: '',
      );
      logger.i('グループ登録: $groupName');
      await _fetchIdAndNameGroupList();
    }
    if (groupName.isNotEmpty) {
      selectedGroupId = fetchSelectedDataIdFromName(
        list: _groupIdAndNameList,
        name: groupName,
      );
    }

    // MaterialColor(primary value: Color(0xff2196f3))という表記から"0xff2196f3"を抜き出す
    final selectedColor = formatStringColorCode(_selectedColor);

    if (_isEditing) {
      updateIdol(
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
      );
      logger.i('アイドル更新完了: $_enteredIdolName');
    } else {
      insertIdolData(
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
      );
      logger.i('アイドル新規登録完了: $_enteredIdolName');
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

  void _pickBirthYear() async {
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

  void _pickBirthday() async {
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
        _selectedDebutYear = date.toIso8601String();
        _debutYearController.text = formatDateTimeToXXXX(
          date: date,
          formatStyle: 'yyyy',
        );
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
    return _isFetching
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: TopBar(
              pageTitle: _isEditing ? 'アイドル編集' : 'アイドル登録',
              showLeading: _isEditing ? true : false,
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
                        picker: _pickBirthYear,
                        onSaved: (value) {
                          setState(
                            () {
                              _selectedBirthYear = value!;
                            },
                          );
                        },
                      ),
                      const Gap(spaceS),
                      PickerForm(
                        label: '生まれた日付',
                        controller: _birthDayController,
                        picker: _pickBirthday,
                        onSaved: (value) {
                          setState(
                            () {
                              _selectedBirthDay = value!;
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
                            _enteredHometown = value!;
                          }),
                      const Gap(spaceS),
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
                      const Gap(spaceS),
                      ExpandedTextForm(
                        initialValue:
                            _isEditing ? _idol.comment : _enteredComment,
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
