import 'package:flutter/material.dart';

import '../../app/tokens.dart';

/// 2 px ink outer border, 2 px dividers, selected segment ink with white text.
class SegmentedSquare<T> extends StatelessWidget {
  const SegmentedSquare({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.labelOf,
    this.height = 46,
  });

  final List<T> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final String Function(T) labelOf;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: AppColors.ink, width: AppSpace.control)),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++)
            Expanded(
              child: Semantics(
                button: true,
                selected: options[i] == selected,
                label: labelOf(options[i]),
                excludeSemantics: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(options[i]),
                  child: Container(
                    height: height,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: options[i] == selected ? AppColors.ink : Colors.transparent,
                      border: i < options.length - 1
                          ? const Border(right: BorderSide(color: AppColors.ink, width: AppSpace.control))
                          : null,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        labelOf(options[i]),
                        style: AppText.ui(14,
                            weight: options[i] == selected ? 700 : 600,
                            color: options[i] == selected ? AppColors.onInk : AppColors.ink),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Two-column grid of big square choice buttons (driver picker in 03).
class ChoiceGrid<T> extends StatelessWidget {
  const ChoiceGrid({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.labelOf,
  });

  final List<T> options;
  final T? selected;
  final ValueChanged<T> onChanged;
  final String Function(T) labelOf;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < options.length; i += 2) {
      if (i > 0) rows.add(const SizedBox(height: 10));
      rows.add(Row(children: [
        Expanded(child: _cell(options[i])),
        const SizedBox(width: 10),
        Expanded(child: i + 1 < options.length ? _cell(options[i + 1]) : const SizedBox.shrink()),
      ]));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
  }

  Widget _cell(T o) {
    final on = o == selected;
    return Semantics(
      button: true,
      selected: on,
      label: labelOf(o),
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(o),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: on ? AppColors.ink : Colors.transparent,
            border: Border.all(color: AppColors.ink, width: AppSpace.control),
          ),
          child: Text(
            labelOf(o),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.ui(16, weight: on ? 700 : 600, color: on ? AppColors.onInk : AppColors.ink),
          ),
        ),
      ),
    );
  }
}
