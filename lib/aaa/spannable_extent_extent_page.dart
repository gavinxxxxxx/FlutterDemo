import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:hello_world/aaa/staggered_grid_view_page.dart';

const List<StaggeredTile> _tiles = const <StaggeredTile>[
  const StaggeredTile.extent(2, 50.0),
  const StaggeredTile.extent(1, 180.0),
  const StaggeredTile.extent(1, 160.0),
  const StaggeredTile.extent(3, 140.0),
  const StaggeredTile.extent(1, 120.0),
  const StaggeredTile.extent(4, 130.0),
  const StaggeredTile.extent(1, 50.0),
  const StaggeredTile.extent(2, 60.0),
  const StaggeredTile.extent(1, 130.0),
  const StaggeredTile.extent(3, 140.0),
  const StaggeredTile.extent(1, 60.0),
  const StaggeredTile.extent(1, 150.0),
];

class SpannableExtentExtentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const StaggeredGridViewPage.extent(
        title: 'Spannable (Extent, Extent)',
        maxCrossAxisExtent: 75.0,
        tiles: _tiles);
  }
}
