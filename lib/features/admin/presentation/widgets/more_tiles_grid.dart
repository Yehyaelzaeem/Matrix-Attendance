import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'more_tile.dart';

class MoreTilesGrid extends StatelessWidget {
  const MoreTilesGrid({super.key, required this.tiles});

  final List<MoreTile> tiles;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < tiles.length; i += 2) {
      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: tiles[i]),
            SizedBox(width: 10.w),
            Expanded(
                child: i + 1 < tiles.length ? tiles[i + 1] : const SizedBox()),
          ],
        ),
      ));
      if (i + 2 < tiles.length) rows.add(SizedBox(height: 10.h));
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(children: rows),
    );
  }
}
