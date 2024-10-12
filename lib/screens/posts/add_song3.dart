import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/widgets/forms/dropdown_menu_group_list.dart';
import 'package:kimikoe_app/widgets/forms/text_form_with_controller.dart';

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

  // 歌詞とそこを歌う歌手
  final List<Map<String, dynamic>> _lyricAndSingerList = [];
  final List<TextEditingController> _lyricListControllers = [];
  final List<TextEditingController> _singerListControllers = [];

  late Song _song;

  late List<Map<String, dynamic>> _idolIdAndNameList;

  var _isSending = false;
  var _isFetching = true;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _fetchIdAndNameLists();

    // 編集の場合の初期化
    if (widget.song != null) {
      _song = widget.song!;
    }
    final jsonLyrics = jsonDecode(_song.lyrics);
    _isEditing = widget.isEditing!;
    // todo: 初期化。歌詞・歌手リスト（なんかいい名前つけたい）
    if (_isEditing) {
      print(jsonLyrics);
      for (var lyricData in jsonLyrics) {
        _lyricAndSingerList.add(lyricData);
        _lyricListControllers
            .add(TextEditingController(text: lyricData['lyric']));
        _singerListControllers
            .add(TextEditingController(text: lyricData['singerId'].toString()));
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _lyricListControllers) {
      controller.dispose();
    }
    for (var controller in _singerListControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchIdAndNameLists() async {
    final idolList = await fetchIdAndNameList(TableName.idol.name);
    setState(() {
      _idolIdAndNameList = idolList;
      _isFetching = false;
    });
  }

  Future<void> _saveSong() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      setState(() {
        _isSending = false;
      });
      return;
    }

    // 「歌詞追加」の歌詞と歌手をjson形式でまとめる
    // e.g. {'lyric':'......','singerId':idolId}
    for (var index = 0; index < _lyricAndSingerList.length; index++) {
      final idolId = fetchSelectedDataIdFromName(
          list: _idolIdAndNameList, name: _singerListControllers[index].text);
      _lyricAndSingerList[index]['singerId'] = idolId;
    }
    print(_lyricAndSingerList);

    // 歌詞と歌手のセットをjsonにする
    String jsonStringLyrics = jsonEncode(_lyricAndSingerList);
    print(jsonStringLyrics);

    setState(() {
      _isSending = false;
    });

    if (!mounted) {
      return;
    }

    // context.pushReplacement(RoutingPath.groupList);
  }

  String? _titleValidator(String? value) {
    return textInputValidator(value, 'タイトル');
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
                            CustomDropdownMenu(
                              label: '*歌手',
                              dataList: _idolIdAndNameList,
                              controller: _singerListControllers[i],
                            ),
                            Gap(spaceS),
                          ],
                        ),
                      StyledButton(
                        '歌詞追加',
                        onPressed: _addNewLyricItem,
                        textColor: textGray,
                        backgroundColor: backgroundWhite,
                        buttonSize: buttonS,
                        borderSide: BorderSide(
                            color: backgroundLightBlue, width: borderWidth),
                        width: buttonWidth,
                      ),
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
