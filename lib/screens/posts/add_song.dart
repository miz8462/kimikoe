import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/check.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/utils/date_formatter.dart';
import 'package:kimikoe_app/utils/image_utils.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';
import 'package:kimikoe_app/widgets/buttons/image_input_button.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/widgets/forms/dropdown_menu_group_list.dart';
import 'package:kimikoe_app/widgets/forms/drum_roll_form.dart';
import 'package:kimikoe_app/widgets/forms/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/forms/text_form_with_controller.dart';
import 'package:kimikoe_app/widgets/forms/text_input_form.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({
    super.key,
    this.song,
    this.isEditing,
  });

  final Song? song;
  final bool? isEditing;

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _groupNameController;
  late TextEditingController _lyricistNameController;
  late TextEditingController _composerNameController;
  late TextEditingController _releaseDateController;

  // 歌詞とそこを歌う歌手
  final List<Map<String, String>> _lyricAndSingerList = [];
  final List<TextEditingController> _lyricListControllers = [];
  final List<TextEditingController> _singerListControllers = [];

  late Song _song;

  var _enteredTitle = '';
  File? _selectedImage;
  String? _selectedReleaseDate;
  var _enteredComment = '';

  late List<Map<String, dynamic>> _groupIdAndNameList;
  late List<Map<String, dynamic>> _artistIdAndNameList;

  var _isSending = false;
  var _isFetching = true;
  var _isImageChanged = false;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _fetchIdAndNameLists();

    // 編集の場合の初期化
    if (widget.song != null) {
      _song = widget.song!;
    }
    _isEditing = widget.isEditing!;
    // todo: 初期化
    if (_isEditing) {
      // imageUrl = fetchPublicImageUrl(_song.imageUrl!);

      _groupNameController = TextEditingController(text: _song.group!.name);
      _lyricistNameController =
          TextEditingController(text: _song.lyricist!.name);
      _composerNameController =
          TextEditingController(text: _song.composer!.name);
      _releaseDateController = TextEditingController(text: _song.releaseDate);
    } else {
      _groupNameController = TextEditingController();
      _lyricistNameController = TextEditingController();
      _composerNameController = TextEditingController();
      _releaseDateController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _lyricistNameController.dispose();
    _composerNameController.dispose();
    _releaseDateController.dispose();
    for (var controller in _lyricListControllers) {
      controller.dispose();
    }
    for (var controller in _singerListControllers) {
      controller.dispose();
    }
    super.dispose();
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

    // 歌詞と歌手のセットをjsonにする
    String jsonStringLyrics = jsonEncode(_lyricAndSingerList);

    // e.g. /aaa/bbb/ccc/image.png
    String? imagePath = getImagePath(
      isEditing: _isEditing,
      isImageChanged: _isImageChanged,
      imageUrl: _song.imageUrl,
      imageFile: _selectedImage,
    );

    if (_selectedReleaseDate == null || _selectedReleaseDate!.isEmpty) {
      _selectedReleaseDate = null;
    }

    // 入力グループ名がDBにない場合、グループ名とNo Imageを登録する
    int? selectedGroupId;
    int? selectedLyricistId;
    int? selectedComposerId;
    final groupName = _groupNameController.text;

    final isSelectedGroupInList = isInList(_groupIdAndNameList, groupName);
    if (!isSelectedGroupInList && groupName.isNotEmpty) {
      insertIdolGroupData(
        name: groupName,
        imageUrl: defaultPathNoImage,
        year: '',
        comment: '',
      );
      await _fetchIdAndNameLists();
    }
    selectedGroupId =
        fetchSelectedDataIdFromName(list: _groupIdAndNameList, name: groupName);
    // 作詞家登録
    final lyricistName = _lyricistNameController.text;
    final isSelectedLyricistInList =
        isInList(_artistIdAndNameList, lyricistName);
    if (!isSelectedLyricistInList && lyricistName.isNotEmpty) {
      insertArtistData(name: lyricistName, imageUrl: defaultPathNoImage);
      await _fetchIdAndNameLists();
    }
    selectedLyricistId = fetchSelectedDataIdFromName(
        list: _artistIdAndNameList, name: lyricistName);
    // 作曲家登録
    final composerName = _composerNameController.text;
    final isSelectedComposerInList =
        isInList(_artistIdAndNameList, composerName);
    if (!isSelectedComposerInList && composerName.isNotEmpty) {
      insertArtistData(name: composerName, imageUrl: defaultPathNoImage);
      await _fetchIdAndNameLists();
    }
    selectedComposerId = fetchSelectedDataIdFromName(
        list: _artistIdAndNameList, name: composerName);
    if (_isEditing) {
      // 歌詞編集
      updateSong(
        name: _enteredTitle,
        lyric: jsonStringLyrics,
        groupId: selectedGroupId,
        imagePath: imagePath,
        releaseDate: _selectedReleaseDate,
        lyricistId: selectedLyricistId,
        composerId: selectedComposerId,
        comment: _enteredComment,
        id: _song.id!,
      );
    } else {
      // 歌詞登録
      insertSongData(
        name: _enteredTitle,
        lyric: jsonStringLyrics,
        groupId: selectedGroupId,
        imagePath: imagePath,
        releaseDate: _selectedReleaseDate,
        lyricistId: selectedLyricistId,
        composerId: selectedComposerId,
        comment: _enteredComment,
      );
    }

    if (_selectedImage != null) {
      uploadImageToStorage(
        table: TableName.images.name,
        path: imagePath!,
        file: _selectedImage!,
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

  void _addNewLyricItem() {
    setState(() {
      _lyricListControllers.add(TextEditingController());
      _singerListControllers.add(TextEditingController());
      _lyricAndSingerList.add({'lyric': '', 'singer': ''});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isFetching
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: TopBar(
              title: _isEditing ? '歌詞編集' : '歌詞登録',
              showLeading: _isEditing ? true : false,
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
                        initialValue: _isEditing ? _song.title : _enteredTitle,
                        label: '*タイトル',
                        validator: _titleValidator,
                        onSaved: (value) {
                          _enteredTitle = value!;
                        },
                      ),
                      Gap(spaceS),
                      Text('歌詞と歌手はセットで登録してください。'),
                      Gap(spaceS),

                      for (int i = 0; i < _lyricAndSingerList.length; i++)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${i + 1}'),
                            TextFormWithController(
                              controller: _lyricListControllers[i],
                              label: '*歌詞',
                              validator: _titleValidator,
                              onSaved: (value) {
                                _lyricAndSingerList[i]['lyric'] = value ?? '';
                              },
                            ),
                            Gap(spaceS),
                            TextFormWithController(
                              controller: _singerListControllers[i],
                              label: '*歌手',
                              validator: _titleValidator,
                              onSaved: (value) {
                                _lyricAndSingerList[i]['singer'] = value ?? '';
                              },
                            ),
                            Gap(spaceS),
                          ],
                        ),
                      ElevatedButton(
                        onPressed: _addNewLyricItem,
                        child: Text('行を追加'),
                      ),
                      // ElevatedButton(
                      //   onPressed: _saveForm,
                      //   child: Text('保存'),
                      // ),
                      Gap(spaceS),
                      CustomDropdownMenu(
                        label: 'グループ選択',
                        dataList: _groupIdAndNameList,
                        controller: _groupNameController,
                      ),
                      Gap(spaceS),
                      ImageInput(
                        imageUrl: _song.imageUrl,
                        onPickImage: (image) {
                          _selectedImage = image;
                          _isImageChanged = true;
                        },
                        label: 'イメージ画像',
                      ),
                      Gap(spaceS),
                      CustomDropdownMenu(
                        label: '作詞家',
                        dataList: _artistIdAndNameList,
                        controller: _lyricistNameController,
                      ),
                      Gap(spaceS),
                      CustomDropdownMenu(
                        label: '作曲家',
                        dataList: _artistIdAndNameList,
                        controller: _composerNameController,
                      ),
                      Gap(spaceS),
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
                      Gap(spaceS),
                      ExpandedTextForm(
                        initialValue:
                            _isEditing ? _song.comment : _enteredComment,
                        onTextChanged: (value) {
                          setState(() {
                            _enteredComment = value!;
                          });
                        },
                        label: '備考',
                      ),
                      Gap(spaceS),
                      StyledButton(
                        '登録',
                        onPressed: _isSending ? null : _saveSong,
                        isSending: _isSending,
                        buttonSize: buttonL,
                      ),
                      Gap(spaceS),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
