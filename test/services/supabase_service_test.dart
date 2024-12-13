import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/services/supabase_service.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late final SupabaseClient mockSupabase;
  late final MockSupabaseHttpClient mockHttpClient;

  setUpAll(() {
    mockHttpClient = MockSupabaseHttpClient();
    mockSupabase = SupabaseClient(
      'https://mock.supabase.co',
      'fakeAnonKey',
      httpClient: MockSupabaseHttpClient(),
    );
  });

  tearDown(() async {
    mockHttpClient.reset();
  });
  Future<BuildContext> createMockContext(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return Container();
            },
          ),
        ),
      ),
    );
    return tester.element(find.byType(Container));
  }

  testWidgets('insertArtistData', (WidgetTester tester) async {
    final mockContext = await createMockContext(tester);

    await insertArtistData(
      name: 'test artist',
      context: mockContext,
      supabaseClient: mockSupabase,
      imageUrl: 'https://example.com/image.jpg',
      comment: 'test comment',
    );
    await tester.pump(Duration(milliseconds: 500));

    final artists = await mockSupabase.from(TableName.artists).select();

    expect(artists.length, 1);
    expect(artists.first, {
      'name': 'test artist',
      'image_url': 'https://example.com/image.jpg',
      'comment': 'test comment',
    });
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('アーティストを登録しました: test artist'), findsOneWidget);

    // name以外がnullの場合
    await insertArtistData(
      name: 'test artist2',
      context: mockContext,
      supabaseClient: mockSupabase,
    );
    await tester.pump(Duration(milliseconds: 500));

    final artists2 = await mockSupabase.from('artists').select();

    expect(artists2.length, 2);
    expect(artists2.last, {
      'name': 'test artist2',
      'image_url': null,
      'comment': null,
    });
  });

  testWidgets('insertIdolGroupData', (WidgetTester tester) async {
    final mockContext = await createMockContext(tester);

    await insertIdolGroupData(
      name: 'test group',
      context: mockContext,
      supabaseClient: mockSupabase,
      imageUrl: 'https://example.com/image.jpg',
      year: '2023',
      officialUrl: 'https://example.com/official',
      twitterUrl: 'https://twitter.com/test_group',
      instagramUrl: 'https://instagram.com/test_group',
      scheduleUrl: 'https://example.com/schedule',
      comment: 'test comment',
    );
    await tester.pump(Duration(milliseconds: 500));

    final idolGroups = await mockSupabase.from(TableName.idolGroups).select();

    expect(idolGroups.length, 1);
    expect(idolGroups.first, {
      'name': 'test group',
      'image_url': 'https://example.com/image.jpg',
      'year_forming_group': 2023,
      'official_url': 'https://example.com/official',
      'twitter_url': 'https://twitter.com/test_group',
      'instagram_url': 'https://instagram.com/test_group',
      'schedule_url': 'https://example.com/schedule',
      'comment': 'test comment',
    });
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('グループを登録しました: test group'), findsOneWidget);

    // name以外がnullの場合
    await insertIdolGroupData(
      name: 'test group2',
      context: mockContext,
      supabaseClient: mockSupabase,
    );
    await tester.pump(Duration(milliseconds: 500));

    final groups2 = await mockSupabase.from(TableName.idolGroups).select();

    expect(groups2.length, 2);
    expect(groups2.last, {
      'name': 'test group2',
      'image_url': null,
      'year_forming_group': null,
      'official_url': null,
      'twitter_url': null,
      'instagram_url': null,
      'schedule_url': null,
      'comment': null,
    });
  });
}
