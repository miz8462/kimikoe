import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/services/image_picker_service.dart';
import 'package:kimikoe_app/widgets/button/styled_button.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    required this.label,
    required this.onPickImage,
    super.key,
    this.imageUrl,
    this.imagePickerService,
  });

  final String label;
  final void Function(File image) onPickImage;
  final String? imageUrl;
  final ImagePickerService? imagePickerService;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  bool _hasEditingImage = false;
  late ImagePickerService _imagePickerService;

  @override
  void initState() {
    super.initState();
    _imagePickerService = widget.imagePickerService ?? ImagePickerServiceImpl();
    if (widget.imageUrl != null) {
      _hasEditingImage = true;
    }
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

    widget.onPickImage(_selectedImage!);
    return _selectedImage!;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = StyledButton(
      widget.label,
      onPressed: _getImageFromMobileStorage,
      backgroundColor: mainColor.withValues(alpha: 0.8),
    );

    if (_selectedImage != null || _hasEditingImage) {
      content = Container(
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
                  image: NetworkImage(widget.imageUrl!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
        ),
      );
    }
    return content;
  }

  @visibleForTesting
  Future<File?> getImageFromMobileStorageForTesting() async {
    return _getImageFromMobileStorage();
  }
}
