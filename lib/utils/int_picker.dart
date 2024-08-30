import 'package:flutter/cupertino.dart';

class IntPicker extends StatefulWidget {
  const IntPicker({
    super.key,
    required this.startNum,
    required this.endNum,
    required this.controller,
  });

  final int startNum;
  final int endNum;
  final TextEditingController controller;

  @override
  State<IntPicker> createState() => _IntPickerState();
}

class _IntPickerState extends State<IntPicker> {
  @override
  Widget build(BuildContext context) {
    final lengthOfNumbers = widget.endNum - widget.startNum + 1;
    List<Widget> numbers = List.generate(
      lengthOfNumbers,
      (index) => Text('${widget.startNum + index}'),
    );
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: CupertinoPicker(
        onSelectedItemChanged: (value) {
          setState(() {
            widget.controller.text = (value + 100).toString();
          });
        },
        magnification: 1.2,
        itemExtent: 35,
        scrollController: FixedExtentScrollController(
          initialItem: 60,
        ),
        children: numbers,
      ),
    );
  }
}
