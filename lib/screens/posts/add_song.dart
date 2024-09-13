import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:go_router/go_router.dart';

import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/create_image_name_with_jpg.dart';
import 'package:kimikoe_app/utils/dropdown_menu_group_list.dart';
import 'package:kimikoe_app/utils/fetch_data.dart';
import 'package:kimikoe_app/utils/formatter.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';
import 'package:kimikoe_app/screens/widgets/buttons/image_input_button.dart';
import 'package:kimikoe_app/screens/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/screens/widgets/forms/drum_roll_form.dart';
import 'package:kimikoe_app/screens/widgets/forms/expanded_text_form.dart';
import 'package:kimikoe_app/screens/widgets/forms/text_input_form.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key});

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final _formKey = GlobalKey<FormState>();

  final _releaseDateController = TextEditingController();

  var _enteredTitle = '';
  IdolGroup? _selectedGroup;
  File? _selectedImage;
  var _enteredLyricist = '';
  var _enteredComposer = '';
  String? _selectedReleaseDate;
  var _enteredLyric = '';
  var _enteredComment = '';

  late Future<List<Map<String, dynamic>>> _groupNameList;

  var _isSending = false;

  @override
  void initState() {
    super.initState();
    _groupNameList = fetchGroupIdAndNameList();
  }

  Future<void> _saveSong() async {
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

    if (_selectedReleaseDate == null || _selectedReleaseDate!.isEmpty) {
      _selectedReleaseDate = null;
    }

    await await supabase.from('songs').insert({
      'title': _enteredTitle,
      'lyrics': _enteredLyric,
      'group_id': _selectedGroup?.id == null ? null : _selectedGroup!.id,
      'image_url': _selectedImage == null
          ? defaultPathNoImage
          : imagePathWithCreatedAtJPG,
      'release_date': _selectedReleaseDate,
      'lyricist': _enteredLyricist,
      'composer': _enteredComposer,
      'comment': _enteredComment,
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
    // todo: 作詞家や作曲家が登録されてない場合は名前だけartistテーブルに自動的に登録されるようにする
  }

  String? _titleValidator(String? value) {
    return textInputValidator(value, 'タイトル');
  }

  String? _lyricistValidator(String? value) {
    return textInputValidator(value, '作詞家');
  }

  String? _composerValidator(String? value) {
    return textInputValidator(value, '作曲家');
  }

  void _pickReleaseDate() async {
    await picker.DatePicker.showDatePicker(
      context,
      showTitleActions: false,
      minTime: DateTime(1900),
      maxTime: DateTime.now(),
      currentTime: DateTime(2020, 6, 15),
      locale: picker.LocaleType.jp,
      onChanged: (date) {
        _selectedReleaseDate = date.toIso8601String();
        _releaseDateController.text = formatDateTimeToXXXX(
          date: date,
          formatStyle: 'yyyy/MM/dd',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: '歌詞登録',
        showLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '*必須項目',
                  style: TextStyle(color: textGray, fontSize: fontSS),
                ),
                InputForm(
                  label: '*タイトル',
                  validator: _titleValidator,
                  onSaved: (value) {
                    _enteredTitle = value!;
                  },
                ),
                Gap(spaceWidthS),
                ExpandedTextForm(
                  onTextChanged: (value) {
                    setState(() {
                      _enteredLyric = value!;
                    });
                  },
                  label: '歌詞',
                ),
                Gap(spaceWidthS),
                DropdownMenuGroupList(
                  onGroupSelected: (value) {
                    _selectedGroup = value;
                  },
                  groupList: _groupNameList,
                ),
                Gap(spaceWidthS),
                ImageInput(
                  onPickImage: (image) {
                    _selectedImage = image;
                  },
                  label: 'イメージ画像',
                ),
                Gap(spaceWidthS),
                InputForm(
                  label: '作詞家',
                  validator: _lyricistValidator,
                  onSaved: (value) {
                    _enteredLyricist = value!;
                  },
                ),
                Gap(spaceWidthS),
                InputForm(
                  label: '作曲家',
                  validator: _composerValidator,
                  onSaved: (value) {
                    _enteredComposer = value!;
                  },
                ),
                Gap(spaceWidthS),
                PickerForm(
                  label: '発売日',
                  controller: _releaseDateController,
                  picker: _pickReleaseDate,
                  onSaved: (value) {
                    setState(
                      () {
                        _selectedReleaseDate = value!;
                      },
                    );
                  },
                ),
                Gap(spaceWidthS),
                Gap(spaceWidthS),
                ExpandedTextForm(
                  onTextChanged: (value) {
                    setState(() {
                      _enteredComment = value!;
                    });
                  },
                  label: '備考',
                ),
                Gap(spaceWidthS),
                StyledButton(
                  '登録',
                  onPressed: _isSending ? null : _saveSong,
                  isSending: _isSending,
                  buttonSize: buttonL,
                ),
                Gap(spaceWidthS),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
