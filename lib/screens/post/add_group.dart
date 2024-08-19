import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/provider/groups_notifier.dart';
import 'package:kimikoe_app/widgets/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/image_input.dart';
import 'package:kimikoe_app/widgets/styled_button.dart';

class AddGroupScreen extends ConsumerStatefulWidget {
  const AddGroupScreen({super.key});

  @override
  ConsumerState<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends ConsumerState<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _selectedImage;
  final _yearController = TextEditingController(text: '2000');
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _saveGroup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    final enteredName = _nameController.text;
    final enteredTextYear = _yearController.text;
    final enteredComment = _commentController.text;

    final enteredYear = int.parse(enteredTextYear);

    if (enteredName.isEmpty) {
      return;
    }
    final imagePath = _selectedImage?.path.split('/').last;

    ref.read(groupsProvider.notifier).addGroup(
          enteredName,
          imagePath,
          enteredYear,
          enteredComment,
        );

    await supabase.from('groups').insert({
      'name': enteredName,
      'image_url': imagePath,
      'year_forming_group': enteredYear,
      'comment': enteredComment
    });

    if (_selectedImage != null) {
      await supabase.storage
          .from('images')
          .upload(imagePath!, _selectedImage!);
    }

    if (!mounted) {
      return;
    }

    context.pushReplacement('/home');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
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
              // todo: クラスウィジェット作る
              Container(
                color: backgroundLightBlue,
                child: TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    label: Text('*グループ名'),
                    hintStyle: TextStyle(color: textGray),
                    contentPadding: EdgeInsets.only(left: spaceWidthS),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length > 50) {
                      return 'グループ名は50文字以下にしてください。';
                    }
                    return null;
                  },
                  controller: _nameController,
                ),
              ),
              const Gap(spaceWidthS),
              ImageInput(
                onPickImage: (image) {
                  _selectedImage = image;
                },
              ),
              const Gap(spaceWidthS),
              Container(
                color: backgroundLightBlue,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    label: Text('結成年'),
                    hintStyle: TextStyle(color: textGray),
                    contentPadding: EdgeInsets.only(left: spaceWidthS),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return '結成年は数字を入力してください。';
                    }
                    return null;
                  },
                  controller: _yearController,
                ),
              ),
              const Gap(spaceWidthS),
              ExpandedTextForm(label: '備考', controller: _commentController),
              const Gap(spaceWidthS),
              StyledButton(
                '登録',
                onPressed: () {
                  _saveGroup();
                },
                buttonSize: buttonL,
              ),
              const Gap(spaceWidthS),
            ],
          ),
        ),
      ),
    );
  }
}
