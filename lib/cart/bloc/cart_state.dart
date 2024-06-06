part of 'cart_bloc.dart';

/*
  States of CartBloc
*/
sealed class CartState extends Equatable {
  const CartState(List<CartProduct> products) : _products = products;

  final List<CartProduct> _products;

  List<CartProduct> get products => _products;

  int get nbProducts {
    int count = 0;

    for (CartProduct product in products) {
      count += product.quantity;
    }
    return count;
  }

  int nbProductsById(int id) {
    return products.firstWhere((e) => e.id == id, orElse: () => const CartProduct(id: -1, quantity: 0)).quantity;
  }

  @override
  List<Object> get props => [_products];
}

/*
  State when loading.
*/
final class CartInitialState extends CartState {
  const CartInitialState() : super(const []);
}

/*
  State when loaded.
*/
final class CartLoadedState extends CartState {
  const CartLoadedState(super.products);
}
