import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/provider/groups_notifier.dart';
import 'package:kimikoe_app/widgets/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/styled_button.dart';

class AddGroupScreen extends ConsumerStatefulWidget {
  const AddGroupScreen({super.key});

  @override
  ConsumerState<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends ConsumerState<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  // File? _selectedImage;
  final _yearController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _saveGroup() async {
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

    ref.read(groupsProvider.notifier).addGroup(
          enteredName,
          // _selectedImage,
          enteredYear,
          enteredComment,
        );

    await supabase.from('group').insert({
      'name': enteredName,
      'year_forming_group': enteredYear,
      'comment': enteredComment
    });

    if (!mounted) {
      return;
    }

    context.pushReplacement('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
          StyledButton(
            'グループ画像',
            onPressed: () {},
            textColor: textGray,
            backgroundColor: backgroundWhite,
            buttonSize: buttonS,
            borderSide:
                BorderSide(color: backgroundLightBlue, width: borderWidth),
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
    );
  }
}
