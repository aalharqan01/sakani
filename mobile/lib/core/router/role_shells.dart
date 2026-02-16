import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/generated/app_localizations.dart';
import '../widgets/sakani_tab_bar.dart';

class TenantShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const TenantShell({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          items: [
            SakaniTabItem(icon: Icons.home_rounded, label: l10n.home),
            SakaniTabItem(icon: Icons.receipt_long_rounded, label: l10n.cheques),
            SakaniTabItem(icon: Icons.build_rounded, label: l10n.maintenance),
            SakaniTabItem(icon: Icons.person_rounded, label: l10n.profile),
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
    final l10n = AppLocalizations.of(context);
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
          items: [
            SakaniTabItem(icon: Icons.dashboard_rounded, label: l10n.dashboard),
            SakaniTabItem(icon: Icons.apartment_rounded, label: l10n.units),
            SakaniTabItem(icon: Icons.receipt_long_rounded, label: l10n.cheques),
            SakaniTabItem(icon: Icons.build_rounded, label: l10n.maintenance),
            SakaniTabItem(icon: Icons.person_rounded, label: l10n.profile),
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
    final l10n = AppLocalizations.of(context);
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
          items: [
            SakaniTabItem(icon: Icons.assignment_rounded, label: l10n.tickets),
            SakaniTabItem(icon: Icons.person_rounded, label: l10n.profile),
          ],
        ),
      ),
    );
  }
}
