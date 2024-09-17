import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/widgets/buttons/image_input_button.dart';
import 'package:kimikoe_app/screens/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/screens/widgets/forms/dropdown_menu_group_list.dart';
import 'package:kimikoe_app/screens/widgets/forms/drum_roll_form.dart';
import 'package:kimikoe_app/screens/widgets/forms/expanded_text_form.dart';
import 'package:kimikoe_app/screens/widgets/forms/text_input_form.dart';
import 'package:kimikoe_app/utils/create_image_name_with_jpg.dart';
import 'package:kimikoe_app/utils/fetch_data.dart';
import 'package:kimikoe_app/utils/formatter.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key});

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _lyricistNameController = TextEditingController();
  final _composerNameController = TextEditingController();
  final _releaseDateController = TextEditingController();

  var _enteredTitle = '';
  File? _selectedImage;
  String? _selectedReleaseDate;
  var _enteredLyric = '';
  var _enteredComment = '';

  late List<Map<String, dynamic>> _groupIdAndNameList;
  late List<Map<String, dynamic>> _artistIdAndNameList;

  var _isSending = false;
  var _isFetching = true;

  @override
  void initState() {
    super.initState();
    _fetchIdAndNameLists();
  }

  Future<void> _fetchIdAndNameLists() async {
    final groupIdAndNameList =
        await fetchIdAndNameList(TableName.idolGroups.name);
    final artistIdAndNameList =
        await fetchIdAndNameList(TableName.artists.name);
    setState(() {
      _groupIdAndNameList = groupIdAndNameList;
      _artistIdAndNameList = artistIdAndNameList;
      _isFetching = false;
    });
  }

  bool isInList(List<Map<String, dynamic>> list, String? name) {
    for (final item in list) {
      if (item[ColumnName.name.colname] == name) {
        return true;
      }
    }
    return false;
  }

  int _getSelectedDataIdFromName(List<Map<String, dynamic>> list, String name) {
    final selectedData =
        list.where((item) => item[ColumnName.name.colname] == name).single;
    final selectedDataId = selectedData[ColumnName.id.colname];
    return selectedDataId;
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

    // 入力グループ名がDBにない場合、グループ名と画像なしを登録する
    int? selectedGroupId;
    int? selectedLyricistId;
    int? selectedComposerId;
    final isSelectedGroupInList =
        isInList(_groupIdAndNameList, _groupNameController.text);
    if (!isSelectedGroupInList && _groupNameController.text.isNotEmpty) {
      await supabase.from(TableName.idolGroups.name).insert({
        ColumnName.name.colname: _groupNameController.text,
        ColumnName.imageUrl.colname: defaultPathNoImage
      });
      await _fetchIdAndNameLists();
      selectedGroupId = _getSelectedDataIdFromName(
          _groupIdAndNameList, _groupNameController.text);
    }

    final isSelectedLyricistInList =
        isInList(_artistIdAndNameList, _lyricistNameController.text);
    if (!isSelectedLyricistInList && _lyricistNameController.text.isNotEmpty) {
      await supabase.from(TableName.artists.name).insert({
        ColumnName.name.colname: _lyricistNameController.text,
        ColumnName.imageUrl.colname: defaultPathNoImage
      });
      await _fetchIdAndNameLists();
      selectedLyricistId = _getSelectedDataIdFromName(
          _artistIdAndNameList, _lyricistNameController.text);
    }

    final isSelectedComposerInList =
        isInList(_artistIdAndNameList, _composerNameController.text);
    if (!isSelectedComposerInList && _composerNameController.text.isNotEmpty) {
      await supabase.from(TableName.artists.name).insert({
        ColumnName.name.colname: _composerNameController.text,
        ColumnName.imageUrl.colname: defaultPathNoImage
      });
      await _fetchIdAndNameLists();
      selectedComposerId = _getSelectedDataIdFromName(
          _artistIdAndNameList, _composerNameController.text);
    }

    // 歌詞登録
    await supabase.from(TableName.songs.name).insert({
      ColumnName.title.colname: _enteredTitle,
      ColumnName.lyrics.colname: _enteredLyric,
      ColumnName.groupId.colname: selectedGroupId,
      ColumnName.imageUrl.colname: _selectedImage == null
          ? defaultPathNoImage
          : imagePathWithCreatedAtJPG,
      ColumnName.releaseDate.colname: _selectedReleaseDate,
      ColumnName.lyricistId.colname: selectedLyricistId,
      ColumnName.composerId.colname: selectedComposerId,
      ColumnName.comment.colname: _enteredComment,
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
    return _isFetching
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
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
                      CustomDropdownMenu(
                        label: 'グループ選択',
                        dataList: _groupIdAndNameList,
                        controller: _groupNameController,
                      ),
                      Gap(spaceWidthS),
                      ImageInput(
                        onPickImage: (image) {
                          _selectedImage = image;
                        },
                        label: 'イメージ画像',
                      ),
                      Gap(spaceWidthS),
                      CustomDropdownMenu(
                        label: '作詞家',
                        dataList: _artistIdAndNameList,
                        controller: _lyricistNameController,
                      ),
                      Gap(spaceWidthS),
                      CustomDropdownMenu(
                        label: '作曲家',
                        dataList: _artistIdAndNameList,
                        controller: _composerNameController,
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
