import 'package:flutter/cupertino.dart';

class IntPicker extends StatefulWidget {
  const IntPicker({
    super.key,
    required this.startNum,
    required this.endNum,
    required this.initialNum,
    required this.controller,
  });

  final int startNum;
  final int endNum;
  final int initialNum;
  final TextEditingController controller;

  @override
  State<IntPicker> createState() => _IntPickerState();
}

class _IntPickerState extends State<IntPicker> {
  // コントローラーに初期値を設定
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.initialNum.toString();
  }

  @override
  Widget build(BuildContext context) {
    final lengthOfNumbers = widget.endNum - widget.startNum + 1;
    List<Widget> numbers = List.generate(
      lengthOfNumbers,
      (index) => Text('${widget.startNum + index}'),
    );

    // initialNumのインデックスを計算。
    // startNumがゼロではないのでstartNumをインデックス番号ゼロにするため。
    final initialIndex = widget.initialNum - widget.startNum;

    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: CupertinoPicker(
        onSelectedItemChanged: (value) {
          setState(() {
            widget.controller.text = (widget.startNum + value).toString();
          });
        },
        magnification: 1.2,
        itemExtent: 35,
        scrollController: FixedExtentScrollController(
          initialItem: initialIndex,
        ),
        children: numbers,
      ),
    );
  }
}
