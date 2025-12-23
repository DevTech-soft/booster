import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:booster/features/projects/presentation/pages/projects_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainLayoutPage extends StatelessWidget {
  const MainLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayoutPageContent();
  }
}

class MainLayoutPageContent extends StatefulWidget {
  const MainLayoutPageContent({super.key});

  @override
  State<MainLayoutPageContent> createState() => _MainLayoutPageContentState();
}

class _MainLayoutPageContentState extends State<MainLayoutPageContent> {
  int _currentIndex = 2;
  final List<Widget> _pages = [
     ProjectsPage(),
    const SizedBox(),
    DashboardPage(),
    const SizedBox(),
    const SizedBox(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _currentIndex, children: _pages)),
      bottomNavigationBar: Container(
        margin: AppSpacing.paddingXL,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXS.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXS.r),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              backgroundColor: AppColors.backgroundDark,
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: _navIcon(asset: 'assets/svg/proyects_icon.svg'),
                  activeIcon: _navIcon(
                    asset: 'assets/svg/proyects_icon.svg',
                    isActive: true,
                  ),
                  label: 'projects',
                ),
                BottomNavigationBarItem(
                  icon: _navIcon(asset: 'assets/svg/profile_icon.svg'),
                  activeIcon: _navIcon(
                    asset: 'assets/svg/profile_icon.svg',
                    isActive: true,
                  ),
                  label: 'profile',
                ),
                BottomNavigationBarItem(
                  icon: _navIcon(asset: 'assets/svg/dashboard_icon.svg'),
                  activeIcon: _navIcon(
                    asset: 'assets/svg/dashboard_icon.svg',
                    isActive: true,
                  ),
                  label: 'dashboard',
                ),
                BottomNavigationBarItem(
                  icon: _navIcon(asset: 'assets/svg/audios_icon.svg'),
                  activeIcon: _navIcon(
                    asset: 'assets/svg/audios_icon.svg',
                    isActive: true,
                  ),
                  label: 'audios',
                ),
                BottomNavigationBarItem(
                  icon: _navIcon(asset: 'assets/svg/settings_icon.svg'),
                  activeIcon: _navIcon(
                    asset: 'assets/svg/settings_icon.svg',
                    isActive: true,
                  ),
                  label: 'settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navIcon({required String asset, bool isActive = false}) {
    return Container(
      width: 40,
      height: 40,
      decoration:
          isActive
              ? BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)
              : null,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        asset,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          isActive ? Colors.white : Colors.grey,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
