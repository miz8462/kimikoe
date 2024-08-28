import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/provider/groups_notifier.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/widgets/buttons/image_input_button.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/widgets/forms/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/forms/text_input_form.dart';

const String defaultPathNoImage = 'no-images.png';

class AddGroupScreen extends ConsumerStatefulWidget {
  const AddGroupScreen({super.key});

  @override
  ConsumerState<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends ConsumerState<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  File? _selectedImage;
  var _enteredYear = '';
  var _enteredComment = '';

  var _isSending = false;

  Future<void> _saveGroup() async {
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

    if (int.tryParse(_enteredYear) == null) {
      setState(() {
        _isSending = false;
      });
      return;
    }

    // e.g. /aaa/bbb/ccc/image.png
    final imagePath = _selectedImage?.path.split('/').last.split('.').first;
    final imagePathWithCreatedAtJPG =
        '$imagePath${(DateTime.now().toString()).replaceAll(' ', '-')}.jpg';

    ref.read(groupsProvider.notifier).addGroup(
          _enteredName,
          _selectedImage == null
              ? defaultPathNoImage
              : imagePathWithCreatedAtJPG,
          int.parse(_enteredYear),
          _enteredComment,
        );

    await supabase.from('idol-groups').insert({
      'name': _enteredName,
      'image_url': _selectedImage == null
          ? defaultPathNoImage
          : imagePathWithCreatedAtJPG,
      'year_forming_group': _enteredYear,
      'comment': _enteredComment
    });

    if (_selectedImage != null) {
      await supabase.storage
          .from('images')
          .upload(imagePathWithCreatedAtJPG, _selectedImage!);
    }
    setState(() {
      _isSending = false;
    });

    if (!mounted) {
      return;
    }

    context.pushReplacement('/group_list');
  }

  String? _groupNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'グループ名を入力してください。';
    } else if (value.trim().length > 50) {
      return 'グループ名は50文字以下にしてください。';
    }
    return null;
  }

  String? _yearValidator(String? value) {
    if (value == null || value.isEmpty || int.tryParse(value) == null) {
      return '結成年は数字を入力してください。';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: TopBar(
        title: 'グループ登録',
        showLeading: false,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenHeight),
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
                  label: '*グループ名',
                  validator: _groupNameValidator,
                  onSaved: (value) {
                    _enteredName = value!;
                  },
                ),
                const Gap(spaceWidthS),
                ImageInput(
                  onPickImage: (image) {
                    _selectedImage = image;
                  },
                  label: 'グループ画像',
                ),
                const Gap(spaceWidthS),
                InputForm(
                  label: '結成年',
                  validator: _yearValidator,
                  onSaved: (value) {
                    _enteredYear = value!;
                  },
                ),
                const Gap(spaceWidthS),
                ExpandedTextForm(
                  onTextChanged: (value) {
                    setState(() {
                      _enteredComment = value!;
                    });
                  },
                  label: '備考',
                ),
                const Gap(spaceWidthS),
                StyledButton(
                  '登録',
                  onPressed: _isSending
                      ? null
                      : () {
                          _saveGroup();
                        },
                  isSending: _isSending,
                  buttonSize: buttonL,
                ),
                const Gap(spaceWidthS),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
