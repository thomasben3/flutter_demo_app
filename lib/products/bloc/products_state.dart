part of 'products_bloc.dart';

/*
  States of ProductsBloc
*/
sealed class ProductsState extends Equatable {
  const ProductsState(this._products);

  final List<Product> _products;

  List<Product> get products => _products;

  @override
  List<Object> get props => [];
}

/*
  State when loading.
*/
final class ProductsInitialState extends ProductsState {
  const ProductsInitialState() : super(const []);
}

/*
  State when loaded.
*/
final class ProductsLoadedState extends ProductsState {
  const ProductsLoadedState({
    List<Product> products = const []
  }) : super(products);

  @override
  List<Object> get props => [
    _products
  ];

}

/*
  State when error while loading.
*/
final class ProductsErrorState extends ProductsState {
  const ProductsErrorState(this.exception) : super(const []);

  final Exception exception;
}