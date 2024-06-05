import 'dart:math';
import 'package:benebono_technical_ex/cart/bloc/cart_bloc.dart';
import 'package:benebono_technical_ex/cart/models/cart_product.dart';
import 'package:benebono_technical_ex/counter/bloc/counter_bloc.dart';
import 'package:benebono_technical_ex/counter/view/counter.dart';
import 'package:benebono_technical_ex/products/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartProductWidget extends StatelessWidget {
  const CartProductWidget({
    super.key,
    required this.cartProduct, 
    required this.product, 
  });

  final CartProduct cartProduct;
  final Product product;

  double getProductWidth(BuildContext context) => min(600, MediaQuery.of(context).size.width);

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: const EdgeInsets.all(15),
      height: 120,
      width: getProductWidth(context),
      child: Row(
        children: [
          Image.network(product.imageUrl, width: (getProductWidth(context) * 0.25)),
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.title),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${(product.price / 100).toStringAsFixed(2)}€ / unit', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          text: '${(product.priceInEuros * cartProduct.quantity).toStringAsFixed(2)}€',
                          children: [
                            TextSpan(
                              style: const TextStyle(color: Colors.grey),
                              text: ' • ',
                              children: [
                                TextSpan(
                                  style: const TextStyle(decoration: TextDecoration.lineThrough),
                                  text: '${(product.publicPriceInEuros * cartProduct.quantity).toStringAsFixed(2)}€'
                                )
                              ]
                            )
                          ]
                        )
                      ),
                    ],
                  ),
                  BlocProvider(
                    create: (context) => CounterBloc(cartProduct.quantity),
                    child: BlocListener<CounterBloc, CounterState>(
                      listener: (context, state) {
                        if (cartProduct.quantity < state.count) {
                          context.read<CartBloc>().add(AddProductToCartEvent(cartProduct.id));
                        } else {
                          context.read<CartBloc>().add(RemoveCartProductEvent(cartProduct.id));
                        }
                      },
                      child: const Counter(min: 0, colorWhen0: Colors.red),
                    ),
                  )
                ],
              )
            ],
          )),
        ],
      ),
    );
  }
}