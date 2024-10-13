import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    required this.label,
    required this.onPickImage,
    this.imageUrl,
  });

  final String label;
  final void Function(File image) onPickImage;
  final String? imageUrl;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  bool _hasEditingImage = false;

  @override
  void initState() {
    super.initState();
    if (widget.imageUrl != null) {
      _hasEditingImage = true;
    }
  }

  Future<File?> _getImageFromMobileStrage() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
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
      onPressed: _getImageFromMobileStrage,
      textColor: textGray,
      backgroundColor: backgroundWhite,
      buttonSize: buttonS,
      borderSide: const BorderSide(color: backgroundLightBlue, width: borderWidth),
    );

    if (_selectedImage != null || _hasEditingImage) {
      content = Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
        height: 250,
        width: double.infinity,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: _getImageFromMobileStrage,
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
}
