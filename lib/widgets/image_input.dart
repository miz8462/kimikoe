import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/widgets/styled_button.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    required this.onPickImage,
  });

  final void Function(File image) onPickImage;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  var _isSending = false;

  Future<File?> _getImageFromMobileStrage() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return null;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);
    return _selectedImage!;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = StyledButton(
      'グループ画像',
      onPressed: _getImageFromMobileStrage,                  isSending: _isSending,

      textColor: textGray,
      backgroundColor: backgroundWhite,
      buttonSize: buttonS,
      borderSide: BorderSide(color: backgroundLightBlue, width: borderWidth),
    );

    if (_selectedImage != null) {
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
          child: Image.file(
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
