import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/models/auth_state.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/cheques/screens/cheque_detail_screen.dart';
import '../../features/cheques/screens/cheque_list_screen.dart';
import '../../features/compound/screens/compound_list_screen.dart';
import '../../features/compound/screens/unit_list_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/maintenance/screens/create_maintenance_screen.dart';
import '../../features/maintenance/screens/maintenance_detail_screen.dart';
import '../../features/maintenance/screens/maintenance_list_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import 'role_shells.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (authState is Authenticated) {
        if (isAuthRoute) {
          // Admin users get the landlord shell (full access)
          final role = authState.user.role.name;
          final path = role == 'admin' ? 'landlord' : role;
          return '/$path';
        }
        return null;
      }

      if (!isAuthRoute) return '/login';
      return null;
    },
    routes: [
      // --- Auth routes ---
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // --- Tenant Shell (4 tabs) ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            TenantShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/tenant',
              name: RouteNames.tenantHome,
              builder: (context, state) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/tenant/cheques',
              name: RouteNames.tenantCheques,
              builder: (context, state) => const ChequeListScreen(),
              routes: [
                GoRoute(
                  path: ':chequeId',
                  name: RouteNames.chequeDetail,
                  builder: (context, state) {
                    final chequeId = state.pathParameters['chequeId']!;
                    return ChequeDetailScreen(chequeId: chequeId);
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/tenant/maintenance',
              name: RouteNames.tenantMaintenance,
              builder: (context, state) => const MaintenanceListScreen(),
              routes: [
                GoRoute(
                  path: 'create',
                  name: RouteNames.createRequest,
                  builder: (context, state) {
                    final category =
                        state.uri.queryParameters['category'];
                    final categoryName =
                        state.uri.queryParameters['categoryName'];
                    return CreateMaintenanceScreen(
                      preselectedCategory: category,
                      categoryName: categoryName,
                    );
                  },
                ),
                GoRoute(
                  path: ':requestId',
                  name: RouteNames.maintenanceDetail,
                  builder: (context, state) {
                    final requestId = state.pathParameters['requestId']!;
                    return MaintenanceDetailScreen(requestId: requestId);
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/tenant/profile',
              name: RouteNames.tenantProfile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),

      // --- Landlord Shell (5 tabs) ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            LandlordShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/landlord',
              name: RouteNames.landlordHome,
              builder: (context, state) => const CompoundListScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/landlord/units',
              name: RouteNames.landlordUnits,
              builder: (context, state) => const UnitListScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/landlord/cheques',
              name: RouteNames.landlordCheques,
              builder: (context, state) => const ChequeListScreen(),
              routes: [
                GoRoute(
                  path: ':chequeId',
                  builder: (context, state) {
                    final chequeId = state.pathParameters['chequeId']!;
                    return ChequeDetailScreen(chequeId: chequeId);
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/landlord/maintenance',
              name: RouteNames.landlordMaintenance,
              builder: (context, state) => const MaintenanceListScreen(),
              routes: [
                GoRoute(
                  path: ':requestId',
                  builder: (context, state) {
                    final requestId = state.pathParameters['requestId']!;
                    return MaintenanceDetailScreen(requestId: requestId);
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/landlord/profile',
              name: RouteNames.landlordProfile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),

      // --- Maintenance Shell (2 tabs) ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MaintenanceShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/maintenance',
              name: RouteNames.maintenanceHome,
              builder: (context, state) => const MaintenanceListScreen(),
              routes: [
                GoRoute(
                  path: ':requestId',
                  builder: (context, state) {
                    final requestId = state.pathParameters['requestId']!;
                    return MaintenanceDetailScreen(requestId: requestId);
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/maintenance/profile',
              name: RouteNames.maintenanceProfile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});
