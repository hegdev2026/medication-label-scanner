part of 'products_cubit.dart';

enum ProductsStatus { loading, loaded }

class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductsStatus.loading,
    this.products = const [],
    this.showAll = false,
  });
  final ProductsStatus status;
  final List<MedicineProduct> products;
  final bool showAll;

  ProductsState copyWith({bool? showAll}) => ProductsState(
    status: status,
    products: products,
    showAll: showAll ?? this.showAll,
  );

  @override
  List<Object?> get props => [status, products, showAll];
}
