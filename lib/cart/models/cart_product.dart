import 'package:equatable/equatable.dart';

class CartProduct extends Equatable {
  const CartProduct({
    required this.id,
    required this.quantity,
  });

  final int id;
  final int quantity;

  @override
  List<Object?> get props => [id, quantity];
}