import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:medicine_lab_reader/features/app_update/domain/entities/app_update_info.dart';
import 'package:medicine_lab_reader/features/app_update/domain/entities/app_update_policy.dart';
import 'package:medicine_lab_reader/features/app_update/domain/services/app_update_service.dart';
import 'package:medicine_lab_reader/features/app_update/domain/usecase/check_app_update_usecase.dart';
import 'package:medicine_lab_reader/features/app_update/domain/usecase/install_app_update_usecase.dart';
import 'package:medicine_lab_reader/features/app_update/domain/usecase/start_app_update_usecase.dart';
import 'package:medicine_lab_reader/features/app_update/presentation/bloc/app_update_cubit.dart';

class _Service extends Mock implements AppUpdateService {}

const _optional = AppUpdateInfo(method: AppUpdateMethod.flexible);
const _mandatory = AppUpdateInfo(
  method: AppUpdateMethod.immediate,
  mandatory: true,
);

void main() {
  late _Service service;
  late StreamController<void> downloaded;
  late DateTime now;

  AppUpdateCubit make() {
    final c = AppUpdateCubit(
      service,
      CheckAppUpdateUsecase(service),
      StartAppUpdateUsecase(service),
      InstallAppUpdateUsecase(service),
    )..clock = (() => now);
    addTearDown(c.close);
    return c;
  }

  void offers(AppUpdateInfo? info) =>
      when(() => service.check()).thenAnswer((_) async => info);

  setUpAll(() => registerFallbackValue(AppUpdateMethod.flexible));

  setUp(() {
    now = DateTime(2026, 11, 20, 9);
    service = _Service();
    downloaded = StreamController<void>.broadcast();
    addTearDown(downloaded.close);
    when(() => service.downloaded).thenAnswer((_) => downloaded.stream);
    when(() => service.install()).thenAnswer((_) async {});
  });

  test('policy: priority 4+ or 30+ days old is mandatory', () {
    expect(AppUpdatePolicy.isMandatory(priority: 3), isFalse);
    expect(AppUpdatePolicy.isMandatory(priority: 4), isTrue);
    expect(
      AppUpdatePolicy.isMandatory(priority: 0, stalenessDays: 29),
      isFalse,
    );
    expect(AppUpdatePolicy.isMandatory(priority: 0, stalenessDays: 30), isTrue);
  });

  test('no update, or a failed check, offers nothing', () async {
    offers(null);
    final c = make();
    await c.check();
    expect(c.state.status, AppUpdateStatus.idle);

    when(() => service.check()).thenThrow(Exception('not from Play'));
    final d = make();
    await d.check();
    expect(d.state.status, AppUpdateStatus.idle);
  });

  test('check runs once per session', () async {
    offers(null);
    final c = make();
    await c.check();
    await c.check();
    verify(() => service.check()).called(1);
  });

  test('flexible: offer, download, ready, install', () async {
    offers(_optional);
    when(() => service.start(any())).thenAnswer((_) async => true);
    final c = make();
    await c.check();
    expect(c.state.status, AppUpdateStatus.available);
    await c.update();
    expect(c.state.status, AppUpdateStatus.downloading);
    downloaded.add(null);
    await Future<void>.delayed(Duration.zero);
    expect(c.state.status, AppUpdateStatus.downloaded);
    await c.restart();
    verify(() => service.install()).called(1);
  });

  test('declining an optional update lets it go; Later is respected', () async {
    offers(_optional);
    when(() => service.start(any())).thenAnswer((_) async => false);
    final c = make();
    await c.check();
    await c.update();
    expect(c.state.status, AppUpdateStatus.dismissed);
    now = now.add(const Duration(hours: 7));
    await c.recheck(); // still optional: not asked again
    expect(c.state.status, AppUpdateStatus.dismissed);
  });

  test(
    'a mandatory update cannot be dismissed and returns after a no',
    () async {
      offers(_mandatory);
      when(() => service.start(any())).thenAnswer((_) async => false);
      final c = make();
      await c.check();
      expect(c.state.status, AppUpdateStatus.mandatory);
      c.dismiss();
      expect(c.state.status, AppUpdateStatus.mandatory);
      await c.update();
      expect(c.state.status, AppUpdateStatus.mandatory);
    },
  );

  test('Later, then it becomes mandatory: asked again on return', () async {
    offers(_optional);
    final c = make();
    await c.check();
    c.dismiss();
    offers(_mandatory);
    now = now.add(const Duration(hours: 7));
    await c.recheck();
    expect(c.state.status, AppUpdateStatus.mandatory);
  });

  test('a download finished while away is offered on return', () async {
    offers(_optional);
    final c = make();
    await c.check();
    c.dismiss();
    offers(
      const AppUpdateInfo(method: AppUpdateMethod.flexible, downloaded: true),
    );
    now = now.add(const Duration(hours: 7));
    await c.recheck();
    expect(c.state.status, AppUpdateStatus.downloaded);
  });

  test(
    'a failed in-app update says so, then falls back to the store page',
    () async {
      offers(_mandatory);
      when(
        () => service.start(AppUpdateMethod.immediate),
      ).thenThrow(Exception('play failed'));
      when(
        () => service.start(AppUpdateMethod.store),
      ).thenAnswer((_) async => true);
      final c = make();
      final seen = <AppUpdateStatus>[];
      c.stream.listen((s) {
        seen.add(s.status);
      });
      await c.check();
      await c.update();
      await Future<void>.delayed(Duration.zero);
      expect(seen, contains(AppUpdateStatus.failed));
      expect(c.state.status, AppUpdateStatus.mandatory); // not trapped
      await c.update();
      verify(() => service.start(AppUpdateMethod.store)).called(1);
    },
  );

  test(
    'a blocked person is let through once Play has no newer version',
    () async {
      offers(_mandatory);
      final c = make();
      await c.check();
      offers(null);
      await c.recheck();
      expect(c.state.status, AppUpdateStatus.idle);
    },
  );
}
