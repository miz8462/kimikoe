// import 'package:flutter_test/flutter_test.dart';
// import 'package:kimikoe_app/models/table_and_column_name.dart';
// import 'package:kimikoe_app/providers/logger_provider.dart';
// import 'package:kimikoe_app/services/supabase_services/search.dart';
// import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../test_utils/mocks/logger.mocks.dart';

// void main() {
//   late final SupabaseClient mockSupabase;
//   late MockSupabaseHttpClient mockHttpClient;
//   late Search search;

//   setUpAll(() async {
//     mockHttpClient = MockSupabaseHttpClient();
//     mockSupabase = SupabaseClient(
//       'https://mock.supabase.co',
//       'fakeAnonKey',
//       httpClient: mockHttpClient,
//     );
//     logger = MockLogger();
//     search = Search(mockSupabase);
//   });

//   tearDown(() async {
//     mockHttpClient.reset();
//   });

//   group('検索機能', () {
//     testWidgets('グループを検索', (WidgetTester tester) async {
//       await mockSupabase.from(TableName.groups).insert({
//         ColumnName.id: 1,
//         ColumnName.name: 'Nogizaka',
//       });
//       await mockSupabase.from(TableName.groups).insert({
//         ColumnName.id: 2,
//         ColumnName.name: 'Sakurazaka',
//       });
//       await mockSupabase.from(TableName.groups).insert({
//         ColumnName.id: 3,
//         ColumnName.name: 'Hinatazaka',
//       });

//       final response = await search.group('Hinatazaka');
//       print(response);

//       expect(response.length, 1);
//       expect(response.first[ColumnName.name], 'Hinatazaka');
//     });

//     // testWidgets('アイドルを検索', (WidgetTester tester) async {
//     //   await mockSupabase.from(TableName.idols).insert({
//     //     ColumnName.groupId: 1,
//     //     ColumnName.name: 'test idol1',
//     //   });
//     //   await mockSupabase.from(TableName.idols).insert({
//     //     ColumnName.groupId: 2,
//     //     ColumnName.name: 'test idol2',
//     //   });
//     //   await mockSupabase.from(TableName.idols).insert({
//     //     ColumnName.groupId: 3,
//     //     ColumnName.name: 'test idol3',
//     //   });

//     //   final members = await search.idol('test idol2');

//     //   expect(members.length, 1);
//     //   expect(members.first[ColumnName.name], 'test idol2');
//     // });
//   });
// }
