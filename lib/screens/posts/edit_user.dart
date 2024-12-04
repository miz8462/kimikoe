import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/user.dart';
import 'package:kimikoe_app/providers/user_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';
import 'package:kimikoe_app/widgets/button/styled_button.dart';
import 'package:kimikoe_app/widgets/form/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/form/text_input_form.dart';

class EditUserScreen extends ConsumerStatefulWidget {
  const EditUserScreen({
    super.key,
    required this.isEditing,
  });
  final bool isEditing;

  @override
  ConsumerState<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredUserName = '';
  var _enteredEmailAddress = '';
  String? _selectedImage;
  var _enteredComment = '';

  var _isSending = false;
  // var _isImageChanged = false;

  String? _nameValidator(String? value) {
    return textInputValidator(value, '名前');
  }

  // todo: ちゃんとメール用のValidatorを作る
  String? _emailValidator(String? value) {
    return textInputValidator(value, 'メール');
  }

  void _submitUserProfile() async {
    logger.i('フォーム送信開始');

    setState(() {
      _isSending = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      logger.i('ヴァリデーション成功');
    } else {
      logger.i('ヴァリデーション失敗');
      setState(() {
        _isSending = false;
      });
      return;
    }

    final userId = supabase.auth.currentUser!.id;
    final user = UserProfile(
      id: userId,
      name: _enteredUserName,
      email: _enteredEmailAddress,
      imageUrl: _selectedImage!,
      comment: _enteredComment,
    );

    await ref
        .read(userProfileProvider.notifier)
        .updateUserProfile(user, context);

    // todo: ユーザー画像の変更機能
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
    final user = ref.watch(userProfileProvider);
    // final currentUser = supabase.auth.currentUser;
    if (user == null) {
      //buildが終わる前に画面遷移をしようとするとエラーになるので
      //buildが終わった後に画面遷移を実行
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RoutingPath.signIn);
      });
    }
    _selectedImage = user!.imageUrl;
    return Scaffold(
      appBar: const TopBar(pageTitle: 'ユーザー編集'),
      body: Padding(
        padding: screenPadding,
        child: SingleChildScrollView(
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
                  initialValue: user.name,
                  label: '*名前',
                  validator: _nameValidator,
                  onSaved: (value) {
                    _enteredUserName = value!;
                  },
                ),
                const Gap(spaceS),
                InputForm(
                  initialValue: user.email,
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
                  initialValue: user.comment,
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
                  onPressed: _isSending ? null : _submitUserProfile,
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
