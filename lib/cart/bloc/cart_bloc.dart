import 'package:benebono_technical_ex/cart/models/cart_product.dart';
import 'package:benebono_technical_ex/cart/models/cart_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartInitialState()) {
    on<CartInitEvent>((event, emit) async {
      emit(CartLoadedState(await CartService.getProducts()));
    });

    on<AddProductToCartEvent>((event, emit) {
      if (state is CartLoadedState == false) return ;

      final CartLoadedState stateLoaded = state as CartLoadedState;
      emit(stateLoaded.addProduct(event.productId, event.quantity));
    });

    on<RemoveCartProductEvent>((event, emit) {
      if (state is CartLoadedState == false) return ;

      final CartLoadedState stateLoaded = state as CartLoadedState;
      emit(stateLoaded.removeProduct(event.productId));
    });
  }
}
