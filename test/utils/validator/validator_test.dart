import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/utils/validator/validator.dart';

void main() {
  group('Input Validatorテスト', () {
    // 問題ない入力はnullを返す
    // nullableもnullを返す。
    test('intInputValidatorが正しいエラーメッセージを返すことをテスト', () {
      expect(intInputValidator(null), '数字を入力してください。');
      expect(intInputValidator(''), '数字を入力してください。');
      expect(intInputValidator('abc'), '数字を入力してください。');
      expect(intInputValidator('123'), null);
    });
    test('textInputValidatorが正しいエラーメッセージを返すことをテスト', () {
      expect(textInputValidator(null, '名前'), '名前を入力してください。');
      expect(textInputValidator('', '名前'), '名前を入力してください。');
      expect(textInputValidator('a' * 301, '名前'), '名前は300文字以下にしてください。');
      expect(textInputValidator('a' * 300, '名前'), null); // 名前の長さの境界値
      expect(textInputValidator('Miu', '名前'), null);
    });
    test('nullableTextInputValidatorが正しいエラーメッセージを返すことをテスト', () {
      expect(nullableTextInputValidator(null, 'メモ'), null);
      expect(nullableTextInputValidator('', 'メモ'), null);
      expect(nullableTextInputValidator('a' * 51, 'メモ'), 'メモは50文字以下にしてください。');
      expect(nullableTextInputValidator('a' * 50, 'メモ'), null);
      expect(nullableTextInputValidator('memomemo', 'メモ'), null);
    });
    test('longTextInputValidatorが正しいエラーメッセージを返すことをテスト', () {
      expect(longTextInputValidator(null, 'コメント'), 'コメントを入力してください。');
      expect(longTextInputValidator('', 'コメント'), 'コメントを入力してください。');
      expect(longTextInputValidator('a' * 10001, 'コメント'),
          'コメントは10000文字以下にしてください。');
      expect(longTextInputValidator('a' * 10000, 'コメント'), null);
      expect(longTextInputValidator('Coment', 'コメント'), null);
    });

    test('urlValidatorが正しいエラーメッセージを返すことをテスト', () {
      expect(urlValidator(null), null);
      expect(urlValidator(''), null);
      expect(urlValidator('kimikoe.com'), '正しいURLを入力してください');
      expect(urlValidator('https://kimikoe.com'), null);
    });
  });
}
