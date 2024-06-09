import 'dart:math';
import 'package:benebono_technical_ex/cart/bloc/cart_bloc.dart';
import 'package:benebono_technical_ex/products/models/products.dart';
import 'package:benebono_technical_ex/products/view/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
  This widget represents a Product inside of HomeView / _ListProducts
*/
class ProductWidget extends StatelessWidget {
  const ProductWidget(this.product, {super.key});

  final Product product;

  static const Color backgroundColor = Color.fromARGB(255, 235, 235, 235);
  static const double productHeight = 120;
  static const double productBorderRadius = 20;
  static const IconData addToCartIcon = Icons.add_shopping_cart_rounded;

  static double  getProductWidth(BuildContext context) => min(400, MediaQuery.of(context).size.width * 0.95);

  bool    _isProductInCart(BuildContext context) => context.watch<CartBloc>().state.products.any((e) => e.id == product.id);

  int     _getProductQuantityInCart(BuildContext context) => context.read<CartBloc>().state.products.firstWhere((e) => e.id == product.id).quantity;

  bool    _canAddProductInCart(BuildContext context) => _getProductQuantityInCart(context) < product.availableUnits;

  // this function shows the details of the current product
  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bContext) => BlocProvider.value(
        value: context.read<CartBloc>(),
        child: ProductDetailsView(product: product),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _showDetails(context),
      child: Ink(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(productBorderRadius),
          color: backgroundColor
        ),
        height: productHeight,
        width: getProductWidth(context),
        child: Row(
          children: [
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        text: '${product.priceInEuros.toStringAsFixed(2)}€',
                        children: [
                          TextSpan(
                            style: const TextStyle(color: Colors.grey),
                            text: ' • ',
                            children: [
                              TextSpan(
                                style: const TextStyle(decoration: TextDecoration.lineThrough),
                                text: '${product.publicPriceInEuros.toStringAsFixed(2)}€'
                              )
                            ]
                          )
                        ]
                      )
                    ),
                    Text('${product.grams}g', style: const TextStyle(color: Colors.grey))
                  ],
                )
              ],
            )),
            const SizedBox(width: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                const VerticalDivider(color: Colors.grey, thickness: 0.5),
                Material(
                  borderRadius: BorderRadius.circular(100),
                  color: backgroundColor,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: _isProductInCart(context) ? null : () => context.read<CartBloc>().add(AddProductToCartEvent(product.id)),
                    child: AnimatedContainer(
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 400),
                      width: 32,
                      height: _isProductInCart(context) ? 84 : 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)
                      ),
                      child: _isProductInCart(context) ?
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _canAddProductInCart(context) ? // ternary to prevent from adding more than available items in cart.
                                    () => context.read<CartBloc>().add(AddProductToCartEvent(product.id))
                                    : null,
                                  borderRadius: BorderRadius.circular(100),
                                  child: SizedBox(
                                    height: 32,
                                    width: 32,
                                    child: Icon(Icons.add_rounded, size: 20, color: _canAddProductInCart(context) ? null : Colors.grey)
                                  )
                                  ),
                              ),
                              Text(_getProductQuantityInCart(context).toString()),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => context.read<CartBloc>().add(RemoveCartProductEvent(product.id)),
                                  borderRadius: BorderRadius.circular(100),
                                  child: const SizedBox(
                                    height: 32,
                                    width: 32,
                                    child: Icon(Icons.remove_rounded, size: 20)
                                  )
                                  ),
                              ),
                            ],
                          ),
                        )
                        : const Center(child: Icon(addToCartIcon, color: Color.fromARGB(255, 68, 68, 68)))
                    )
                  ),
                )
              ]
            ),
            Image.network(
              product.imageUrl,
              width: (getProductWidth(context) * 0.25),
              loadingBuilder: (ctx, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  width: (getProductWidth(context) * 0.25),
                  child: const Center(
                    child: SizedBox.square(
                      dimension: productHeight * 0.35,
                      child: CircularProgressIndicator(color: Colors.grey, strokeWidth: 2)
                    ),
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
