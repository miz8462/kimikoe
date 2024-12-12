import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/dropdown_id_and_name.dart';

void main() {
  test('DropdownIdAndNameクラス', () {
    const dropdownIdAndName = DropdownIdAndName(
      id: 1,
      name: 'test',
    );

    expect(dropdownIdAndName.id, 1);
    expect(dropdownIdAndName.name, 'test');
  });
}
