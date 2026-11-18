import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:medicine_lab_reader/common/widgets/ads/ad_banner.dart';
import 'package:medicine_lab_reader/common/widgets/ads/ad_native.dart';
import 'package:medicine_lab_reader/core/ads/ad_service.dart';
import 'package:medicine_lab_reader/core/ads/ads_cubit.dart';
import 'package:medicine_lab_reader/core/ads/app_open_gate.dart';
import 'package:medicine_lab_reader/core/ads/app_open_policy.dart';
import 'package:medicine_lab_reader/core/ads/break_policy.dart';

class _Service extends Mock implements AdService {}

void main() {
  late _Service service;
  late AppOpenGate gate;
  late DateTime now;

  AdsCubit make() {
    final c = AdsCubit(service, gate)
      ..clock = (() => now)
      ..resumeDelay = Duration.zero;
    addTearDown(c.close);
    return c;
  }

  Future<AdsCubit> started() async {
    final c = make();
    await c.start();
    return c;
  }

  setUp(() {
    now = DateTime(2026, 11, 18, 12);
    service = _Service();
    gate = AppOpenGate();
    when(() => service.start()).thenAnswer((_) async => true);
    when(() => service.privacyOptionsRequired).thenAnswer((_) async => false);
    when(() => service.fullScreenShowing).thenReturn(false);
    when(() => service.showInterstitial()).thenAnswer((_) async => true);
    when(() => service.showAppOpen()).thenAnswer((_) async => true);
  });

  group('BreakPolicy', () {
    test('nothing early; a full-screen ad on every 3rd break', () {
      final p = BreakPolicy(minGap: Duration.zero);
      final t = DateTime(2026);
      expect(
        [for (var i = 0; i < 6; i++) p.next(t)],
        [
          AdBreak.none,
          AdBreak.none,
          AdBreak.interstitial,
          AdBreak.none,
          AdBreak.none,
          AdBreak.interstitial,
        ],
      );
    });

    test('nothing within the minimum gap of the last ad', () {
      final p = BreakPolicy();
      var t = DateTime(2026);
      for (var i = 0; i < 2; i++) {
        p.next(t);
      }
      expect(p.next(t), AdBreak.interstitial);
      p.markShown(t);
      t = t.add(const Duration(minutes: 1));
      for (var i = 0; i < 2; i++) {
        p.next(t);
      }
      expect(p.next(t), AdBreak.none); // the 6th, but too soon
    });
  });

  group('AppOpenPolicy', () {
    test('only after being away long enough, and not twice in a row', () {
      final p = AppOpenPolicy();
      final left = DateTime(2026, 1, 1, 10);
      expect(
        p.shouldShow(left: left, now: left.add(const Duration(minutes: 1))),
        isFalse,
      );
      final back = left.add(const Duration(minutes: 5));
      expect(p.shouldShow(left: left, now: back), isTrue);
      p.markShown(back);
      final later = back.add(const Duration(minutes: 10));
      expect(
        p.shouldShow(left: back.add(const Duration(minutes: 5)), now: later),
        isFalse,
      );
      final muchLater = back.add(const Duration(minutes: 40));
      expect(p.shouldShow(left: later, now: muchLater), isTrue);
    });
  });

  group('AppOpenGate', () {
    test('a deliberate trip away skips exactly one return', () {
      final g = AppOpenGate()..leavingTemporarily();
      final t = DateTime(2026);
      expect(g.consumeSkip(t), isTrue);
      expect(g.consumeSkip(t), isFalse);
    });

    test('a tapped reminder holds ads for a short while', () {
      final g = AppOpenGate();
      final t = DateTime(2026);
      g.holdFor(const Duration(seconds: 30), t);
      expect(g.consumeSkip(t.add(const Duration(seconds: 10))), isTrue);
      expect(g.consumeSkip(t.add(const Duration(seconds: 31))), isFalse);
    });
  });

  group('AdsCubit: start and breaks', () {
    test('ads show only after the SDK is ready', () async {
      final c = make();
      expect(c.state.showAds, isFalse);
      await c.start();
      expect(c.state.showAds, isTrue);
    });

    test('a failed start means no ads, and the app is unaffected', () async {
      when(() => service.start()).thenAnswer((_) async => false);
      final c = await started();
      expect(c.state.showAds, isFalse);
      for (var i = 0; i < 6; i++) {
        expect(c.nextBreak(), AdBreak.none);
      }
    });

    test('a full-screen ad follows only every third added medicine', () async {
      final c = await started();
      expect(c.nextBreak(), AdBreak.none);
      expect(c.nextBreak(), AdBreak.none);
      expect(c.nextBreak(), AdBreak.interstitial);
      await c.showInterstitial();
      verify(() => service.showInterstitial()).called(1);
    });

    test(
      'privacy choices are offered only when the region requires them',
      () async {
        when(
          () => service.privacyOptionsRequired,
        ).thenAnswer((_) async => true);
        final c = await started();
        expect(c.state.privacyOptionsRequired, isTrue);
      },
    );
  });

  group('AdsCubit: App Open', () {
    Future<AdsCubit> away(Duration howLong) async {
      final c = await started();
      c.onAppLeft();
      now = now.add(howLong);
      return c;
    }

    test('shows after a long enough absence', () async {
      final c = await away(const Duration(minutes: 10));
      await c.onAppResumed();
      verify(() => service.showAppOpen()).called(1);
    });

    test('not after a short absence', () async {
      final c = await away(const Duration(minutes: 1));
      await c.onAppResumed();
      verifyNever(() => service.showAppOpen());
    });

    test('not when returning from the camera or a web link', () async {
      final c = await away(const Duration(minutes: 10));
      gate.leavingTemporarily();
      await c.onAppResumed();
      verifyNever(() => service.showAppOpen());
      // the next real return is eligible again
      c.onAppLeft();
      now = now.add(const Duration(minutes: 10));
      await c.onAppResumed();
      verify(() => service.showAppOpen()).called(1);
    });

    test('not right after tapping a reminder notification', () async {
      final c = await away(const Duration(minutes: 10));
      gate.holdFor(const Duration(seconds: 30), now);
      await c.onAppResumed();
      verifyNever(() => service.showAppOpen());
    });

    test('not while one of our own full-screen ads is on screen', () async {
      final c = await started();
      when(() => service.fullScreenShowing).thenReturn(true);
      c.onAppLeft(); // the app pausing because an ad opened is not "leaving"
      now = now.add(const Duration(minutes: 10));
      await c.onAppResumed();
      verifyNever(() => service.showAppOpen());
    });
  });

  group('ad widgets', () {
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
