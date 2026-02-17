# Sakani Project Context

> **IMPORTANT**: This file MUST be updated after every major task completion, new feature implementation, bug fix, or architectural decision. Before ending any work session or when context is getting large, update the "Current Status" and "Recent Changes" sections. This ensures no context is lost after conversation compaction.

## Project Overview
**Sakani** is a compound/gated community management platform for Qatar. It handles property management, post-dated cheque tracking (killer feature), and maintenance-as-a-service for tenants, landlords, and maintenance staff.

## Tech Stack
- **Backend**: Django 5.1+ / DRF / PostgreSQL 16 / Redis 7 / SimpleJWT / Docker Compose
- **Mobile**: Flutter 3.38.9 / Dart 3.10.8 / Riverpod 2.x / GoRouter / Dio
- **Dashboard**: React 19 / TypeScript / Vite / TailwindCSS 4 / TanStack Query / React Router 7

## Architecture

### Backend (`backend/`)
- **Settings**: Split config at `config/settings/{base,local,production}.py`
- **Custom User**: Phone-based auth (+974), UUID pk, QID field, roles (tenant/landlord/maintenance/admin)
- **Auth**: SimpleJWT - 30min access, 30day refresh, token blacklisting
- **Apps**: core, accounts, compounds, leases, cheques, maintenance, notifications
- **Data Hierarchy**: Compound → Building → Unit → Lease → Tenant
- **BaseModel**: UUID pk, timestamps, soft delete, created_by/updated_by
- **Docker**: PostgreSQL 16 + Redis 7 + Django web (docker-compose.yml in backend/)

### Mobile (`mobile/`)
- **State**: Riverpod 2.x (FutureProvider, StateProvider, family providers)
- **Navigation**: GoRouter with 3 role-based StatefulShellRoute.indexedStack
  - Tenant: Home, Cheques, Maintenance, Profile (4 tabs)
  - Landlord: Dashboard, Units, Cheques, Maintenance, Profile (5 tabs)
  - Maintenance: Tickets, Profile (2 tabs)
- **Theme**: Material 3, indigo palette (primary #818CF8, dark #6366F1, navy #1E1B4B)
- **Fonts**: Plus Jakarta Sans (EN) + Noto Kufi Arabic (AR) via Google Fonts
- **Localization**: flutter gen-l10n, 185 keys in EN/AR, default locale now English
- **API**: Dio with AuthInterceptor (JWT refresh) + LanguageInterceptor
- **Custom widgets**: SakaniTabBar, DohaSkylinePainter, SakaniEmptyState, SakaniErrorView

### Dashboard (`dashboard/`)
- **Stack**: React 19 + TypeScript + Vite + TailwindCSS 4
- **State**: TanStack React Query for API caching
- **Auth**: AuthContext with ProtectedRoute wrapper
- **API**: Axios with custom client (`axios-client.ts`)
- **Pages**: Dashboard, Cheques (list+detail), Maintenance (list+detail), Compounds, Units, Tenants, Leases
- **Layout**: Sidebar navigation with DashboardLayout

## Key File Locations

### Backend
| Purpose | Path |
|---------|------|
| Django settings | `backend/config/settings/base.py` |
| Custom User model | `backend/apps/accounts/models.py` |
| Account serializers | `backend/apps/accounts/serializers.py` |
| Account views/URLs | `backend/apps/accounts/views.py`, `urls.py` |
| Compound models | `backend/apps/compounds/models.py` |
| Lease models | `backend/apps/leases/models.py` |
| Cheque models | `backend/apps/cheques/models.py` |
| Maintenance models | `backend/apps/maintenance/models.py` |
| Notification models | `backend/apps/notifications/models.py` |
| Docker compose | `backend/docker-compose.yml` |

### Mobile - Core
| Purpose | Path |
|---------|------|
| App entry | `mobile/lib/main.dart` |
| App widget | `mobile/lib/app.dart` |
| GoRouter | `mobile/lib/core/router/app_router.dart` |
| Role shells | `mobile/lib/core/router/role_shells.dart` |
| Route names | `mobile/lib/core/router/route_names.dart` |
| API client (Dio) | `mobile/lib/core/api/api_client.dart` |
| API interceptors | `mobile/lib/core/api/api_interceptors.dart` |
| API endpoints | `mobile/lib/core/api/api_endpoints.dart` |
| API exceptions | `mobile/lib/core/api/api_exceptions.dart` |
| Token storage | `mobile/lib/core/auth/token_storage.dart` |
| Theme | `mobile/lib/core/theme/app_theme.dart` |
| Colors | `mobile/lib/core/theme/app_colors.dart` |
| Typography | `mobile/lib/core/theme/app_typography.dart` |
| Spacing | `mobile/lib/core/theme/app_spacing.dart` |
| Localization ARBs | `mobile/lib/core/l10n/app_{en,ar}.arb` |
| Generated l10n | `mobile/lib/core/l10n/generated/` |
| Doha skyline | `mobile/lib/core/widgets/doha_skyline_painter.dart` |
| Tab bar | `mobile/lib/core/widgets/sakani_tab_bar.dart` |
| Empty state | `mobile/lib/core/widgets/sakani_empty_state.dart` |
| Error view | `mobile/lib/core/widgets/sakani_error_view.dart` |

### Mobile - Auth Feature
| Purpose | Path |
|---------|------|
| User model | `mobile/lib/features/auth/models/user_model.dart` |
| Auth state (sealed) | `mobile/lib/features/auth/models/auth_state.dart` |
| Auth repository | `mobile/lib/features/auth/repositories/auth_repository.dart` |
| Auth provider | `mobile/lib/features/auth/providers/auth_provider.dart` |
| Login screen | `mobile/lib/features/auth/screens/login_screen.dart` |
| Register screen | `mobile/lib/features/auth/screens/register_screen.dart` |

### Mobile - Cheques Feature
| Purpose | Path |
|---------|------|
| Cheque model | `mobile/lib/features/cheques/models/cheque_model.dart` |
| Dashboard model | `mobile/lib/features/cheques/models/cheque_dashboard_model.dart` |
| Cheque repository | `mobile/lib/features/cheques/repositories/cheque_repository.dart` |
| Cheque providers | `mobile/lib/features/cheques/providers/cheque_providers.dart` |
| Cheque list screen | `mobile/lib/features/cheques/screens/cheque_list_screen.dart` |
| Cheque detail screen | `mobile/lib/features/cheques/screens/cheque_detail_screen.dart` |
| List tile widget | `mobile/lib/features/cheques/widgets/cheque_list_tile.dart` |
| Status icon widget | `mobile/lib/features/cheques/widgets/cheque_status_icon.dart` |
| Summary card widget | `mobile/lib/features/cheques/widgets/cheque_summary_card.dart` |

### Mobile - Maintenance Feature
| Purpose | Path |
|---------|------|
| Request model | `mobile/lib/features/maintenance/models/maintenance_request_model.dart` |
| Category model | `mobile/lib/features/maintenance/models/maintenance_category_model.dart` |
| Repository | `mobile/lib/features/maintenance/repositories/maintenance_repository.dart` |
| Providers | `mobile/lib/features/maintenance/providers/maintenance_providers.dart` |
| List screen | `mobile/lib/features/maintenance/screens/maintenance_list_screen.dart` |
| Create screen | `mobile/lib/features/maintenance/screens/create_maintenance_screen.dart` |

### Mobile - Home Feature
| Purpose | Path |
|---------|------|
| Home screen | `mobile/lib/features/home/screens/home_screen.dart` |
| Greeting header | `mobile/lib/features/home/widgets/greeting_header.dart` |
| Quick actions | `mobile/lib/features/home/widgets/quick_actions_grid.dart` |
| Recent activity | `mobile/lib/features/home/widgets/recent_activity_section.dart` |
| Rent card | `mobile/lib/features/home/widgets/rent_card.dart` |
| Upcoming cheques | `mobile/lib/features/home/widgets/upcoming_cheques_section.dart` |

### Dashboard (React)
| Purpose | Path |
|---------|------|
| App entry | `dashboard/src/App.tsx` |
| Main entry | `dashboard/src/main.tsx` |
| Auth context | `dashboard/src/auth/AuthContext.tsx` |
| Protected route | `dashboard/src/auth/ProtectedRoute.tsx` |
| Axios client | `dashboard/src/api/axios-client.ts` |
| Types | `dashboard/src/lib/types.ts` |
| Constants | `dashboard/src/lib/constants.ts` |
| Dashboard page | `dashboard/src/pages/DashboardPage.tsx` |
| Login page | `dashboard/src/pages/LoginPage.tsx` |

## Superuser Credentials
- Phone: `+97412345678`
- Password: `admin123456`
- Test tenant: `+97455551234` / `testpass123`

## API Endpoints (Django)
All under `/api/v1/`:
- Auth: `auth/register/`, `auth/login/`, `auth/token/refresh/`, `auth/logout/`, `auth/profile/`, `auth/change-password/`
- Compounds: `compounds/`, `buildings/`, `units/`, `memberships/`
- Leases: `leases/` (with activate/terminate actions)
- Cheques: `cheques/` (with deposit/clear/bounce/replace/bulk-create/upcoming/overdue/dashboard)
- Maintenance: `maintenance/categories/`, `maintenance/requests/` (with images/quotes/accept/reject/complete/rate/comments)
- Notifications: `notifications/`, `notifications/devices/`

## Development Roadmap
1. ~~Project Scaffolding & Infrastructure~~ **COMPLETE**
2. ~~Auth Flow (end-to-end)~~ **COMPLETE**
3. ~~Cheque Tracker (first vertical slice)~~ **COMPLETE**
4. ~~Basic Maintenance Flow~~ **COMPLETE**
5. ~~Polish for Pilot~~ **COMPLETE**

## Current Status
**Phase**: All 5 steps COMPLETE — MVP pilot-ready
**Last Updated**: 2026-02-09

### What's Done
- **Backend**: Full Django backend with 7 apps, all models/serializers/viewsets, Docker running, migrations applied
- **Auth**: End-to-end JWT auth flow (login, register, session restore, logout, role-based redirect)
- **Cheques**: Full CRUD — list with filters/pull-to-refresh, detail with status timeline, dashboard summary, **status action buttons** (deposit/clear/bounce with confirmation dialogs), providers + repository
- **Maintenance**: List screen, create screen, **detail screen** with status display/info card, **comments section** (list+add), **rating widget** (1-5 stars with comment), repository methods for quote/accept/reject/complete/rate/image upload/comments, routes wired for all roles
- **Notifications**: **Full notification feature** — model, repository (list/markRead/markAllRead/unreadCount/registerDevice), providers, **notification list screen** with type-based icons/colors, unread badge on home screen bell, pull-to-refresh
- **Home**: Tenant home screen wired to real API data (dashboard + upcoming cheques + activity), **notification bell shows real unread count** and navigates to notification screen
- **Dashboard (React)**: Installed, built, verified — `npm run build` succeeds (162 modules, 341KB JS)
- **UI Polish**: Pull-to-refresh on cheque list, dynamic route paths for both tenant/landlord, error states, loading states, empty states
- **Localization**: 230+ keys in English + Arabic (added cheque actions, maintenance detail/quote/rate/comments, notification strings)
- **flutter analyze**: 0 issues

### What's Remaining (Post-MVP)
- FCM push notification integration (Firebase setup, token registration on login)
- Offline handling (cache API responses)
- Image upload UI for maintenance requests (backend endpoint ready)
- Cheque image scanning feature
- Dashboard: connect to real backend API
- Testing: unit tests, widget tests, integration tests
- CI/CD pipeline setup

### Known Issues
- `docker-compose.yml` has deprecated `version` attribute (warning only)
- Some Flutter packages have newer major versions available (not urgent)
- Default locale is English (changed from Arabic in `app.dart`)

## Recent Changes
| Date | Change |
|------|--------|
| 2026-02-09 | Phase 1 scaffolding complete — all Django apps + Flutter structure |
| 2026-02-09 | Step 2 COMPLETE: Auth flow end-to-end |
| 2026-02-09 | (Other device) Step 3 COMPLETE: Cheque tracker — models, repository, providers, list/detail screens, widgets |
| 2026-02-09 | (Other device) Step 4 PARTIAL: Maintenance — list screen, create screen, models, repository, providers |
| 2026-02-09 | (Other device) Home screen with greeting, rent card, quick actions, upcoming cheques, activity |
| 2026-02-09 | (Other device) React dashboard scaffolded with all pages, auth, API client |
| 2026-02-09 | (Other device) UI overhaul — indigo color system, Doha skyline, custom tab bar, redesigned auth screens |
| 2026-02-09 | (Other device) Localization expanded to 185 keys EN/AR |
| 2026-02-09 | (Other device) iOS project files added (Runner, Xcode config, Podfile) |
| 2026-02-09 | Step 5 COMPLETE: Cheque status actions (deposit/clear/bounce), maintenance detail screen with comments + rating, notification system (model/repo/providers/screen), pull-to-refresh, dynamic routes, l10n 230+ keys |

### New Files Created (This Session)
| File | Purpose |
|------|---------|
| `mobile/lib/features/maintenance/screens/maintenance_detail_screen.dart` | Full detail screen with status, info card, rating widget, comments |
| `mobile/lib/features/notifications/models/notification_model.dart` | Notification data model (bilingual title/body) |
| `mobile/lib/features/notifications/repositories/notification_repository.dart` | API calls for notifications + device registration |
| `mobile/lib/features/notifications/providers/notification_providers.dart` | Riverpod providers for notification list + unread count |
| `mobile/lib/features/notifications/screens/notification_list_screen.dart` | Notification list with type icons, unread indicators, mark all read |

## Conventions
- Django: snake_case, DRF ModelViewSet, DefaultRouter
- Flutter: camelCase, feature-first folder structure, Riverpod for state
- React: TypeScript, TanStack Query for API state, feature-based folders
- Phone format: +974XXXXXXXX (Qatar)
- QID: 11-digit number
- Currency: QAR (ر.ق for Arabic)
- Default locale: English (changed from Arabic)
- UUID primary keys on all models
- Color system: Indigo primary (#818CF8), Navy dark (#1E1B4B)
