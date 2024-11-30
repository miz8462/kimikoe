import 'package:flutter_test/flutter_test.dart';

import '../test_utils/mocks/mock_logger.dart';
import '../test_utils/mocks/mock_supabase_client.dart';

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockSupabaseQueryBuilder mockSupabaseQueryBuilder;
  late MockLogger mockLogger;
  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockSupabaseQueryBuilder = MockSupabaseQueryBuilder();
    mockLogger = MockLogger();
  });

  group('insertArtistData関数のテスト', () {
    testWidgets('アーティストの登録成功のテスト', (tester) async {});
  });
}
