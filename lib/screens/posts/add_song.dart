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
import 'package:kimikoe_app/providers/supabase/supabase_services_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_services.dart';
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

  // 歌詞とそのフレーズを歌う歌手
  final List<Map<String, dynamic>> _lyricAndSingerList = [];
  final List<TextEditingController> _lyricListControllers = [];
  final List<List<TextEditingController>> _singerListControllers = [];

  late Song _song;

  var _enteredTitle = '';
  var _enteredMovieUrl = '';
  File? _selectedImage;
  String? _selectedReleaseDate;
  var _enteredComment = '';

  List<Map<String, dynamic>> _groupIdAndNameList = [];
  List<Map<String, dynamic>> _idolIdAndNameList = [];
  List<Map<String, dynamic>> _artistIdAndNameList = [];
  List<Map<String, dynamic>> _filteredIdolList = [];
  int? _selectedGroupId;

  var _isSending = false;
  var _isFetching = true;
  var _isFetchingIdols = false;
  var _isImageChanged = false;
  var _isGroupSelected = false;

  late bool _isEditing;

  late SupabaseServices _service;

  @override
  void initState() {
    super.initState();
    _service = ref.read(supabaseServicesProvider);
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
      if (_song.group != null) {
        _selectedGroupId = _song.group!.id;
        setState(() {
          _isFetchingIdols = true;
        });
        final filterdIdols =
            await _service.fetch.fetchGroupMembers(_selectedGroupId!);
        setState(() {
          _filteredIdolList = filterdIdols;
          _isFetchingIdols = false;
        });
      }
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
    for (final controllers in _singerListControllers) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _initializeEditingFields() {
    try {
      _isGroupSelected = true;
      final decodedLyrics = jsonDecode(_song.lyrics) as List;
      final jsonLyrics = decodedLyrics.map((item) {
        if (item is Map<String, dynamic>) {
          return {
            'lyric': item['lyric']?.toString() ?? '',
            'singerIds': (item['singerIds'] as List<dynamic>?)?.cast<String>(),
          };
        }
        return {
          'lyric': '',
          'singerIds': [''],
        };
      }).toList();

      _groupNameController = TextEditingController(text: _song.group!.name);
      _lyricistNameController =
          TextEditingController(text: _song.lyricist?.name ?? '');
      _composerNameController =
          TextEditingController(text: _song.composer?.name ?? '');
      _releaseDateController = TextEditingController(text: _song.releaseDate);

      for (final lyricData in jsonLyrics) {
        final singerIds = (lyricData['singerIds'] as List<String>?) ?? [];
        _lyricAndSingerList.add({
          'lyric': lyricData['lyric'],
          'singerIds': lyricData['singerIds'],
        });
        _lyricListControllers
            .add(TextEditingController(text: lyricData['lyric']! as String));
        final singerControllers = <TextEditingController>[];
        for (final singerId in singerIds) {
          final selectedMember = singerId.isNotEmpty
              ? _idolIdAndNameList.firstWhere(
                  (member) => member['id'].toString() == singerId,
                  orElse: () => {'name': ''},
                )
              : {'name': ''};
          singerControllers.add(
            TextEditingController(text: selectedMember['name'].toString()),
          );
        }
        _singerListControllers.add(singerControllers);
      }
    } catch (e) {
      logger.e('歌詞データの初期化中にエラーが発生しました', error: e);
      _groupNameController = TextEditingController(text: _song.group!.name);
      _lyricistNameController = TextEditingController();
      _composerNameController = TextEditingController();
      _releaseDateController = TextEditingController();
      _lyricAndSingerList.add({
        'lyric': '',
        'singerIds': [''],
      });
      _lyricListControllers.add(TextEditingController());
      _singerListControllers.add([TextEditingController()]);
    }
  }

  void _initializeNewFields() {
    _groupNameController = TextEditingController();
    _lyricistNameController = TextEditingController();
    _composerNameController = TextEditingController();
    _releaseDateController = TextEditingController();
    // 歌詞用のコントローラー
    _lyricAndSingerList.add({
      'lyric': '',
      'singerIds': [''],
    });
    _lyricListControllers.add(TextEditingController());
    _singerListControllers.add([TextEditingController()]);
  }

  Future<void> _fetchIdAndNameLists() async {
    final groupList = await _service.fetch.fetchIdAndNameList(
      TableName.idolGroups,
    );
    final idolList = await _service.fetch.fetchIdAndNameList(
      TableName.idols,
    );
    final artistList = await _service.fetch.fetchIdAndNameList(
      TableName.artists,
    );
    setState(() {
      _groupIdAndNameList = groupList;
      _idolIdAndNameList = idolList;
      _artistIdAndNameList = artistList;
      _filteredIdolList = idolList;
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
    for (var i = 0; i < _lyricAndSingerList.length; i++) {
      final singerIds = <String>[];
      for (var j = 0; j < _singerListControllers[i].length; j++) {
        final singerName = _singerListControllers[i][j].text;
        if (singerName.isNotEmpty) {
          final idolId = _service.utils
              .findDataIdByName(list: _idolIdAndNameList, name: singerName);
          if (idolId != null) singerIds.add(idolId.toString());
        }
      }
      _lyricAndSingerList[i]['singerIds'] = singerIds;
    }
    final jsonStringLyrics = jsonEncode(_lyricAndSingerList);

    final storage = ref.watch(supabaseServicesProvider).storage;
    final imageUrl = await processImage(
      isEditing: _isEditing,
      isImageChanged: _isImageChanged,
      existingImageUrl: _song.imageUrl,
      selectedImage: _selectedImage,
      context: context,
      storage: storage,
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
      await _service.insert.insertIdolGroupData(
        name: groupName,
        imageUrl: noImage,
        year: '',
        comment: '',
        context: context,
      );
      await _fetchIdAndNameLists();
    }

    selectedGroupId = _service.utils
        .findDataIdByName(list: _groupIdAndNameList, name: groupName);

    // 作詞家登録
    final lyricistName = _lyricistNameController.text;
    final isSelectedLyricistInList =
        isInList(_artistIdAndNameList, lyricistName);
    if (!isSelectedLyricistInList && lyricistName.isNotEmpty) {
      if (!mounted) return;
      await _service.insert.insertArtistData(
        name: lyricistName,
        imageUrl: noImage,
        context: context,
      );
      await _fetchIdAndNameLists();
    }
    if (lyricistName.isNotEmpty) {
      selectedLyricistId = _service.utils.findDataIdByName(
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
      await _service.insert.insertArtistData(
        name: composerName,
        imageUrl: noImage,
        context: context,
      );
      await _fetchIdAndNameLists();
    }
    if (composerName.isNotEmpty) {
      selectedComposerId = _service.utils.findDataIdByName(
        list: _artistIdAndNameList,
        name: composerName,
      );
    }

    // 登録、編集>
    if (!mounted) return;
    if (_isEditing) {
      await _service.update.updateSong(
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
      );
    } else {
      await _service.insert.insertSongData(
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
      );
    }

    // groupSongsProviderを呼び出す前にnullチェック
    ref.watch(groupSongsProvider(selectedGroupId!));

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
      _lyricAndSingerList.add({
        'lyric': '',
        'singerIds': [''],
      });
    });
    _lyricListControllers.add(TextEditingController());
    _singerListControllers.add([TextEditingController()]);
  }

  void _removeLyricItem(int index) {
    setState(() {
      _lyricListControllers[index].dispose();
      for (final controller in _singerListControllers[index]) {
        controller.dispose();
      }

      _lyricAndSingerList.removeAt(index);
      _lyricListControllers.removeAt(index);
      _singerListControllers.removeAt(index);
    });
  }

  void _addSinger(int lyricIndex) {
    setState(() {
      (_lyricAndSingerList[lyricIndex]['singerIds'] as List<String>).add('');
      _singerListControllers[lyricIndex].add(TextEditingController());
    });
  }

  void _removeSinger(int lyricIndex, int singerIndex) {
    setState(() {
      (_lyricAndSingerList[lyricIndex]['singerIds'] as List<String>)
          .removeAt(singerIndex);
      _singerListControllers[lyricIndex][singerIndex].dispose();
      _singerListControllers[lyricIndex].removeAt(singerIndex);
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
                        onSelected: (String groupId) async {
                          setState(() {
                            _selectedGroupId = int.tryParse(groupId);
                            _isFetchingIdols = true;
                          });
                          try {
                            if (_selectedGroupId != null) {
                              final filteredIdols = await _service.fetch
                                  .fetchGroupMembers(_selectedGroupId!);
                              setState(() {
                                _filteredIdolList = filteredIdols;
                                _isFetchingIdols = false;
                              });
                            } else {
                              setState(() {
                                _filteredIdolList = _idolIdAndNameList;
                                _isFetchingIdols = false;
                              });
                            }
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('グループメンバーの取得に失敗しました: $e')),
                            );
                            setState(() {
                              _filteredIdolList = _idolIdAndNameList;
                              _isFetchingIdols = false;
                            });
                          }
                        },
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
                              key: Key('${WidgetKeys.lyric}_$i'),
                              controller: _lyricListControllers[i],
                              label: '*歌詞',
                              validator: _lyricValidator,
                              onSaved: (value) {
                                _lyricAndSingerList[i]['lyric'] = value ?? '';
                              },
                            ),
                            const Gap(spaceS),
                            ...List.generate(
                              _singerListControllers[i].length,
                              (j) => Row(
                                children: [
                                  Expanded(
                                    child: CustomDropdownMenu(
                                      key: ValueKey(
                                        _singerListControllers[i][j].hashCode,
                                      ),
                                      label: j == 0 ? '*歌手1' : '歌手${j + 1}（任意）',
                                      dataList: _isFetchingIdols
                                          ? []
                                          : _filteredIdolList,
                                      controller: _singerListControllers[i][j],
                                      isSelected: _singerListControllers[i][j]
                                          .text
                                          .isNotEmpty,
                                      onSelected: (value) {
                                        setState(() {
                                          (_lyricAndSingerList[i]['singerIds']
                                              as List<String>)[j] = value;
                                          if (j ==
                                              _singerListControllers[i].length -
                                                  1) {
                                            _addSinger(i);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  if (j > 0)
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () => _removeSinger(i, j),
                                    ),
                                ],
                              ),
                            ),
                            TextButton(
                              key: Key('remove-lyric-$i'),
                              onPressed: () => _removeLyricItem(i),
                              child: const Text('このフレーズを削除する'),
                            ),
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
