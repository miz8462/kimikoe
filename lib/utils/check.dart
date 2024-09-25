import 'package:kimikoe_app/models/enums/table_and_column_name.dart';

bool isInList(List<Map<String, dynamic>> list, String? name) {
  for (final item in list) {
    if (item[ColumnName.name.colname] == name) {
      return true;
    }
  }
  return false;
}
