import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/group_songs_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_fetch.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_insert.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_update.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_utils.dart';
import 'package:kimikoe_app/utils/bool_check.dart';
import 'package:kimikoe_app/utils/date_formatter.dart';
import 'package:kimikoe_app/utils/image_utils.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';
import 'package:kimikoe_app/widgets/button/image_input.dart';
import 'package:kimikoe_app/widgets/button/styled_button.dart';
import 'package:kimikoe_app/widgets/form/custom_dropdown_menu.dart';
import 'package:kimikoe_app/widgets/form/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/form/picker_form.dart';
import 'package:kimikoe_app/widgets/form/text_form_with_controller.dart';
import 'package:kimikoe_app/widgets/form/text_input_form.dart';

class AddSongScreen extends ConsumerStatefulWidget {
  const AddSongScreen({
    super.key,
    this.song,
    this.isEditing,
  });

  final Song? song;
  final bool? isEditing;

  @override
  ConsumerState<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends ConsumerState<AddSongScreen> {
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
  var _enteredMovieUrl = '';
  File? _selectedImage;
  String? _selectedReleaseDate;
  var _enteredComment = '';

  late List<Map<String, dynamic>> _groupIdAndNameList;
  late List<Map<String, dynamic>> _idolIdAndNameList;
  late List<Map<String, dynamic>> _artistIdAndNameList;

  var _isSending = false;
  var _isFetching = true;
  var _isImageChanged = false;
  var _isGroupSelected = false;

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
    for (final controller in _lyricListControllers) {
      controller.dispose();
    }
    for (final controller in _singerListControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeEditingFields() {
    try {
      _isGroupSelected = true;
      // JSONデータをデコード
      final decodedLyrics = jsonDecode(_song.lyrics) as List;
      final jsonLyrics = decodedLyrics.map((item) {
        if (item is Map<String, dynamic>) {
          return {
            'lyric': item['lyric']?.toString() ?? '',
            'singerId': item['singerId']?.toString() ?? '',
          };
        }
        return {'lyric': '', 'singerId': ''};
      }).toList();

      _groupNameController = TextEditingController(text: _song.group!.name);
      _lyricistNameController = TextEditingController(
        text: _song.lyricist?.name ?? '',
      );
      _composerNameController = TextEditingController(
        text: _song.composer?.name ?? '',
      );
      _releaseDateController = TextEditingController(text: _song.releaseDate);

      // 歌詞と担当歌手データ
      for (final lyricData in jsonLyrics) {
        final singerId = int.tryParse(lyricData['singerId'] ?? '');
        final selectedMember = singerId != null
            ? _idolIdAndNameList.firstWhere(
                (member) => member['id'] == singerId,
                orElse: () => {'name': ''},
              )
            : {'name': ''};

        _lyricAndSingerList.add(lyricData);
        _lyricListControllers.add(
          TextEditingController(text: lyricData['lyric']),
        );
        _singerListControllers.add(
          TextEditingController(text: selectedMember['name'].toString()),
        );
      }
    } catch (e) {
      logger.e('歌詞データの初期化中にエラーが発生しました', error: e);
      // エラー時のフォールバック処理
      _groupNameController = TextEditingController(text: _song.group!.name);
      _lyricistNameController = TextEditingController();
      _composerNameController = TextEditingController();
      _releaseDateController = TextEditingController();
    }
  }

  void _initializeNewFields() {
    _groupNameController = TextEditingController();
    _lyricistNameController = TextEditingController();
    _composerNameController = TextEditingController();
    _releaseDateController = TextEditingController();
  }

  Future<void> _fetchIdAndNameLists() async {
    final groupList = await fetchIdAndNameList(
      TableName.idolGroups,
      supabase: supabase,
    );
    final idolList = await fetchIdAndNameList(
      TableName.idols,
      supabase: supabase,
    );
    final artistList = await fetchIdAndNameList(
      TableName.artists,
      supabase: supabase,
    );
    setState(() {
      _groupIdAndNameList = groupList;
      _idolIdAndNameList = idolList;
      _artistIdAndNameList = artistList;
      _isFetching = false;
    });
  }

  Future<void> _submitSong() async {
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

    if (!_isGroupSelected) return;

    logger.i('フォーム送信開始');

    setState(() {
      _isSending = true;
    });

    FocusScope.of(context).unfocus();

    // 歌詞と歌手のセットをまとめる
    for (var index = 0; index < _lyricAndSingerList.length; index++) {
      final singerName = _singerListControllers[index].text;
      if (singerName.isNotEmpty) {
        final idolId = findDataIdByName(
          list: _idolIdAndNameList,
          name: singerName,
        );
        _lyricAndSingerList[index]['singerId'] = idolId?.toString() ?? '';
      } else {
        _lyricAndSingerList[index]['singerId'] = '';
      }
    }

    // 歌詞と歌手のセットをjsonにする
    final jsonStringLyrics = jsonEncode(_lyricAndSingerList);

    final imageUrl = await processImage(
      isEditing: _isEditing,
      isImageChanged: _isImageChanged,
      existingImageUrl: _song.imageUrl,
      selectedImage: _selectedImage,
      context: context,
    );

    if (imageUrl == null) {
      // 画像URLが取得できなかった場合の処理
      logger.e('画像URLが取得できませんでした。');
    } else {
      logger.i(imageUrl);
    }

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
      if (!mounted) return;
      await insertIdolGroupData(
        name: groupName,
        imageUrl: noImage,
        year: '',
        comment: '',
        context: context,
        supabase: supabase,
      );
      await _fetchIdAndNameLists();
    }
    selectedGroupId =
        findDataIdByName(list: _groupIdAndNameList, name: groupName);
    // 作詞家登録
    final lyricistName = _lyricistNameController.text;
    final isSelectedLyricistInList =
        isInList(_artistIdAndNameList, lyricistName);
    if (!isSelectedLyricistInList && lyricistName.isNotEmpty) {
      if (!mounted) return;
      await insertArtistData(
        name: lyricistName,
        imageUrl: noImage,
        context: context,
        supabase: supabase,
      );
      await _fetchIdAndNameLists();
    }
    if (lyricistName.isNotEmpty) {
      selectedLyricistId = findDataIdByName(
        list: _artistIdAndNameList,
        name: lyricistName,
      );
    }

    // 作曲家登録
    final composerName = _composerNameController.text;
    final isSelectedComposerInList =
        isInList(_artistIdAndNameList, composerName);
    if (!isSelectedComposerInList && composerName.isNotEmpty) {
      if (!mounted) return;
      await insertArtistData(
        name: composerName,
        imageUrl: noImage,
        context: context,
        supabase: supabase,
      );
      await _fetchIdAndNameLists();
    }
    if (composerName.isNotEmpty) {
      selectedComposerId = findDataIdByName(
        list: _artistIdAndNameList,
        name: composerName,
      );
    }

    // 登録、編集
    if (!mounted) return;
    if (_isEditing) {
      await updateSong(
        title: _enteredTitle,
        movieUrl: _enteredMovieUrl,
        lyric: jsonStringLyrics,
        groupId: selectedGroupId,
        imageUrl: imageUrl,
        releaseDate: _selectedReleaseDate,
        lyricistId: selectedLyricistId,
        composerId: selectedComposerId,
        comment: _enteredComment,
        id: _song.id!,
        context: context,
        supabase: supabase,
      );
    } else {
      await insertSongData(
        title: _enteredTitle,
        movieUrl: _enteredMovieUrl,
        lyric: jsonStringLyrics,
        groupId: selectedGroupId,
        imageUrl: imageUrl,
        releaseDate: _selectedReleaseDate,
        lyricistId: selectedLyricistId,
        composerId: selectedComposerId,
        comment: _enteredComment,
        context: context,
        supabase: supabase,
      );
    }

    // groupSongsProviderを呼び出す前にnullチェック
    if (selectedGroupId != null) {
      ref.watch(groupSongsProvider(selectedGroupId));
    } else {
      logger.w('グループIDがnullのため、groupSongsProviderは更新されません');
    }

    setState(() {
      _isSending = false;
    });

    if (!mounted) return;
    context.pushReplacement(RoutingPath.groupList);
  }

  String? _titleValidator(String? value) {
    return textInputValidator(value, 'タイトル');
  }

  String? _lyricValidator(String? value) {
    return textInputValidator(value, '歌詞');
  }

  Future<void> _pickReleaseDate() async {
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

  void _updateGroupSelected({required bool isSelected}) {
    setState(() {
      _isGroupSelected = isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isFetching
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: TopBar(
              pageTitle: _isEditing ? '歌詞編集' : '歌詞登録',
              showLeading: _isEditing,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        key: Key(WidgetKeys.title),
                        initialValue: _isEditing ? _song.title : _enteredTitle,
                        label: '*タイトル',
                        validator: _titleValidator,
                        onSaved: (value) {
                          _enteredTitle = value!;
                        },
                      ),
                      const Gap(spaceS),
                      // TODO: 未実装
                      // Text('グループを選ぶと歌手を絞り込めます。'),
                      // Gap(spaceS),
                      CustomDropdownMenu(
                        key: Key(WidgetKeys.group),
                        label: '*グループ選択',
                        dataList: _groupIdAndNameList,
                        controller: _groupNameController,
                        isSelected: _isGroupSelected,
                        onSelectedChanged: _updateGroupSelected,
                      ),
                      const Gap(spaceS),
                      const Text('歌詞と歌手はワンフレーズのセットで登録'),
                      const Gap(spaceS),
                      for (int i = 0; i < _lyricAndSingerList.length; i++)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${i + 1}'),
                            TextFormWithController(
                              key: Key('lyric-$i'),
                              controller: _lyricListControllers[i],
                              label: '*歌詞',
                              validator: _lyricValidator,
                              onSaved: (value) {
                                _lyricAndSingerList[i]['lyric'] = value ?? '';
                              },
                            ),
                            const Gap(spaceS),
                            CustomDropdownMenu(
                              key: Key('singer-$i'),
                              label: '*歌手',
                              dataList: _idolIdAndNameList,
                              controller: _singerListControllers[i],
                            ),
                            const Gap(spaceS),
                          ],
                        ),
                      StyledButton(
                        key: Key(WidgetKeys.addLyric),
                        '歌詞追加',
                        onPressed: _addNewLyricItem,
                        backgroundColor: mainColor.withValues(alpha: 0.7),
                      ),
                      const Gap(spaceS),
                      InputForm(
                        key: Key(WidgetKeys.movie),
                        initialValue:
                            _isEditing ? _song.movieUrl : _enteredMovieUrl,
                        label: 'YouTube動画URL',
                        validator: urlValidator,
                        onSaved: (value) {
                          _enteredMovieUrl = value!;
                        },
                      ),
                      const Gap(spaceS),
                      ImageInput(
                        imageUrl: _song.imageUrl,
                        onPickImage: (image) {
                          _selectedImage = image;
                          _isImageChanged = true;
                        },
                      ),
                      const Gap(spaceS),
                      CustomDropdownMenu(
                        key: Key(WidgetKeys.lyricist),
                        label: '作詞家',
                        dataList: _artistIdAndNameList,
                        controller: _lyricistNameController,
                      ),
                      const Gap(spaceS),
                      CustomDropdownMenu(
                        key: Key(WidgetKeys.composer),
                        label: '作曲家',
                        dataList: _artistIdAndNameList,
                        controller: _composerNameController,
                      ),
                      const Gap(spaceS),
                      PickerForm(
                        key: Key(WidgetKeys.releaseDate),
                        label: '発売日',
                        controller: _releaseDateController,
                        picker: _pickReleaseDate,
                        onSaved: (value) {
                          setState(
                            () {
                              _selectedReleaseDate = value;
                            },
                          );
                        },
                      ),
                      const Gap(spaceS),
                      ExpandedTextForm(
                        key: Key(WidgetKeys.comment),
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
                        key: Key(WidgetKeys.submit),
                        '登録',
                        onPressed: _submitSong,
                        // _isSending ? null : _submitSong,
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
