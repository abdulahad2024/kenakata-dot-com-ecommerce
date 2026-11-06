import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../controllers/main_nav_controller.dart';
import '../../home/views/home_screen.dart';
import '../../category/views/categories_screen.dart';
import '../../wishlist/views/wishlist_screen.dart';
import '../../cart/views/cart_screen.dart';
import '../../profile/views/profile_screen.dart';
import '../../../theme/app_colors.dart';

class MainNavScreen extends GetView<MainNavController> {
  const MainNavScreen({super.key});

  // পেজের ক্রম আগের মতোই রাখা হয়েছে (0 হোম, 1 ক্যাটাগরি, 2 পছন্দ, 3 কার্ট, 4 অ্যাকাউন্ট)
  // তাই অন্য জায়গায় changeIndex(3) দিয়ে কার্টে যাওয়ার কোড ভাঙবে না।
  final List<Widget> _pages = const [
    HomeScreen(),
    CategoriesScreen(),
    WishlistScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // পেজের কনটেন্ট নেভ বারের পেছন পর্যন্ত যাবে
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: _pages,
      )),
      bottomNavigationBar: _CurvedBottomBar(controller: controller),
    );
  }
}

class _CurvedBottomBar extends StatelessWidget {
  const _CurvedBottomBar({required this.controller});

  final MainNavController controller;

  static const double _barHeight = 68;
  static const double _fabSize = 60;
  static const double _lift = _fabSize / 2; // ব্যারের উপরে কতটা উঠে থাকবে

  void _select(int index) {
    HapticFeedback.selectionClick();
    controller.changeIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: _barHeight + _lift + bottomInset,
      child: Obx(() {
        final current = controller.currentIndex.value;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // ১) বাঁকা নচসহ সাদা ব্যার
            Positioned.fill(
              child: CustomPaint(
                painter: _NavBarPainter(
                  topOffset: _lift,
                  notchRadius: _fabSize / 2 + 8,
                ),
              ),
            ),

            // ২) আইটেমগুলো (মাঝখানে কার্টের জায়গা ফাঁকা + লেবেল)
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomInset,
              height: _barHeight,
              child: Row(
                children: [
                  Expanded(
                    child: _NavItem(
                      icon: Ionicons.homeOutline,
                      activeIcon: Ionicons.home,
                      label: 'হোম',
                      selected: current == 0,
                      onTap: () => _select(0),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Ionicons.gridOutline,
                      activeIcon: Ionicons.grid,
                      label: 'ক্যাটাগরি',
                      selected: current == 1,
                      onTap: () => _select(1),
                    ),
                  ),
                  // মাঝের কার্ট লেবেল
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _select(3),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'কার্ট',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: current == 3
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: current == 3
                                  ? AppColors.primary
                                  : Colors.grey[500],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Ionicons.heartOutline,
                      activeIcon: Ionicons.heart,
                      label: 'পছন্দ',
                      selected: current == 2,
                      onTap: () => _select(2),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Ionicons.personOutline,
                      activeIcon: Ionicons.person,
                      label: 'অ্যাকাউন্ট',
                      selected: current == 4,
                      onTap: () => _select(4),
                    ),
                  ),
                ],
              ),
            ),

            // ৩) মাঝের উঁচু কার্ট বাটন
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => _select(3),
                  child: AnimatedScale(
                    scale: current == 3 ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: Container(
                      width: _fabSize,
                      height: _fabSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.lerp(AppColors.primary, Colors.white, 0.25)!,
                            AppColors.primary,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(100),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Ionicons.cart,
                        color: Colors.white,
                        size: 26,
                      ),
                      // কার্টে আইটেম সংখ্যার ব্যাজ চাইলে এখানে Stack + Positioned দিয়ে
                      // cartController.items.length দেখাতে পারেন।
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : Colors.grey[500];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary.withAlpha(28)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(selected ? activeIcon : icon, size: 22, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarPainter extends CustomPainter {
  _NavBarPainter({required this.topOffset, required this.notchRadius});

  final double topOffset;
  final double notchRadius;

  @override
  void paint(Canvas canvas, Size size) {
    const r = 24.0; // উপরের কোণের গোলাকার ভাব
    final top = topOffset;
    final cx = size.width / 2;

    final path = Path()
      ..moveTo(0, top + r)
      ..quadraticBezierTo(0, top, r, top)
      ..lineTo(cx - notchRadius, top)
      ..arcToPoint(
        Offset(cx + notchRadius, top),
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..lineTo(size.width - r, top)
      ..quadraticBezierTo(size.width, top, size.width, top + r)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawShadow(path, Colors.black.withAlpha(90), 10, false);
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  // ব্যারের উপরের ফাঁকা অংশে ট্যাপ পেছনের পেজে চলে যাবে
  @override
  bool? hitTest(Offset position) => position.dy >= topOffset;

  @override
  bool shouldRepaint(covariant _NavBarPainter old) =>
      old.topOffset != topOffset || old.notchRadius != notchRadius;
}