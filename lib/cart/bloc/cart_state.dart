part of 'cart_bloc.dart';

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

final class CartInitialState extends CartState {
  const CartInitialState() : super(const []);
}

final class CartLoadedState extends CartState {
  const CartLoadedState(super.products);

  //return a copy of current state with a product added in choosen quantity, if it doesn't exist a new row is created in database via CartService
  CartLoadedState addProduct(int productId, int quantityAdded) {
    // use of List.from to force the state update with a new List.
    final newProducts = List<CartProduct>.from(products);
    final index = newProducts.indexWhere((p) => p.id == productId);

    if (index == -1) {
      CartService.addProduct(productId, quantity: quantityAdded);
      newProducts.add(CartProduct(id: productId, quantity: quantityAdded));
    } else {
      final updatedProduct = CartProduct(id: productId, quantity: newProducts[index].quantity + quantityAdded);

      CartService.updateProductQuantity(productId, updatedProduct.quantity);
      newProducts[index] = updatedProduct;
    }

    return CartLoadedState(newProducts);
  }

  CartLoadedState updateProductQuantity(int productId, int quantity) {
    final newProducts = List<CartProduct>.from(products);
    final index = newProducts.indexWhere((p) => p.id == productId);

    if (index == -1) {
      if (quantity > 0) {
        CartService.addProduct(productId, quantity: quantity);
        newProducts.add(CartProduct(id: productId, quantity: quantity));
      }
    } else {
      final updatedProduct = CartProduct(id: productId, quantity: quantity);

      CartService.updateProductQuantity(productId, updatedProduct.quantity);

      if (quantity > 0) {
        newProducts[index] = updatedProduct;
      } else {
        newProducts.removeAt(index);
      }
    }

    return CartLoadedState(newProducts);
  }

  CartLoadedState removeProduct(int productId) {
    final newProducts = List<CartProduct>.from(products);
    final index = newProducts.indexWhere((p) => p.id == productId);

    if (index != -1) {
      final currentProduct = newProducts[index];
      if (currentProduct.quantity > 1) {
        final updatedProduct = CartProduct(id: productId, quantity: currentProduct.quantity - 1);

        CartService.updateProductQuantity(productId, updatedProduct.quantity);
        newProducts[index] = updatedProduct;
      } else {
        newProducts.removeAt(index);
        CartService.updateProductQuantity(productId, 0); // <-- delete product in database
      }
    }

    return CartLoadedState(newProducts);
  }

}
