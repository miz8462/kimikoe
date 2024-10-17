import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/user.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';
import 'package:kimikoe_app/widgets/forms/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/forms/text_input_form.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({
    super.key,
    required this.user,
    required this.isEditing,
  });
  final UserProfile user;
  final bool isEditing;

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredUserName = '';
  var _enteredEmailAddress = '';
  // File? _selectedImage;
  var _enteredComment = '';

  var _isSending = false;
  // var _isImageChanged = false;
  late UserProfile _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  String? _nameValidator(String? value) {
    return textInputValidator(value, '名前');
  }

  // todo: ちゃんとメール用のValidatorを作る
  String? _emailValidator(String? value) {
    return textInputValidator(value, 'メール');
  }

  void _saveUserProfile() async {
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

    final userId = supabase.auth.currentUser!.id;
    // todo: Googleアカウントの場合、初ログイン時に画像を登録するようにする。現状画像変更機能はなし。
    updateUser(
      name: _enteredUserName,
      email: _enteredEmailAddress,
      // imageUrl: imageUrl, 
      comment: _enteredComment,
      id: userId,
    );

    // if (_selectedImage != null) {
    //   await supabase.storage.from('images').upload(imagePath!, _selectedImage!);
    // }

    setState(() {
      _isSending = false;
    });

    if (!mounted) {
      return;
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      //buildが終わる前に画面遷移をしようとするとエラーになるので
      //buildが終わった後に画面遷移を実行
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RoutingPath.signIn);
      });
    }
    return Scaffold(
      appBar: const TopBar(title: 'ユーザー編集'),
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
                initialValue: _user.name,
                label: '*名前',
                validator: _nameValidator,
                onSaved: (value) {
                  _enteredUserName = value!;
                },
              ),
              const Gap(spaceS),
              InputForm(
                initialValue: _user.email,
                label: '*メール',
                validator: _emailValidator,
                onSaved: (value) {
                  _enteredEmailAddress = value!;
                },
              ),
              const Gap(spaceS),
              // todo: ユーザー画像変更
              // ImageInput(
              //   onPickImage: (image) {
              //     _selectedImage = image;
              //     _isImageChanged = true;
              //   },
              //   label: 'ユーザー画像',
              // ),
              // const Gap(spaceS),
              ExpandedTextForm(
                initialValue: _user.comment,
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
                onPressed: _isSending ? null : _saveUserProfile,
                isSending: _isSending,
              ),
              const Gap(spaceS),
            ],
          ),
        ),
      ),
    );
  }
}
