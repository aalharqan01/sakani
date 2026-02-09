# Sakani Project Context

> **IMPORTANT**: This file MUST be updated after every major task completion, new feature implementation, bug fix, or architectural decision. Before ending any work session or when context is getting large, update the "Current Status" and "Recent Changes" sections. This ensures no context is lost after conversation compaction.

## Project Overview
**Sakani** is a compound/gated community management platform for Qatar. It handles property management, post-dated cheque tracking (killer feature), and maintenance-as-a-service for tenants, landlords, and maintenance staff.

## Tech Stack
- **Backend**: Django 5.1+ / DRF / PostgreSQL 16 / Redis 7 / SimpleJWT / Docker Compose
- **Mobile**: Flutter 3.38.9 / Dart 3.10.8 / Riverpod 2.x / GoRouter / Dio / Freezed
- **Dashboard**: React (not yet started - Phase 2)

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
- **State**: Riverpod 2.x with AsyncNotifier pattern
- **Navigation**: GoRouter with 3 role-based StatefulShellRoute.indexedStack
  - Tenant: Home, Cheques, Maintenance, Profile (4 tabs)
  - Landlord: Dashboard, Units, Cheques, Maintenance, Profile (5 tabs)
  - Maintenance: Tickets, Profile (2 tabs)
- **Theme**: Material 3, primary teal (#0D7377), secondary gold (#C69749)
- **Fonts**: Noto Kufi Arabic (AR) + Inter (EN) via Google Fonts
- **Localization**: flutter gen-l10n, Arabic-first, full RTL support
- **API**: Dio with AuthInterceptor (JWT refresh) + LanguageInterceptor

## Key File Locations
| Purpose | Path |
|---------|------|
| Django settings | `backend/config/settings/base.py` |
| Custom User model | `backend/apps/accounts/models.py` |
| User manager | `backend/apps/accounts/managers.py` |
| Phone auth backend | `backend/apps/accounts/backends.py` |
| Account serializers | `backend/apps/accounts/serializers.py` |
| Account views | `backend/apps/accounts/views.py` |
| Account URLs | `backend/apps/accounts/urls.py` |
| Compound models | `backend/apps/compounds/models.py` |
| Lease models | `backend/apps/leases/models.py` |
| Cheque models | `backend/apps/cheques/models.py` |
| Maintenance models | `backend/apps/maintenance/models.py` |
| Notification models | `backend/apps/notifications/models.py` |
| Docker compose | `backend/docker-compose.yml` |
| Flutter entry | `mobile/lib/main.dart` |
| App widget | `mobile/lib/app.dart` |
| GoRouter | `mobile/lib/core/router/app_router.dart` |
| Role shells | `mobile/lib/core/router/role_shells.dart` |
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
| Login screen | `mobile/lib/features/auth/screens/login_screen.dart` |
| Register screen | `mobile/lib/features/auth/screens/register_screen.dart` |
| Profile screen | `mobile/lib/features/profile/screens/profile_screen.dart` |
| Cheque list (placeholder) | `mobile/lib/features/cheques/screens/cheque_list_screen.dart` |
| Maintenance list (placeholder) | `mobile/lib/features/maintenance/screens/maintenance_list_screen.dart` |
| Validators | `mobile/lib/core/utils/validators.dart` |
| Formatters | `mobile/lib/core/utils/formatters.dart` |
| Enums | `mobile/lib/core/enums/` |
| Plan document | `qatar-tenant-app-plan-v3.md` |

## Superuser Credentials
- Phone: `+97412345678`
- Password: `admin123456`

## API Endpoints (Django)
All under `/api/v1/`:
- Auth: `accounts/register/`, `accounts/login/`, `accounts/token/refresh/`, `accounts/logout/`, `accounts/profile/`, `accounts/change-password/`
- Compounds: `compounds/`, `buildings/`, `units/`, `memberships/`
- Leases: `leases/` (with activate/terminate actions)
- Cheques: `cheques/` (with deposit/clear/bounce/replace/bulk-create/upcoming/overdue/dashboard)
- Maintenance: `maintenance/categories/`, `maintenance/requests/` (with images/quotes/accept/reject/complete/rate/comments)
- Notifications: `notifications/`, `notifications/devices/`

## Development Roadmap
1. ~~Project Scaffolding & Infrastructure~~ **COMPLETE**
2. **Auth Flow (end-to-end)** ← CURRENT
3. Cheque Tracker (first vertical slice)
4. Basic Maintenance Flow
5. Polish for Pilot

## Current Status
**Phase**: Step 2 - Auth Flow (end-to-end)
**Last Updated**: 2026-02-09

### What's Done
- Full Django backend scaffolded with all 7 apps (core, accounts, compounds, leases, cheques, maintenance, notifications)
- All Django models, serializers, viewsets, URLs, admin registered
- Docker Compose running: PostgreSQL 16 (healthy), Redis 7, Django web (port 8000)
- All 31 migrations applied successfully
- Superuser created (+97412345678 / admin123456)
- Django API accessible at http://localhost:8000/api/v1/
- Django admin at http://localhost:8000/admin/
- Flutter project scaffolded with full folder structure
- flutter pub get completed (181 deps resolved)
- flutter gen-l10n auto-generated proper localization files (AppLocalizations is now abstract with AR/EN subclasses)
- Theme, colors, typography, spacing configured
- GoRouter with role-based shells (Tenant/Landlord/Maintenance)
- Placeholder screens for all routes
- API layer: Dio client, interceptors, endpoints, exceptions
- Token storage with flutter_secure_storage

- **Step 2: Auth Flow COMPLETE** — full end-to-end auth working
- Auth files: UserModel, AuthState (sealed class), AuthRepository, AuthNotifier (StateNotifier)
- Login screen wired to API with loading state, error snackbar, role-based redirect
- Register screen with name, phone, password, confirm password, role selection
- GoRouter redirect: unauthenticated→login, authenticated+auth-page→role-home
- Profile screen shows user info, language toggle, logout with confirmation dialog
- app.dart: ConsumerStatefulWidget, checks session on startup, uses generated l10n delegates
- Flutter analyze: 0 issues
- Backend verified: login, register, profile endpoints all working with JWT

### What's In Progress
- Starting Step 3: Cheque Tracker (first vertical slice)

### Known Issues
- `docker-compose.yml` has deprecated `version` attribute (warning only, not blocking)
- Some Flutter packages have newer major versions available (not urgent)

## Auth Flow Files
| Purpose | Path |
|---------|------|
| User model (Dart class) | `mobile/lib/features/auth/models/user_model.dart` |
| Auth state (sealed) | `mobile/lib/features/auth/models/auth_state.dart` |
| Auth repository | `mobile/lib/features/auth/repositories/auth_repository.dart` |
| Auth provider (StateNotifier) | `mobile/lib/features/auth/providers/auth_provider.dart` |

## Recent Changes
| Date | Change |
|------|--------|
| 2026-02-09 | Phase 1 scaffolding complete - all Django apps + Flutter structure |
| 2026-02-09 | Fixed intl version constraint (^0.19.0 → ^0.20.2) for Flutter 3.38 compatibility |
| 2026-02-09 | Created migration files for all apps, ran all migrations |
| 2026-02-09 | Docker services running, superuser created |
| 2026-02-09 | flutter gen-l10n auto-generated proper localization files |
| 2026-02-09 | **Step 2 COMPLETE**: Auth flow end-to-end (UserModel, AuthState, AuthRepository, AuthNotifier, login/register screens, GoRouter redirect, profile with logout) |

## Conventions
- Django: snake_case, DRF ModelViewSet, DefaultRouter
- Flutter: camelCase, feature-first folder structure, Riverpod for state
- Phone format: +974XXXXXXXX (Qatar)
- QID: 11-digit number
- Currency: QAR (ر.ق for Arabic)
- Arabic-first localization (default locale: ar)
- UUID primary keys on all models
