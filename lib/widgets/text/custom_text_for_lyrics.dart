import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';

class CustomTextForLyrics extends StatefulWidget {
  const CustomTextForLyrics(
    this.text, {
    this.names,
    this.colors,
    super.key,
  });

  final String text;
  final List<String>? names;
  final List<Color>? colors;

  @override
  State<CustomTextForLyrics> createState() => _CustomTextForLyricsState();
}

class _CustomTextForLyricsState extends State<CustomTextForLyrics>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late LayerLink _layerLink; // ポップアップの位置をリンク

  @override
  void initState() {
    super.initState();
    _layerLink = LayerLink();
  }

  OverlayEntry? _createOverlayEntry(List<String> namesToShow, int indexOffset) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      logger.e('RenderBox is null, cannot create overlay');
      return null;
    }

    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + 20,
        top: offset.dy + (indexOffset * 24), // 各CircleColorの位置に基づく調整
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            color: backgroundLightBlue,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: namesToShow
                  .map(
                    (name) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        name,
                        style: TextStyle(color: textDark, fontSize: 16),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _showPopup(List<String> namesToShow, int indexOffset) {
    final newOverlayEntry = _createOverlayEntry(namesToShow, indexOffset);
    if (newOverlayEntry == null) return;

    _overlayEntry?.remove();
    _overlayEntry = newOverlayEntry;

    final overlay = Overlay.of(context, rootOverlay: true);

    overlay.insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _overlayEntry?.remove();
        setState(() {
          _overlayEntry = null;
        });
      }
    });
  }

  void _hidePopup() {
    _overlayEntry?.remove();
    setState(() {
      _overlayEntry = null;
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Names: ${widget.names}');
    logger.d('Colors: ${widget.colors}');

    final effectiveNames = widget.names ?? ['Unknown'];
    final effectiveColors = widget.colors ?? [Colors.black];

    final minLength = effectiveNames.length < effectiveColors.length
        ? effectiveNames.length
        : effectiveColors.length;
    final displayNames = effectiveNames.sublist(0, minLength);
    final displayColors = effectiveColors.sublist(0, minLength);

    return CompositedTransformTarget(
      link: _layerLink,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (displayNames.length <= 2) // 1-2人の場合
                ...List.generate(displayNames.length, (index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => _showPopup([displayNames[index]], index),
                        onTapCancel: _hidePopup,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: CircleColor(displayColors[index]),
                        ),
                      ),
                      Gap(4),
                    ],
                  );
                })
              else // 3人以上の場合
                GestureDetector(
                  onTap: () => _showPopup(displayNames, 0), // 全員の名前を表示
                  onTapCancel: _hidePopup,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: CircleColor(
                      Colors.transparent, // ベースは透明
                      gradientColors: [
                        Colors.red,
                        Colors.yellow,
                        Colors.blue,
                      ], // 虹色グラデーション
                    ),
                  ),
                ),
            ],
          ),
          const Gap(12),
          Expanded(
            child: Text(
              widget.text,
              style: const TextStyle(
                color: textDark,
                fontSize: 16,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

// CircleColorをカスタマイズ（gradient対応）
class CircleColor extends StatelessWidget {
  const CircleColor(this.baseColor, {this.gradientColors, super.key});
  final Color baseColor;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: gradientColors == null ? baseColor : null,
        gradient: gradientColors != null
            ? LinearGradient(
                colors: gradientColors!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
    );
  }
}
