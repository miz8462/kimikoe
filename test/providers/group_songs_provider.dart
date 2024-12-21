// import 'package:flutter_test/flutter_test.dart';
// import 'package:kimikoe_app/providers/groups_providere.dart';
// import 'package:kimikoe_app/providers/logger_provider.dart';
// import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../test_utils/mocks/logger_mock.dart';
// import '../test_utils/test_helpers.dart';

// void main() {
//   late SupabaseClient mockSupabase;
//   late MockLogger mockLogger;

//   setUpAll(() {
//     mockSupabase = SupabaseClient(
//       'https://mock.supabase.co',
//       'fakeAnonKey',
//       httpClient: MockSupabaseHttpClient(),
//     );
//     mockLogger = MockLogger();
//     final loggerContainer = createContainer(
//       overrides: [loggerProvider.overrideWith((ref) => mockLogger)],
//     );
//     final logger = loggerContainer.read(loggerProvider) as MockLogger;
//   });

//   group('groupSongsProvider', () {
//     final groupsContainer = createContainer(
//       overrides: [
//         groupsProvider.overrideWith((ref) {
//           final notifier = GroupsNotifier();
//           notifier.initialize(
//             supabase: mockSupabase,
//             logger: mockLogger,
//           );
//           return notifier;
//         }),
//       ],
//     );
//   });
// }
