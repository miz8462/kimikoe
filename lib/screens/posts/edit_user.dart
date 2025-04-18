import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/user_profile.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase/supabase_provider.dart';
import 'package:kimikoe_app/providers/user_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_storage.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';
import 'package:kimikoe_app/widgets/button/image_input.dart';
import 'package:kimikoe_app/widgets/button/styled_button.dart';
import 'package:kimikoe_app/widgets/form/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/form/text_input_form.dart';

class EditUserScreen extends ConsumerStatefulWidget {
  const EditUserScreen({
    required this.isEditing,
    super.key,
  });
  final bool isEditing;

  @override
  ConsumerState<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredUserName = '';
  var _enteredEmailAddress = '';
  String? _selectedImage; // 初期値はnull
  var _enteredComment = '';

  var _isSending = false;

  String? _nameValidator(String? value) {
    return textInputValidator(value, '名前');
  }

  String? _emailValidator(String? value) {
    return textInputValidator(value, 'メール');
  }

  @override
  void initState() {
    super.initState();
    // 初期値をuser.imageUrlで設定
    final user = ref.read(userProfileProvider);
    if (user != null) {
      _selectedImage = user.imageUrl;
      _enteredUserName = user.name;
      _enteredEmailAddress = user.email;
      _enteredComment = user.comment;
    }
  }

  Future<void> _submitUserProfile() async {
    logger.i('フォーム送信開始: _selectedImage=$_selectedImage');

    setState(() {
      _isSending = true;
    });

    if (!_formKey.currentState!.validate()) {
      logger.i('ヴァリデーション失敗');
      setState(() {
        _isSending = false;
      });
      return;
    }
    _formKey.currentState!.save();
    logger.i('ヴァリデーション成功');

    final client = ref.watch(supabaseProvider);
    final userId = client.auth.currentUser!.id;
    final storage = SupabaseStorage(ref.watch(supabaseProvider));
    final currentUser = ref.watch(userProfileProvider)!;

    String? newImageUrl = currentUser.imageUrl;
    if (_selectedImage != null && _selectedImage != currentUser.imageUrl) {
      try {
        if (_selectedImage == noImage) {
          newImageUrl = noImage;
          logger.i('デフォルト画像を選択: $noImage');
        } else {
          final imageFile = File(_selectedImage!);
          if (!imageFile.existsSync()) {
            logger.e('画像ファイルが存在しません: $_selectedImage');
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('選択した画像ファイルが見つかりません')),
            );
            setState(() {
              _isSending = false;
            });
            return;
          }
          logger.i(
            '画像アップロード開始: '
            'path=$_selectedImage, '
            'size=${imageFile.lengthSync()} bytes',
          );

          final fileName =
              'user_images/$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';
          if (!mounted) return;

          await storage.uploadImageToStorage(
            path: fileName,
            file: imageFile,
            context: context,
          );

          final publicUrl = storage.fetchImageUrl(fileName);
          if (publicUrl == noImage) {
            logger.e('公開URLの取得に失敗: fileName=$fileName');
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('画像のURLを取得できませんでした')),
            );
            setState(() {
              _isSending = false;
            });
            return;
          }
          logger.i('公開URL取得成功: $publicUrl');
          newImageUrl = publicUrl;
        }
      } catch (e, stackTrace) {
        logger.e(
          '画像アップロードエラー: path=$_selectedImage',
          error: e,
          stackTrace: stackTrace,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('画像のアップロードに失敗しました: $e')),
        );
        setState(() {
          _isSending = false;
        });
        return;
      }
    }

    final user = UserProfile(
      id: userId,
      name: _enteredUserName,
      email: _enteredEmailAddress,
      imageUrl: newImageUrl,
      comment: _enteredComment,
    );

    logger.i('ユーザー情報更新: imageUrl=${user.imageUrl}, comment=${user.comment}');

    try {
      if (!mounted) return;
      await ref
          .read(userProfileProvider.notifier)
          .updateUserProfile(user, context, ref);
      logger.i('ユーザー情報更新成功');
    } catch (e, stackTrace) {
      logger.e('ユーザー情報更新エラー', error: e, stackTrace: stackTrace);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ユーザー情報の更新に失敗しました: $e')),
      );
      setState(() {
        _isSending = false;
      });
      return;
    }

    if (newImageUrl != currentUser.imageUrl &&
        currentUser.imageUrl != noImage) {
      try {
        logger.i('古い画像を削除: ${currentUser.imageUrl}');
        if (!mounted) return;
        await storage.deleteImageFromStorage(currentUser.imageUrl, context);
        logger.i('古い画像削除成功');
      } catch (e, stackTrace) {
        logger.e('古い画像削除エラー', error: e, stackTrace: stackTrace);
      }
    }

    setState(() {
      _isSending = false;
    });

    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RoutingPath.signIn);
      });
      return const SizedBox.shrink();
    }

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
                  key: Key(WidgetKeys.name),
                  initialValue: user.name,
                  label: '*名前',
                  validator: _nameValidator,
                  onSaved: (value) {
                    _enteredUserName = value!;
                  },
                ),
                const Gap(spaceS),
                InputForm(
                  key: Key(WidgetKeys.email),
                  initialValue: user.email,
                  label: '*メール',
                  validator: _emailValidator,
                  onSaved: (value) {
                    _enteredEmailAddress = value!;
                  },
                ),
                const Gap(spaceS),
                ImageInput(
                  imageUrl: user.imageUrl,
                  onPickImage: (image) {
                    setState(() {
                      _selectedImage = image.path;
                      logger.i('画像選択: $_selectedImage');
                    });
                  },
                ),
                const Gap(spaceS),
                ExpandedTextForm(
                  key: Key(WidgetKeys.comment),
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
                  '変更する',
                  key: Key(WidgetKeys.submit),
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
