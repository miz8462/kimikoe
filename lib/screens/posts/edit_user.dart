import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/user.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/widgets/buttons/image_input_button.dart';
import 'package:kimikoe_app/screens/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/screens/widgets/forms/expanded_text_form.dart';
import 'package:kimikoe_app/screens/widgets/forms/text_input_form.dart';
import 'package:kimikoe_app/utils/create_image_name_with_jpg.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({
    super.key,
    this.user,
  });
  final UserProfile? user;

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredUserName = '';
  var _enteredEmailAddress = '';
  File? _selectedImage;
  var _enteredComment = '';

  var _isSending = false;

  String? _nameValidator(String? value) {
    return textInputValidator(value, '名前');
  }

  // todo: ちゃんとメール用のValidatorを作る
  String? _emailValidator(String? value) {
    return textInputValidator(value, 'メール');
  }

  void _updateUserProfile() async {
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
    final imagePathWithCreatedAtJPG =
        createImageNameWithJPG(image: _selectedImage);

    final userId = supabase.auth.currentUser!.id;

    await supabase.from('profiles').update({
      'username': _enteredUserName,
      'email': _enteredEmailAddress,
      'image_url': _selectedImage == null
          ? widget.user!.imageUrl
          : imagePathWithCreatedAtJPG,
      'comment': _enteredComment,
    }).eq(
      'id',
      userId,
    );

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
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = supabase.auth.currentUser;
    final user = widget.user;
    if (currentUser == null) {
      //buildが終わる前に画面遷移をしようとするとエラーになるので
      //buildが終わった後に画面遷移を実行
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RoutingPath.signIn);
      });
    }
    return Scaffold(
      appBar: TopBar(title: 'ユーザー編集'),
      body: Padding(
        padding: screenPadding,
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
                initialValue: user?.name,
                label: '*名前',
                validator: _nameValidator,
                onSaved: (value) {
                  _enteredUserName = value!;
                },
              ),
              const Gap(spaceS),
              InputForm(
                initialValue: user?.email,
                label: '*メール',
                validator: _emailValidator,
                onSaved: (value) {
                  _enteredEmailAddress = value!;
                },
              ),
              const Gap(spaceS),
              ImageInput(
                onPickImage: (image) {
                  _selectedImage = image;
                },
                label: 'ユーザー画像',
              ),

              const Gap(spaceS),
              // 備考欄
              ExpandedTextForm(
                initialValue: user?.comment,
                onTextChanged: (value) {
                  setState(() {
                    _enteredComment = value!;
                  });
                },
                label: '備考',
              ),
              const Gap(spaceS),
              // 登録ボタン
              StyledButton(
                '登録',
                onPressed: _isSending ? null : _updateUserProfile,
                isSending: _isSending,
                buttonSize: buttonL,
              ),
              const Gap(spaceS),
            ],
          ),
        ),
      ),
    );
  }
}
