import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/widgets/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/styled_button.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredYear = 0;
  var _entered = '';
  void _saveGroup() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(_enteredName);
    }
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
              onSaved: (value) {
                _enteredName = value!;
              },
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
              initialValue: _enteredYear.toString(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                label: Text('結成年'),
                hintStyle: TextStyle(color: textGray),
                contentPadding: EdgeInsets.only(left: spaceWidthS),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                if (int.tryParse(value) == null) {
                  return '結成年は数字を入力してください。';
                }
                return null;
              },
              onSaved: (value) {
                _enteredYear = int.parse(value!);
              },
            ),
          ),
          const Gap(spaceWidthS),
          ExpandedTextForm(label: '備考'),
          const Gap(spaceWidthS),
          StyledButton(
            '登録',
            onPressed: () {
              _saveGroup();
              // context.go('/home');
            },
            buttonSize: buttonL,
          ),
          const Gap(spaceWidthS),
        ],
      ),
    );
  }
}
