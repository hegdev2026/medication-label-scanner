# MedScan — Coding Rules

Adapted from the hospital_app conventions. Mandatory for all work in this repo.

- **Structure:** feature-first. `lib/features/<feature>/{domain,data,presentation}`; shared code in `lib/core/` (di, router, theme, constants, error, base, services) and `lib/common/` (adaptive, widgets). Dependencies point inward: `presentation → domain ← data`. Domain has no Flutter/Drift/ML Kit imports.
- **Domain folders:** `entities/`, `repo/`, `usecase/` (one class per action, `implements UseCase<T, Params>` returning `Either<Failure, T>` via dartz; `StreamUseCase` for live queries), `services/` for pure logic/interfaces. Data: `models/`, `sources/`, `repository/`.
- **State:** `flutter_bloc` only. Bloc (`*_bloc.dart` + `part` event/state files, sealed events) for main flows; Cubit (+ state file) for small ones. States are Equatable. No `setState` for business state (controllers/animations only).
- **DI:** annotate classes (`@injectable`, `@lazySingleton`, `@module`); never hand-register. Run `make gen` (= `dart run build_runner build --delete-conflicting-outputs`).
- **Routing:** go_router only. Each feature owns `presentation/routes/<feature>_routes.dart`; `core/router/app_router.dart` assembles them; paths live in `AppRoutes`. Close dialogs with `dialogContext.pop(...)`.
- **UI:** pages wire blocs and layout; sub-components live in `widgets/`. Reuse `lib/common/widgets/` (`AppButton`, `AppSurface`, `CustomToast`, `SectionCard`, …) before writing new ones. Never use SnackBar or raw Material buttons.
- **Theme:** colours only via `AppColors`, type via `AppText`, spacing/radius via `AppSpace`/`AppRadius`. `AppColors` members are runtime getters — never put them in `const` expressions. No `Color(0x…)`/`Colors.x` outside `core/theme`. Check light AND dark.
- **Responsive:** use `AdaptiveView` / `ScreenSizeBuilder` / `context.byFormFactor` (`common/adaptive/`); breakpoints live in `AppBreakpoints`. Never branch on `Platform` or raw widths for layout.
- **Localization:** every UI string through `tr()`; add keys to BOTH `assets/translations/en.json` and `hi.json`. Failures and warnings carry translation keys.
- **No `!` operator.** Use flow control (early return, `?.`, `??`, patterns).
- **Assets:** named constants in `AppAssets`.
- **Product safety:** show OCR values for review, never guess names/dates, never claim a medicine is safe (see the MVP plan).
- **Before finishing:** `flutter analyze` clean and `flutter test` green.
