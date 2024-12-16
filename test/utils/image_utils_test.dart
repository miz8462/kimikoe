import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/utils/image_utils.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// モックのファイルとコンテキスト
class MockFile extends Mock implements File {}

class MockLogger extends Mock implements Logger {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockFile mockFile;
  late MockBuildContext mockContext;

  setUp(() {
    mockFile = MockFile();
    mockContext = MockBuildContext();
  });

  group('getImagePath関数', () {
    test('画僧を選択していた場合、20文字のランダムな文字列に.jpgを追加したものを返す', () {
      final imageFile = File('path/to/image.jpg');
      final result = createImagePath(
        imageFile: imageFile,
      );
      expect(result, matches(RegExp(r'^[a-zA-Z0-9]{20}\.jpg$')));
    });
    test('画像を選択していない場合はnoImageを返す', () {
      final result = createImagePath();
      expect(result, noImage);
    });
  });
  group('processImage', () {
    // モックの関数
    Future<void> mockUploadImageToStorage({
      required String table,
      required String path,
      required File file,
      required BuildContext context,
      SupabaseClient? supabaseClient,
    }) async {
      // ここで実際に何もしない
    }

    String mockFetchImageUrl(String imagePath) {
      return 'https://example.com/$imagePath';
    }

    String mockCreateImagePath({File? imageFile}) {
      return 'new_image_path.jpg';
    }

    test('新規モードで画像が選択されていない場合。デフォルトURLを返す', () async {
      final result = await processImage(
        isEditing: false,
        isImageChanged: false,
        existingImageUrl: '',
        selectedImage: null,
        context: mockContext,
      );
      expect(result, noImage);
    });

    test('新規モードで画像が選択された場合。新しい画像URLを返す', () async {
      final result = await processImage(
        isEditing: false,
        isImageChanged: true,
        existingImageUrl: '',
        selectedImage: mockFile,
        context: mockContext,
        createImagePathFunction: mockCreateImagePath,
        uploadFunction: mockUploadImageToStorage,
        fetchFunction: mockFetchImageUrl,
      );
      expect(
        result,
        'https://example.com/new_image_path.jpg',
      );
    });
    test('編集モードで画像が変更されていない場合。そのままURLを返す', () async {
      final result = await processImage(
        isEditing: true,
        isImageChanged: false,
        existingImageUrl: 'https://example.com/existing.jpg',
        selectedImage: mockFile,
        context: mockContext,
        createImagePathFunction: mockCreateImagePath,
        uploadFunction: mockUploadImageToStorage,
        fetchFunction: mockFetchImageUrl,
      );
      expect(
        result,
        'https://example.com/existing.jpg',
      );
    });
    test('編集モードで画像が変更された場合。新しい画像URLを返す', () async {
      final result = await processImage(
        isEditing: true,
        isImageChanged: true,
        existingImageUrl: 'https://example.com/existing.jpg',
        selectedImage: mockFile,
        context: mockContext,
        createImagePathFunction: mockCreateImagePath,
        uploadFunction: mockUploadImageToStorage,
        fetchFunction: mockFetchImageUrl,
      );
      expect(
        result,
        'https://example.com/new_image_path.jpg',
      );
    });
  });
}
