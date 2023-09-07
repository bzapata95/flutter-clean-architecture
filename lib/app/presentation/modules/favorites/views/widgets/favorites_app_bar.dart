import 'package:flutter/material.dart';

class FavoritesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FavoritesAppBar({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Favorites'),
      titleTextStyle: const TextStyle(color: Colors.black),
      centerTitle: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      bottom: TabBar(
        padding: const EdgeInsets.symmetric(vertical: 10),
        controller: tabController,
        indicator: _Decoration(),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.black,
        tabs: const [
          SizedBox(
            height: 30,
            child: Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Movies')
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
            child: Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.tv),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Series')
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2);
}

class _Decoration extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _Painter();
}

class _Painter extends BoxPainter {
  @override
  void paint(
    Canvas canvas,
    Offset offset,
    ImageConfiguration configuration,
  ) {
    final paint = Paint()..color = Colors.black45;
    final size = configuration.size ?? Size.zero;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
              size.width * 0.5 + offset.dx,
              size.height * 0.9,
              20,
              4,
            ),
            const Radius.circular(4)),
        paint);

    // canvas.drawCircle(
    //   Offset(size.width * 0.5 + offset.dx, size.height * 0.9),
    //   4,
    //   paint,
    // );
  }
}
