import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

class StatTileData {
  const StatTileData({
    required this.value,
    required this.label,
    this.color,
    this.background,
    this.numeric = true,
  });

  final String value;
  final String label;
  final Color? color;
  final Color? background;
  final bool numeric;
}

class StatTilesRow extends StatelessWidget {
  const StatTilesRow({
    super.key,
    required this.tiles,
    this.background,
    this.valueSize = 19,
    this.labelSize = 11,
    this.spacing = 8,
    this.radius = 16,
    this.verticalPadding = 12,
    this.labelFirst = false,
  });

  final List<StatTileData> tiles;
  final Color? background;
  final double valueSize;
  final double labelSize;
  final double spacing;
  final double radius;
  final double verticalPadding;
  final bool labelFirst;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < tiles.length; i++) ...[
          if (i > 0) SizedBox(width: spacing.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: verticalPadding.h, horizontal: 4.w),
              decoration: BoxDecoration(
                color: tiles[i].background ??
                    background ??
                    AppColors.cardColor.themeColor,
                borderRadius: BorderRadius.circular(radius.r),
              ),
              child: Column(
                children: [
                  if (labelFirst) _label(tiles[i]),
                  AppText(
                    tiles[i].value,
                    numeric: tiles[i].numeric,
                    fontSize: valueSize,
                    fontWeight: FontWeight.w700,
                    color: tiles[i].color,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                  if (!labelFirst) ...[SizedBox(height: 2.h), _label(tiles[i])],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _label(StatTileData tile) => AppText(
        tile.label,
        fontSize: labelSize,
        fontWeight: FontWeight.w700,
        textAlign: TextAlign.center,
        color: AppColors.textSecondaryColor.themeColor,
        maxLines: 2,
      );
}
