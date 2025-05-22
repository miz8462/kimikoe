import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/services/image_picker_service.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    required this.onPickImage,
    required this.imageUrl,
    super.key,
    this.imagePickerService,
  });

  final void Function(File image) onPickImage;
  final String imageUrl;
  final ImagePickerService? imagePickerService;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  late File _selectedImage;
  bool _hasEditingImage = true;
  late ImagePickerService _imagePickerService;
  final _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _imagePickerService = widget.imagePickerService ?? ImagePickerServiceImpl();
    _selectedImage = File(widget.imageUrl);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Future<File?> _getImageFromMobileStorage() async {
    final pickedImage =
        await _imagePickerService.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return null;
    }

    final croppedImage = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '画像を切り抜き',
          toolbarColor:
              mounted ? Theme.of(context).colorScheme.primary : Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: '画像を切り抜き',
        ),
      ],
    );

    if (!mounted || croppedImage == null) {
      return null;
    }

    setState(() {
      _selectedImage = File(croppedImage.path);
      _hasEditingImage = false;
      _transformationController.value = Matrix4.identity();
    });

    widget.onPickImage(_selectedImage);
    return _selectedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      height: 250,
      width: double.infinity,
      child: ClipRect(
        child: GestureDetector(
          onTap: _getImageFromMobileStorage,
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4,
            boundaryMargin: const EdgeInsets.all(100),
            transformationController: _transformationController,
            child: _hasEditingImage
                ? Image(
                    key: const Key(WidgetKeys.image),
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Image.file(
                    key: const Key(WidgetKeys.image),
                    _selectedImage,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
          ),
        ),
      ),
    );
  }

  @visibleForTesting
  Future<File?> getImageFromMobileStorageForTesting() async {
    return _getImageFromMobileStorage();
  }
}
