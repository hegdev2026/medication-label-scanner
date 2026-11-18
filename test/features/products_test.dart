import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/features/medicines/data/repository/form_hints_repository_impl.dart';
import 'package:medicine_lab_reader/features/medicines/data/repository/medicine_products_repository_impl.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/ingredient_resolver.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/openfda_source.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/rxnorm_source.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_product.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_seed.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/form_hints.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/form_hints_parser.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/product_name_parser.dart';
import 'package:medicine_lab_reader/features/search/presentation/widgets/product_row.dart';

class _Rx extends Mock implements RxNormSource {}

class _Fda extends Mock implements OpenFdaSource {}

void main() {
  group('ProductNameParser', () {
    test('brand, strength and form', () {
      final p = ProductNameParser.parse(
        'acetaminophen 500 MG Oral Tablet [Tylenol]',
      );
      expect(p?.brand, 'Tylenol');
      expect(p?.genericName, 'Acetaminophen');
      expect(p?.strength, '500 mg');
      expect(p?.form, 'Tablet');
      expect(p?.title, 'Tylenol');
    });

    test('generic product has no brand', () {
      final p = ProductNameParser.parse('ibuprofen 200 MG Oral Tablet');
      expect(p?.brand, isNull);
      expect(p?.title, 'Ibuprofen');
    });

    test('combination keeps every ingredient and strength', () {
      final p = ProductNameParser.parse(
        'acetaminophen 325 MG / oxycodone hydrochloride 5 MG Oral Tablet',
      );
      expect(p?.isCombination, isTrue);
      expect(p?.genericName, 'Acetaminophen + Oxycodone Hydrochloride');
      expect(p?.strength, '325 mg / 5 mg');
    });

    test('liquid strength per mL and the "8 HR" prefix', () {
      expect(
        ProductNameParser.parse(
          'acetaminophen 32 MG/ML Oral Solution',
        )?.strength,
        '32 mg/mL',
      );
      final p = ProductNameParser.parse(
        '8 HR acetaminophen 650 MG Extended Release Oral Tablet [Tylenol]',
      );
      expect(p?.genericName, 'Acetaminophen');
      expect(p?.form, 'Tablet (Extended release)');
    });

    test(
      'volume prefix is stripped and unclear units are skipped, not guessed',
      () {
        final inj = ProductNameParser.parse(
          '100 ML acetaminophen 10 MG/ML Injectable Solution',
        );
        expect(inj?.genericName, 'Acetaminophen');
        expect(inj?.strength, '10 mg/mL');
        expect(inj?.form, 'Injection');
        // "MG/MG" is a percentage in disguise: no row beats a wrong strength.
        expect(
          ProductNameParser.parse('ibuprofen 0.05 MG/MG Topical Gel'),
          isNull,
        );
        expect(
          ProductNameParser.parse('fluticasone 0.05 MG/ACTUAT Nasal Spray'),
          isNull,
        );
        expect(
          ProductNameParser.parse(
            'hydrocortisone 10 MG/G Topical Cream',
          )?.strength,
          '10 mg/g',
        );
      },
    );

    test('tablets sort before injections', () {
      const inj = MedicineProduct(
        genericName: 'Ibuprofen',
        strength: '10 mg/mL',
        form: 'Injection',
      );
      const tab = MedicineProduct(
        genericName: 'Ibuprofen',
        strength: '400 mg',
        form: 'Tablet',
      );
      expect(ProductNameParser.distinct([inj, tab]), [tab, inj]);
    });

    test('packs and names without a strength are skipped', () {
      expect(
        ProductNameParser.parse('{1 (acetaminophen 500 MG Oral Tablet) } Pack'),
        isNull,
      );
      expect(ProductNameParser.parse('acetaminophen Oral Tablet'), isNull);
      expect(ProductNameParser.parse(''), isNull);
    });

    test('distinct drops repeats; singles and generics come first', () {
      const generic = MedicineProduct(
        genericName: 'Ibuprofen',
        strength: '400 mg',
        form: 'Tablet',
      );
      const brand = MedicineProduct(
        genericName: 'Ibuprofen',
        brand: 'Advil',
        strength: '200 mg',
        form: 'Tablet',
      );
      const combo = MedicineProduct(
        genericName: 'Ibuprofen + Famotidine',
        strength: '800 mg / 26.6 mg',
        isCombination: true,
      );
      final out = ProductNameParser.distinct([combo, brand, generic, generic]);
      expect(out, [generic, brand, combo]);
    });
  });

  group('FormHintsParser', () {
    test('label text gives strengths and forms; junk numbers are ignored', () {
      final h = FormHintsParser.fromLabelText(
        '20 mg and 40 mg pantoprazole delayed-release tablets (3) imprinted 51',
      );
      expect(h.strengths, containsAll(['20 mg', '40 mg']));
      expect(h.forms, ['Tablet']);
    });

    test('merge ranks the most repeated first and caps the list', () {
      final h = FormHintsParser.merge([
        const FormHints2(['500 mg', '650 mg']).h,
        const FormHints2(['650 mg']).h,
      ]);
      expect(h.strengths.first, '650 mg');
    });
  });

  group('one source failing never costs the others', () {
    late _Rx rx;
    late _Fda fda;
    setUp(() {
      rx = _Rx();
      fda = _Fda();
      when(() => rx.resolve(any())).thenAnswer((_) async => null);
    });

    test(
      'hints: RxNorm throws, openFDA and the typed name still answer',
      () async {
        when(() => rx.productNames(any())).thenThrow(Exception('429'));
        when(() => fda.dosageTexts(any())).thenAnswer(
          (_) async => ['40 mg pantoprazole delayed-release tablets'],
        );
        final repo = FormHintsRepositoryImpl(rx, fda, IngredientResolver(rx));
        final r = await repo.hintsFor(name: 'Pantoprazole 20mg');
        final h = r.getOrElse(() => throw StateError('left'));
        expect(h.strengths, containsAll(['40 mg', '20 mg']));
        expect(h.forms, contains('Tablet'));
      },
    );

    test(
      'hints: every source failing gives empty hints, not an error',
      () async {
        when(() => rx.productNames(any())).thenThrow(Exception('offline'));
        when(() => fda.dosageTexts(any())).thenThrow(Exception('offline'));
        final repo = FormHintsRepositoryImpl(rx, fda, IngredientResolver(rx));
        final r = await repo.hintsFor(name: 'Crocin');
        expect(r.isRight(), isTrue);
        expect(r.getOrElse(() => throw StateError('left')).isEmpty, isTrue);
      },
    );

    test(
      'products: the typed-name query fails, the ingredient one lists rows',
      () async {
        when(
          () => rx.resolve('crocin'),
        ).thenAnswer((_) async => const RxNormMatch('1', ['acetaminophen']));
        when(() => rx.productNames('Crocin')).thenThrow(Exception('boom'));
        when(() => rx.productNames('acetaminophen')).thenAnswer(
          (_) async => [
            'acetaminophen 500 MG Oral Tablet',
            'acetaminophen 500 MG Oral Tablet [Tylenol]',
            '{1 (x 5 MG Oral Tablet) } Pack',
          ],
        );
        final repo = MedicineProductsRepositoryImpl(rx, IngredientResolver(rx));
        final list = (await repo.productsFor(
          name: 'Crocin',
        )).getOrElse(() => throw StateError('left'));
        expect(list.map((p) => p.title), ['Acetaminophen', 'Tylenol']);
      },
    );

    test(
      'products: the typed brand\'s own rows win over the ingredient list',
      () async {
        when(
          () => rx.resolve('tylenol'),
        ).thenAnswer((_) async => const RxNormMatch('1', ['acetaminophen']));
        when(() => rx.productNames('Tylenol')).thenAnswer(
          (_) async => ['acetaminophen 500 MG Oral Tablet [Tylenol]'],
        );
        when(
          () => rx.productNames('acetaminophen'),
        ).thenAnswer((_) async => ['acetaminophen 500 MG Oral Tablet [Other]']);
        final repo = MedicineProductsRepositoryImpl(rx, IngredientResolver(rx));
        final list = (await repo.productsFor(
          name: 'Tylenol',
        )).getOrElse(() => throw StateError('left'));
        expect(list.map((p) => p.brand), ['Tylenol']);
      },
    );

    test(
      'products: an unknown brand uses the generic the lookup found',
      () async {
        when(() => rx.productNames('Pantop')).thenAnswer((_) async => []);
        when(() => rx.productNames('pantoprazole')).thenAnswer(
          (_) async => ['pantoprazole 40 MG Delayed Release Oral Tablet'],
        );
        final repo = MedicineProductsRepositoryImpl(rx, IngredientResolver(rx));
        final list = (await repo.productsFor(
          name: 'Pantop',
          genericName: 'Pantoprazole',
        )).getOrElse(() => throw StateError('left'));
        expect(list.single.strength, '40 mg');
      },
    );

    test('products: too-short or unknown names give an empty list', () async {
      final repo = MedicineProductsRepositoryImpl(rx, IngredientResolver(rx));
      expect(
        (await repo.productsFor(
          name: 'ab',
        )).getOrElse(() => [MedicineProduct(genericName: 'x')]),
        isEmpty,
      );
      when(() => rx.productNames(any())).thenAnswer((_) async => []);
      expect(
        (await repo.productsFor(
          name: 'Econorm',
        )).getOrElse(() => [MedicineProduct(genericName: 'x')]),
        isEmpty,
      );
    });
  });

  testWidgets('each row has its own add; it carries that row\'s strength', (
    t,
  ) async {
    t.view.physicalSize = const Size(320, 640);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final seeds = <Object?>[];
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(
            body: Column(
              children: [
                ProductRow(
                  query: 'paracetamol',
                  product: MedicineProduct(
                    genericName: 'Acetaminophen',
                    strength: '500 mg',
                    form: 'Tablet',
                  ),
                ),
                ProductRow(
                  query: 'paracetamol',
                  product: MedicineProduct(
                    genericName: 'Acetaminophen',
                    brand: 'Tylenol Extra Strength Long Name For Overflow',
                    strength: '650 mg',
                    form: 'Tablet (Extended release)',
                  ),
                ),
              ],
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.medicineNew,
          builder: (_, state) {
            seeds.add(state.extra);
            return const Scaffold(body: Text('form'));
          },
        ),
      ],
    );
    await t.pumpWidget(MaterialApp.router(routerConfig: router));
    expect(t.takeException(), isNull);
    await t.tap(find.byIcon(Icons.add).last);
    await t.pumpAndSettle();
    expect(seeds.single, isA<MedicineSeed>());
    final s = seeds.single as MedicineSeed;
    expect(s.name, startsWith('Tylenol'));
    expect(s.strength, '650 mg');
    expect(s.dosageForm, 'Tablet (Extended release)');
    expect(s.genericName, 'Acetaminophen');
  });
}

/// Tiny helper to build hints from strengths only.
class FormHints2 {
  const FormHints2(this.s);
  final List<String> s;
  FormHints get h => FormHints(strengths: s);
}
