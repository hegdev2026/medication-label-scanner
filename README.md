# MedScan

MedScan reads the printed text on a medicine package, lets you review and
correct it, and keeps a personal inventory with expiry reminders. Everything
stays on the device: no account, no server, no cloud AI.

> **MedScan is not a medical tool.** It does not identify medicines, check
> doses or interactions, or say whether a medicine is safe to use. Text
> recognition can make mistakes, so always check every value against the
> package itself.

## Features

- **Scan** a package with the camera, import a photo from the gallery, or enter
  the details by hand. Text is read on the device (Google ML Kit).
- **Review & confirm** what was read before anything is saved. Doubtful values
  are flagged, and names and dates are never guessed.
- **Inventory** of saved medicines: search, filter by dosage form, sort, and
  switch between list and grid.
- **Expiry tracker** grouped by how close the printed date is (expired, within
  30 / 60 / 90 days, no date), with local reminders before the date.
- **Details, edit and delete** for each medicine, with a duplicate check on save.
- **Settings:** light, dark or system theme; English and Hindi; Terms of
  Service and Privacy Policy.
- **Polish:** shimmer skeleton loading on every data screen, platform-styled
  menus and dialogs (iOS and Material), responsive layouts for phones and
  tablets, reduced-motion support.

## Platform support

| Capability | Android / iOS | Other platforms |
| --- | --- | --- |
| Text recognition (ML Kit) | Yes | Not available; enter details manually |
| Camera capture | Where the device supports it | Pick an image file instead |
| Expiry reminders | Yes | Where local notifications are supported |

## Getting started

Requirements: Flutter with Dart `^3.11.4` (see `pubspec.yaml`).

```bash
flutter pub get
make gen        # generates DI and database code (build_runner)
flutter run
```

### Commands

| Command | What it does |
| --- | --- |
| `make gen` | `dart run build_runner build --delete-conflicting-outputs` |
| `make watch` | Same, in watch mode |
| `make analyze` | `flutter analyze` |
| `make test` | `flutter test` |

Run `make gen` again after changing an `@injectable` class, a `@module`, or a
Drift table. Before finishing any change, `flutter analyze` must be clean and
`flutter test` green.

## Architecture

Feature-first, with dependencies pointing inward:
`presentation → domain ← data`. The domain layer imports no Flutter, Drift or
ML Kit code.

```
lib/
├── core/            di, router, theme, constants, error, base, database, services
├── common/          adaptive helpers and shared widgets (AppButton, AppSurface, …)
└── features/
    ├── dashboard/   Home
    ├── scanner/     camera / gallery capture and on-device OCR
    ├── medicines/   inventory, details, add / edit / review form
    ├── expiry/      expiry tracker
    ├── settings/    theme, language, Terms of Service, Privacy Policy
    └── shell/       bottom-navigation shell
```

Each feature is split into `domain/` (`entities/`, `repo/`, `usecase/`,
`services/`), `data/` (`models/`, `sources/`, `repository/`) and
`presentation/` (`bloc/`, `pages/`, `widgets/`, `routes/`).

- **State:** `flutter_bloc` only (Bloc for main flows, Cubit for small ones),
  with Equatable states and no `setState` for business state.
- **DI:** `get_it` + `injectable` annotations (`@injectable`, `@lazySingleton`,
  `@module`); never hand-registered.
- **Storage:** Drift (SQLite) for records, `shared_preferences` for settings,
  images in the app's private directory.
- **Errors:** use cases return `Either<Failure, T>` (dartz); failures carry
  translation keys.

### Routing

Routing is module-wise with `go_router`. Each feature owns
`presentation/routes/<feature>_routes.dart`, which exports one `FeatureRoutes`
value: a `tab` route for the bottom bar and/or `fullScreen` routes pushed over
the shell. `core/router/app_router.dart` only lists the modules, and all path
constants live in `AppRoutes`. To add a screen, add it to its feature's
`FeatureRoutes`; to add a tab, add the module to `AppRouter.tabModules` (and
the shell's destinations, in the same order).

### UI conventions

- Colours only through `AppColors`, type through `AppText`, spacing and radius
  through `AppSpace` / `AppRadius`. `AppColors` members are runtime getters, so
  never use them in `const` expressions. Check both light and dark.
- Reuse `lib/common/widgets/` before writing new widgets: `AppButton`,
  `AppSurface`, `AppTextField`, `SectionCard`, `SummaryTile`, `FilterPill`,
  `ActionMenuButton` / `showBubbleMenu`, `showDeleteConfirmDialog`,
  `CustomToast`, `AppSkeleton` / `SkeletonCard`.
- No SnackBars or raw Material buttons.
- Layout via `AdaptiveView`, `ScreenSizeBuilder` or `context.byFormFactor`;
  never branch on `Platform` or raw widths.
- Every UI string goes through `tr()`, with keys added to both
  `assets/translations/en.json` and `hi.json`.
- No `!` operator; use early returns, `?.` and `??`.
- Asset paths are named constants in `AppAssets`.

The full rules are in [CLAUDE.md](CLAUDE.md).

## Branding

The logo lives in `assets/images/` (named in `AppAssets`): `logo.png` (the full
logo), `logo_mark.png` (scan frame and capsule, used in the
app bar), and `app_icon.png` / `app_icon_foreground.png` (launcher icon). After
changing the icon files, run `dart run flutter_launcher_icons` to regenerate
the Android and iOS icons.

The native splash screen (`splash_logo.png` on the app's light-green colour) is
configured under `flutter_native_splash` in `pubspec.yaml`; after changing it,
run `dart run flutter_native_splash:create`.

## Localization

English and Hindi, using `easy_localization`. Add every new key to both
`assets/translations/en.json` and `assets/translations/hi.json`. Theme and
language changes repaint the whole app at once (`ThemeScope`).

## Testing

```bash
flutter test
```

Covers the label parser, dosage categories, theme tokens and the
theme/locale repaint, the router's tab order and routes, loading skeleton
layouts, and that every legal-text key exists in both languages.

## Privacy

Photos, the text read from them and saved details stay on the device. The one
network request the app may make is downloading its typeface from Google Fonts
on first run, which carries no medicine data; bundling the font would remove it.
See the in-app Privacy Policy (Settings → Legal) for the full text. The legal
text is a sensible default and should be reviewed by a lawyer before release, and
the Hindi translations should be checked by a native speaker.

## Safety rules for contributors

- Show OCR values for the user to review; never guess names or dates.
- Never claim a medicine is safe, or add diagnosis, dosage, interaction or
  alternative-medicine advice. If cloud AI analysis is ever added, the
  Terms of Service and Privacy Policy must be rewritten first, because photos
  would then leave the device.
