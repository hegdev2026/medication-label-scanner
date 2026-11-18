import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:medicine_lab_reader/common/widgets/ads/ad_banner.dart';
import 'package:medicine_lab_reader/common/widgets/ads/ad_native.dart';
import 'package:medicine_lab_reader/core/ads/ad_free_store.dart';
import 'package:medicine_lab_reader/core/ads/ad_service.dart';
import 'package:medicine_lab_reader/core/ads/ads_cubit.dart';
import 'package:medicine_lab_reader/core/ads/interstitial_policy.dart';

class _Service extends Mock implements AdService {}

class _Store extends Mock implements AdFreeStore {}

void main() {
  late _Service service;
  late _Store store;
  late DateTime now;

  AdsCubit make() {
    final c = AdsCubit(service, store);
    c.clock = () => now;
    addTearDown(c.close);
    return c;
  }

  setUp(() {
    now = DateTime(2026, 11, 18, 12);
    service = _Service();
    store = _Store();
    when(() => store.read()).thenReturn(null);
    when(() => store.write(any())).thenAnswer((_) async {});
    when(() => service.start()).thenAnswer((_) async => true);
    when(() => service.privacyOptionsRequired).thenAnswer((_) async => false);
    when(() => service.showInterstitial()).thenAnswer((_) async => true);
    when(() => service.showRewarded()).thenAnswer((_) async => true);
  });

  group('InterstitialPolicy', () {
    test('never on the first two breaks, then every third', () {
      final p = InterstitialPolicy();
      final t = DateTime(2026);
      expect(
        [p.shouldShow(t), p.shouldShow(t), p.shouldShow(t)],
        [false, false, true],
      );
    });

    test('not again within the minimum gap, even on the next third break', () {
      final p = InterstitialPolicy();
      var t = DateTime(2026);
      for (var i = 0; i < 3; i++) {
        p.shouldShow(t);
      }
      p.markShown(t);
      t = t.add(const Duration(minutes: 1));
      expect(
        [p.shouldShow(t), p.shouldShow(t), p.shouldShow(t)],
        [false, false, false],
      );
      t = t.add(const Duration(minutes: 10));
      for (var i = 0; i < 2; i++) {
        p.shouldShow(t);
      }
      expect(p.shouldShow(t), isTrue);
    });
  });

  group('AdsCubit', () {
    test('ads show only after the SDK is ready', () async {
      final c = make();
      expect(c.state.showAds(now), isFalse);
      await c.start();
      expect(c.state.showAds(now), isTrue);
    });

    test('a failed start means no ads, and the app is unaffected', () async {
      when(() => service.start()).thenAnswer((_) async => false);
      final c = make();
      await c.start();
      expect(c.state.showAds(now), isFalse);
      await c.onMedicineAdded();
      verifyNever(() => service.showInterstitial());
    });

    test('a saved ad-free time hides ads until it ends', () async {
      when(() => store.read()).thenReturn(now.add(const Duration(hours: 5)));
      final c = make();
      await c.start();
      expect(c.state.showAds(now), isFalse);
      expect(c.state.showAds(now.add(const Duration(hours: 6))), isTrue);
    });

    test(
      'watching a rewarded video earns 24 ad-free hours and saves them',
      () async {
        final c = make();
        await c.start();
        expect(await c.watchToRemoveAds(), isTrue);
        expect(c.state.adFreeUntil, now.add(const Duration(hours: 24)));
        expect(c.state.showAds(now), isFalse);
        verify(() => store.write(now.add(const Duration(hours: 24)))).called(1);
      },
    );

    test('closing the video early earns nothing', () async {
      when(() => service.showRewarded()).thenAnswer((_) async => false);
      final c = make();
      await c.start();
      expect(await c.watchToRemoveAds(), isFalse);
      expect(c.state.adFreeUntil, isNull);
      verifyNever(() => store.write(any()));
    });

    test('a full-screen ad follows only every third added medicine', () async {
      final c = make();
      await c.start();
      await c.onMedicineAdded();
      await c.onMedicineAdded();
      verifyNever(() => service.showInterstitial());
      await c.onMedicineAdded();
      verify(() => service.showInterstitial()).called(1);
    });

    test('no full-screen ad during an ad-free period', () async {
      when(() => store.read()).thenReturn(now.add(const Duration(hours: 1)));
      final c = make();
      await c.start();
      for (var i = 0; i < 6; i++) {
        await c.onMedicineAdded();
      }
      verifyNever(() => service.showInterstitial());
    });
  });

  group('ad widgets', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      EasyLocalization.logger.enableLevels = [];
    });

    testWidgets('banner and native take no space while ads are off', (t) async {
      final c = make(); // not started: ads are off
      await t.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: c,
            child: const Scaffold(
              body: Column(children: [AdBanner(), AdNative(), Text('end')]),
            ),
          ),
        ),
      );
      expect(find.text('end'), findsOneWidget);
      expect(t.getSize(find.byType(AdBanner)), Size.zero);
      expect(t.getSize(find.byType(AdNative)), Size.zero);
      expect(t.takeException(), isNull);
    });
  });
}
