import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/sakani_tab_bar.dart';

class TenantShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const TenantShell({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: SakaniTabBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          items: const [
            SakaniTabItem(icon: Icons.home_rounded, label: 'Home'),
            SakaniTabItem(icon: Icons.receipt_long_rounded, label: 'Cheques'),
            SakaniTabItem(icon: Icons.build_rounded, label: 'Maintenance'),
            SakaniTabItem(icon: Icons.person_rounded, label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class LandlordShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const LandlordShell({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: SakaniTabBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          items: const [
            SakaniTabItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
            SakaniTabItem(icon: Icons.apartment_rounded, label: 'Units'),
            SakaniTabItem(icon: Icons.receipt_long_rounded, label: 'Cheques'),
            SakaniTabItem(icon: Icons.build_rounded, label: 'Maintenance'),
            SakaniTabItem(icon: Icons.person_rounded, label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class MaintenanceShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MaintenanceShell({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: SakaniTabBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          items: const [
            SakaniTabItem(icon: Icons.assignment_rounded, label: 'Tickets'),
            SakaniTabItem(icon: Icons.person_rounded, label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
