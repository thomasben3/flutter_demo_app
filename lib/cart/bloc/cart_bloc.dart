import 'package:benebono_technical_ex/cart/models/cart_product.dart';
import 'package:benebono_technical_ex/cart/models/cart_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartInitialState()) {
    // Initializing the cart state with products from local database
    on<CartInitEvent>((event, emit) async {
      emit(CartLoadedState(await CartService.getProducts()));
    });

    // Adding choosen quantity of a product to the cart
    on<AddProductToCartEvent>((event, emit) {
      if (state is CartLoadedState == false) return ;

      emit(_addProduct(event.productId, event.quantity));
    });

    // Setting the quantity of a product in the cart
    on<SetProductQuantityEvent>((event, emit) {
      if (state is CartLoadedState == false) return ;

      emit(_updateProductQuantity(event.productId, event.quantity));
    });

    // Removing a product from the cart
    on<RemoveCartProductEvent>((event, emit) {
      if (state is CartLoadedState == false) return ;

      emit(_removeProduct(event.productId));
    });
  }

  /*
    return a copy of current state with a product added in choosen quantity,
    if it doesn't exist a new row is created in database via CartService
  */
  CartLoadedState _addProduct(int productId, int quantityAdded) {
    // use of List.from to force the state update with a new List.
    final newProducts = List<CartProduct>.from(state.products);
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

  /*
    return a copy of current state with the quantity of productId updated in a choosen value.
    This function can manage creation, updating and deletion of products.
  */
  CartLoadedState _updateProductQuantity(int productId, int quantity) {
    final newProducts = List<CartProduct>.from(state.products);
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

  /*
    return a copy of current state with the quantity of productId reduced by 1.
    If quantity reach 0 the product is deleted.
  */
  CartLoadedState _removeProduct(int productId) {
    final newProducts = List<CartProduct>.from(state.products);
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
