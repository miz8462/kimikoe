import 'dart:io';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _imagePickerService = widget.imagePickerService ?? ImagePickerServiceImpl();
    _selectedImage = File(widget.imageUrl);
  }

  Future<File?> _getImageFromMobileStorage() async {
    final pickedImage =
        await _imagePickerService.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return null;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
      _hasEditingImage = false;
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
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: _getImageFromMobileStorage,
        child: _hasEditingImage
            ? Image(
                key: Key(WidgetKeys.image),
                image: NetworkImage(widget.imageUrl),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            : Image.file(
                key: Key(WidgetKeys.image),
                _selectedImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
      ),
    );
  }

  @visibleForTesting
  Future<File?> getImageFromMobileStorageForTesting() async {
    return _getImageFromMobileStorage();
  }
}
