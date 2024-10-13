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
  final List<Map<String, dynamic>> _lyricAndSingerList = [];
  final List<TextEditingController> _lyricListControllers = [];
  final List<TextEditingController> _singerListControllers = [];

  late Song _song;

  var _enteredTitle = '';
  File? _selectedImage;
  String? _selectedReleaseDate;
  var _enteredComment = '';

  late List<Map<String, dynamic>> _groupIdAndNameList;
  late List<Map<String, dynamic>> _idolIdAndNameList;
  late List<Map<String, dynamic>> _artistIdAndNameList;

  var _isSending = false;
  var _isFetching = true;
  var _isImageChanged = false;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    _isEditing = widget.isEditing ?? false;

    if (widget.song != null) {
      _song = widget.song!;
    }
    await _fetchIdAndNameLists();
    if (_isEditing) {
      _initializeEditingFields();
    } else {
      _initializeNewFields();
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

  void _initializeEditingFields() {
    final jsonLyrics = jsonDecode(_song.lyrics);
    _groupNameController = TextEditingController(text: _song.group!.name);
    _lyricistNameController = TextEditingController(text: _song.lyricist!.name);
    _composerNameController = TextEditingController(text: _song.composer!.name);
    _releaseDateController = TextEditingController(text: _song.releaseDate);
    // 歌詞と担当歌手データ
    for (var lyricData in jsonLyrics) {
      // singerIdから歌手の名前を取得
      final singerId = lyricData['singerId'];
      final selectedMember =
          _idolIdAndNameList.firstWhere((member) => member['id'] == singerId);

      _lyricAndSingerList.add(lyricData);
      _lyricListControllers
          .add(TextEditingController(text: lyricData['lyric']));
      _singerListControllers
          .add(TextEditingController(text: selectedMember['name'].toString()));
    }
  }

  void _initializeNewFields() {
    _groupNameController = TextEditingController();
    _lyricistNameController = TextEditingController();
    _composerNameController = TextEditingController();
    _releaseDateController = TextEditingController();
  }

  Future<void> _fetchIdAndNameLists() async {
    final groupList = await fetchIdAndNameList(TableName.idolGroups.name);
    final idolList = await fetchIdAndNameList(TableName.idol.name);
    final artistList = await fetchIdAndNameList(TableName.artists.name);
    setState(() {
      _groupIdAndNameList = groupList;
      _idolIdAndNameList = idolList;
      _artistIdAndNameList = artistList;
      _isFetching = false;
    });
  }

  Future<void> _saveSong() async {
    // setState(() {
    //   _isSending = true;
    // });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      setState(() {
        _isSending = false;
      });
      return;
    }

    // 「歌詞追加」の歌詞と歌手をjson形式でまとめる e.g. {'':,'singerId':idolId}
    for (var index = 0; index < _lyricAndSingerList.length; index++) {
      final idolId = fetchSelectedDataIdFromName(
          list: _idolIdAndNameList, name: _singerListControllers[index].text);
      _lyricAndSingerList[index]['singerId'] = idolId;
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
      currentTime: DateTime.now(),
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
      _lyricAndSingerList.add({'lyric': '', 'singerId': int});
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width / 3;
    return _isFetching
        ? const Center(child: CircularProgressIndicator())
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
                      const Text(
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
                      const Gap(spaceS),
                      // Text('グループを選ぶと歌手を絞り込めます。'),
                      // Gap(spaceS),
                      CustomDropdownMenu(
                        label: '*グループ選択',
                        dataList: _groupIdAndNameList,
                        controller: _groupNameController,
                      ),
                      const Gap(spaceS),
                      const Text('歌詞と歌手は一行単位のセットで登録してください。'),
                      const Gap(spaceS),
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
                            const Gap(spaceS),
                            CustomDropdownMenu(
                              label: '*歌手',
                              dataList: _idolIdAndNameList,
                              controller: _singerListControllers[i],
                            ),
                            const Gap(spaceS),
                          ],
                        ),
                      StyledButton(
                        '歌詞追加',
                        onPressed: _addNewLyricItem,
                        textColor: textGray,
                        backgroundColor: backgroundWhite,
                        buttonSize: buttonS,
                        borderSide: const BorderSide(
                            color: backgroundLightBlue, width: borderWidth),
                        width: buttonWidth,
                      ),
                      const Gap(spaceS),
                      ImageInput(
                        imageUrl: _song.imageUrl,
                        onPickImage: (image) {
                          _selectedImage = image;
                          _isImageChanged = true;
                        },
                        label: 'イメージ画像',
                      ),
                      const Gap(spaceS),
                      CustomDropdownMenu(
                        label: '作詞家',
                        dataList: _artistIdAndNameList,
                        controller: _lyricistNameController,
                      ),
                      const Gap(spaceS),
                      CustomDropdownMenu(
                        label: '作曲家',
                        dataList: _artistIdAndNameList,
                        controller: _composerNameController,
                      ),
                      const Gap(spaceS),
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
                      const Gap(spaceS),
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
                      const Gap(spaceS),
                      StyledButton(
                        '登録',
                        onPressed: _isSending ? null : _saveSong,
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
