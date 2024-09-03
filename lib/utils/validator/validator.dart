String? intInputValidator(String? value, String? text) {
  if (value == null || value.isEmpty || int.tryParse(value) == null) {
    return '$textは数字を入力してください。';
  }
  return null;
}

String? textInputValidator(String? value, String? text) {
  if (value == null || value.isEmpty) {
    return '$textを入力してください。';
  } else if (value.trim().length > 50) {
    return '$textは50文字以下にしてください。';
  }
  return null;
}

String? nullableTextInputValidator(String? value, String? text) {
  if (value == null || value.isEmpty) {
    return null;
  } else if (value.trim().length > 50) {
    return '$textは50文字以下にしてください。';
  }
  return null;
}
