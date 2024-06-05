part of 'products_bloc.dart';

sealed class ProductsState extends Equatable {
  const ProductsState(this._products);

  final List<Product> _products;

  List<Product> get products => _products;

  int getTotalPrice(List<CartProduct> cartProducts) {
    int count = 0;
    
    for (CartProduct cartProduct in cartProducts) {
      final Product product = products.firstWhere((p) => p.id == cartProduct.id, orElse: () => Product.sample());
      if (product.id == -1) continue;

      count += product.price * cartProduct.quantity;
    }

    return count;
  }

  int getTotalPublicPrice(List<CartProduct> cartProducts) {
    int count = 0;
    
    for (CartProduct cartProduct in cartProducts) {
      final Product product = products.firstWhere((p) => p.id == cartProduct.id, orElse: () => Product.sample());
      if (product.id == -1) continue;

      count += product.publicPrice * cartProduct.quantity;
    }

    return count;
  }

  @override
  List<Object> get props => [];
}

final class ProductsInitialState extends ProductsState {
  const ProductsInitialState() : super(const []);

}

final class ProductsLoadedState extends ProductsState {
  const ProductsLoadedState({
    List<Product> products = const []
  }) : super(products);

  @override
  List<Object> get props => [
    _products
  ];

}

final class ProductsErrorState extends ProductsState {
  const ProductsErrorState(this.exception) : super(const []);

  final Exception exception;
}