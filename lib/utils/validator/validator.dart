String? intInputValidator(String? value) {
  if (value == null || value.isEmpty || int.tryParse(value) == null) {
    return '数字を入力してください。';
  }
  return null;
}

String? textInputValidator(String? value, String inputType) {
  if (value == null || value.isEmpty) {
    return '$inputTypeを入力してください。';
  } else if (value.trim().length > 300) {
    return '$inputTypeは300文字以下にしてください。';
  }
  return null;
}

String? nullableTextInputValidator(String? value, String inputType) {
  if (value == null || value.isEmpty) {
    return null;
  } else if (value.trim().length > 50) {
    return '$inputTypeは50文字以下にしてください。';
  }
  return null;
}

String? longTextInputValidator(String? value, String inputType) {
  if (value == null || value.isEmpty) {
    return '$inputTypeを入力してください。';
  } else if (value.trim().length > 10000) {
    return '$inputTypeは10000文字以下にしてください。';
  }
  return null;
}

String? urlValidator(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  if (!value.contains('http')) {
    return '正しいURLを入力してください';
  }
  return null;
}
