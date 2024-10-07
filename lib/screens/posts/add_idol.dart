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
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/widgets/buttons/circular_button.dart';
import 'package:kimikoe_app/screens/widgets/buttons/image_input_button.dart';
import 'package:kimikoe_app/screens/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/screens/widgets/forms/dropdown_menu_group_list.dart';
import 'package:kimikoe_app/screens/widgets/forms/drum_roll_form.dart';
import 'package:kimikoe_app/screens/widgets/forms/expanded_text_form.dart';
import 'package:kimikoe_app/screens/widgets/forms/text_input_form.dart';
import 'package:kimikoe_app/utils/check.dart';
import 'package:kimikoe_app/utils/create_image_name_with_jpg.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/utils/formatter.dart';
import 'package:kimikoe_app/utils/pickers/int_picker.dart';
import 'package:kimikoe_app/utils/pickers/year_picker.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';

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
  late TextEditingController _birthdayController;
  late TextEditingController _heightController;
  late TextEditingController _debutYearController;
  late Idol _idol;

  var _enteredIdolName = '';
  Color _selectedColor = Colors.lightBlue;
  File? _selectedImage;
  String? imageUrl;
  String? _selectedBirthday;
  String? _selectedHeight;
  String? _enteredHometown;
  String? _selectedDebutYear;
  String? _enteredComment;

  late List<Map<String, dynamic>> _groupIdAndNameList;
  var _isSending = false;
  var _isFetching = true;
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

      imageUrl = fetchPublicImageUrl(_idol.imageUrl!);
      // supabase.storage
      //     .from(TableName.images.name)
      //     .getPublicUrl(_idol.imageUrl!);

      _groupNameController = TextEditingController(text: _idol.group!.name);
      _birthdayController = TextEditingController(text: _idol.birthDay);
      _heightController = TextEditingController(text: _idol.height.toString());
      final initialDebutYear = widget.idol!.debutYear.toString();
      _debutYearController = TextEditingController(text: initialDebutYear);
    } else {
      _groupNameController = TextEditingController();
      _birthdayController = TextEditingController();
      _heightController = TextEditingController();
      _debutYearController = TextEditingController();
    }
  }

  Future<void> _fetchIdAndNameGroupList() async {
    final groupIdAndNameList =
        await fetchIdAndNameList(TableName.idolGroups.name);
    setState(() {
      _groupIdAndNameList = groupIdAndNameList;
      _isFetching = false;
    });
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _birthdayController.dispose();
    _heightController.dispose();
    _debutYearController.dispose();
    super.dispose();
  }

  Future<void> _submitIdol() async {
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
    final imagePathWithCreatedAtJPG =
        createImageNameWithJPG(image: _selectedImage);

    if (_selectedHeight == null || _selectedHeight!.isEmpty) {
      _selectedHeight = null;
    } else {
      int.parse(_selectedHeight!);
    }

    if (_selectedBirthday == null || _selectedBirthday!.isEmpty) {
      _selectedBirthday = null;
    }

    if (_selectedDebutYear == null || _selectedDebutYear!.isEmpty) {
      _selectedDebutYear = null;
    }

    // 入力グループ名がDBにない場合、グループ名とNo Imageを登録する
    int? selectedGroupId;
    final groupName = _groupNameController.text;

    final isSelectedGroupInList = isInList(_groupIdAndNameList, groupName);
    if (!isSelectedGroupInList && groupName.isNotEmpty) {
      insertIdolGroupData(
        name: groupName,
        imageUrl: defaultPathNoImage,
        year: '',
        comment: '',
      );
      await _fetchIdAndNameGroupList();
    }
    selectedGroupId = fetchSelectedDataIdFromName(
      list: _groupIdAndNameList,
      name: groupName,
    );

    final selectedColor = _selectedColor
        .toString()
        .split(' ')
        .last
        .replaceFirst('Color', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    if (_isEditing) {
      await supabase.from(TableName.idol.name).update({
        ColumnName.cName.name: _enteredIdolName,
        ColumnName.groupId.name: selectedGroupId,
        ColumnName.color.name: selectedColor,
        ColumnName.imageUrl.name: _selectedImage == null
            ? defaultPathNoImage
            : imagePathWithCreatedAtJPG,
        ColumnName.birthday.name: _selectedBirthday,
        ColumnName.height.name: _selectedHeight,
        ColumnName.hometown.name: _enteredHometown,
        ColumnName.debutYear.name: _selectedDebutYear,
        ColumnName.comment.name: _enteredComment,
      }).eq(ColumnName.id.name, _idol.id!);
    } else {
      await supabase.from(TableName.idol.name).insert({
        ColumnName.cName.name: _enteredIdolName,
        ColumnName.groupId.name: selectedGroupId,
        ColumnName.color.name: selectedColor,
        ColumnName.imageUrl.name: _selectedImage == null
            ? defaultPathNoImage
            : imagePathWithCreatedAtJPG,
        ColumnName.birthday.name: _selectedBirthday,
        ColumnName.height.name: _selectedHeight,
        ColumnName.hometown.name: _enteredHometown,
        ColumnName.debutYear.name: _selectedDebutYear,
        ColumnName.comment.name: _enteredComment,
      });
    }

    if (_selectedImage != null) {
      uploadImageToStorage(
          table: TableName.images.name,
          path: imagePathWithCreatedAtJPG!,
          file: _selectedImage!);
      // await supabase.storage
      //     .from(TableName.images.name)
      //     .upload(imagePathWithCreatedAtJPG!, _selectedImage!);
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

  void _pickBirthday() async {
    await picker.DatePicker.showDatePicker(
      context,
      showTitleActions: false,
      minTime: DateTime(1900),
      maxTime: DateTime.now(),
      currentTime: DateTime(2000, 6, 15),
      locale: picker.LocaleType.jp,
      onChanged: (date) {
        _selectedBirthday = date.toIso8601String();
        _birthdayController.text = formatDateTimeToXXXX(
          date: date,
          formatStyle: 'yyyy/MM/dd',
        );
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
    print(_selectedColor);
    return _isFetching
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: TopBar(
              title: _isEditing ? 'アイドル編集' : 'アイドル登録',
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
                        imageUrl: imageUrl,
                        onPickImage: (image) {
                          _selectedImage = image;
                        },
                        label: 'イメージ画像',
                      ),
                      const Gap(spaceS),
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
                        buttonSize: buttonL,
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
