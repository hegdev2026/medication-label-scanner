import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_product.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_seed.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/get_medicine_products_usecase.dart';

part 'products_state.dart';

/// The brands and strengths a search matches, each addable on its own.
@injectable
class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._get) : super(const ProductsState());
  final GetMedicineProductsUsecase _get;

  /// Rows shown before "show all".
  static const preview = 8;

  Future<void> load(MedicineSeed seed) async {
    final result = await _get(seed);
    if (isClosed) return;
    emit(
      ProductsState(
        status: ProductsStatus.loaded,
        products: result.getOrElse(() => const []),
      ),
    );
  }

  void toggleAll() => emit(state.copyWith(showAll: !state.showAll));
}
