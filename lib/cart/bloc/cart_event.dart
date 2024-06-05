part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

final class CartInitEvent extends CartEvent {
  const CartInitEvent();
}

class AddProductToCartEvent extends CartEvent {
  const AddProductToCartEvent(
    this.productId, {
    this.quantity = 1
  });

  final int productId;
  final int quantity;
}

class RemoveCartProductEvent extends CartEvent {
  const RemoveCartProductEvent(this.productId);

  final int productId;
}