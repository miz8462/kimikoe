import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/widgets/buttons/image_input_button.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/widgets/expanded_text_form.dart';

class AddArtistScreen extends StatefulWidget {
  const AddArtistScreen({super.key});

  @override
  State<AddArtistScreen> createState() => _AddArtistScreenState();
}

class _AddArtistScreenState extends State<AddArtistScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredComment = '';
  File? _selectedImage;

  var _isSending = false;

  Future<void> _saveArtist() async {
    setState(() {
      _isSending = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    // e.g. /aaa/bbb/ccc/image.png
    final imagePath = _selectedImage?.path.split('/').last.split('.').first;
    final imagePathWithCreatedAtJPG =
        '$imagePath${(DateTime.now().toString()).replaceAll(' ', '-')}.jpg';

    await supabase.from('artists').insert({
      'name': _enteredName,
      'image_url': imagePathWithCreatedAtJPG,
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height - 100;

    return Scaffold(
      appBar: TopBar(
        title: 'アーティスト登録',
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
                Text(
                  '*必須項目',
                  style: TextStyle(color: textGray),
                ),
                Container(
                  color: backgroundLightBlue,
                  child: TextFormField(
                    maxLength: 50,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      label: Text('*アーティスト名'),
                      hintStyle: TextStyle(color: textGray),
                      contentPadding: EdgeInsets.only(left: spaceWidthS),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length > 50) {
                        return 'アーティスト名は50文字以下にしてください。';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredName = value!;
                    },
                  ),
                ),
                Gap(spaceWidthS),
                ImageInput(
                  onPickImage: (image) {
                    _selectedImage = image;
                  },
                  label: 'アーティスト画像',
                ),
                Gap(spaceWidthS),
                ExpandedTextForm(
                  label: '備考',
                  onTextChanged: (value) {
                    setState(() {
                      _enteredComment = value!;
                    });
                  },
                ),
                Gap(spaceWidthS),
                // 登録ボタン
                StyledButton(
                  '登録',
                  onPressed: _isSending
                      ? null
                      : () {
                          _saveArtist();
                        },
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
