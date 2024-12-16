import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/services/supabase_service.dart';
import 'package:kimikoe_app/utils/image_utils.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';
import 'package:kimikoe_app/widgets/button/image_input.dart';
import 'package:kimikoe_app/widgets/button/styled_button.dart';
import 'package:kimikoe_app/widgets/form/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/form/text_input_form.dart';

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

  Future<void> _submitArtist() async {
    logger.i('フォーム送信開始');

    setState(() {
      _isSending = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      logger.i('ヴァリデーション成功');
    } else {
      logger.w('ヴァリデーション失敗');
      setState(() {
        _isSending = false;
      });
    }

    FocusScope.of(context).unfocus();

    // e.g. /aaa/bbb/ccc/image.png
    final imagePath = createImagePath(
      imageFile: _selectedImage,
    );

    if (_selectedImage != null) {
      await uploadImageToStorage(
        table: TableName.images,
        path: imagePath,
        file: _selectedImage!,
        context: context,
        supabase: supabase,
      );
    }

    final imageUrl = fetchImageUrl(imagePath);

    if (!mounted) return;
    await insertArtistData(
      name: _enteredName,
      imageUrl: imageUrl,
      comment: _enteredComment,
      context: context,
      supabase: supabase,
    );

    setState(() {
      _isSending = false;
    });

    if (!mounted) {
      return;
    }

    context.pushReplacement(RoutingPath.groupList);
  }

  String? _nameValidator(String? value) {
    return textInputValidator(value, 'アーティスト名');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const TopBar(
        pageTitle: 'アーティスト登録',
        showLeading: false,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenHeight),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '*必須項目',
                    style: TextStyle(color: textGray),
                  ),
                  InputForm(
                    label: '*アーティスト名',
                    validator: _nameValidator,
                    onSaved: (value) => _enteredName = value!,
                  ),
                  const Gap(spaceS),
                  ImageInput(
                    onPickImage: (image) {
                      _selectedImage = image;
                    },
                    label: 'アーティスト画像',
                  ),
                  const Gap(spaceS),
                  ExpandedTextForm(
                    label: '備考',
                    onTextChanged: (value) {
                      setState(() {
                        _enteredComment = value!;
                      });
                    },
                  ),
                  const Gap(spaceS),
                  StyledButton(
                    '登録',
                    onPressed: _isSending ? null : _submitArtist,
                    isSending: _isSending,
                  ),
                  const Gap(spaceS),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
