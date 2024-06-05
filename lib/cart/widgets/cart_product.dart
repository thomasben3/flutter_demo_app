import 'dart:math';
import 'package:benebono_technical_ex/cart/bloc/cart_bloc.dart';
import 'package:benebono_technical_ex/cart/models/cart_product.dart';
import 'package:benebono_technical_ex/products/models/products.dart';
import 'package:benebono_technical_ex/products/view/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartProductWidget extends StatelessWidget {
  const CartProductWidget({
    super.key,
    required this.cartProduct, 
    required this.product, 
  });

  final CartProduct cartProduct;
  final Product product;

  double getProductWidth(BuildContext context) => min(600, MediaQuery.of(context).size.width);

  // this function shows the details of the current product
  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bContext) => BlocProvider.value(
        value: context.read<CartBloc>(),
        child: ProductDetailsView(product: product, updateCart: true),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDetails(context),
      child: Ink(
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
                        Text('${(product.price / 100).toStringAsFixed(2)}€ / ${AppLocalizations.of(context)!.unit}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => context.read<CartBloc>().add(RemoveCartProductEvent(cartProduct.id)),
                          icon: const Icon(Icons.remove_rounded)
                        ),
                        Text(cartProduct.quantity.toString()),
                        IconButton(
                          onPressed: cartProduct.quantity < product.availableUnits ?
                            () => context.read<CartBloc>().add(AddProductToCartEvent(cartProduct.id))
                            : null,
                          icon: const Icon(Icons.add_rounded)
                        )
                      ],
                    )
                  ],
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}