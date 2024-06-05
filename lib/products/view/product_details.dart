import 'dart:math';
import 'package:benebono_technical_ex/cart/bloc/cart_bloc.dart';
import 'package:benebono_technical_ex/counter/cubit/counter_cubit.dart';
import 'package:benebono_technical_ex/counter/view/counter.dart';
import 'package:benebono_technical_ex/products/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({
    super.key,
    required this.product,
    this.updateCart = false
  });

  final Product product;

  // if updateCart == true then the view show/update directly the cart.
  // Otherwise the view show a new counter, then add it to the current cart when we click on the button
  final bool    updateCart;

  static const double _imageParentHeight = 150;
  static const double _imageParentWidth = 200;

  int     _getCounterDefaultValue(BuildContext context) => updateCart ? _getNbProductsInCart(context) : 1;
  int     _getNbProductsInCart(BuildContext context) => context.read<CartBloc>().state.nbProductsById(product.id);
  String  _getButtonTitle(BuildContext context, int count) {
    if (updateCart) {
      if (count == 0) return AppLocalizations.of(context)!.removeProduct;
      return AppLocalizations.of(context)!.updateCart;
    }
    return AppLocalizations.of(context)!.addToCart;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).padding.left + 16,
              right: MediaQuery.of(context).padding.right + 16,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))
            ),
            height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical) * 0.9,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: _imageParentHeight / 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded)),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/sticker.png',
                              color: Theme.of(context).primaryColor
                            ),
                            Text(
                              '-${product.reductionInPercentage.round().toString()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: BlocProvider(
                        create: (context) => CounterCubit(defaultValue: _getCounterDefaultValue(context)),
                        child: BlocBuilder<CounterCubit, int>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16.0),
                                Counter(
                                  min: updateCart ? 0 : 1, // V if updateCart is false true then we calculate how much we can still add without passing availableUnits V
                                  max: updateCart ? product.availableUnits : product.availableUnits - _getNbProductsInCart(context) 
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${(product.priceInEuros * state).toStringAsFixed(2)}€',
                                      style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      '${(product.publicPriceInEuros * state).toStringAsFixed(2)}€',
                                      style: const TextStyle(
                                        fontSize: 24.0,
                                        decoration: TextDecoration.lineThrough,
                                        color: Color.fromARGB(255, 119, 119, 119)
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (updateCart || _getNbProductsInCart(context) < product.availableUnits)
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white
                                    ),
                                    onPressed: () {
                                      if (updateCart) {
                                        context.read<CartBloc>().add(SetProductQuantityEvent(product.id, state));
                                      } else {
                                        context.read<CartBloc>().add(AddProductToCartEvent(product.id, quantity: state));
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(_getButtonTitle(context, state))
                                  )
                                else
                                  Text(
                                    AppLocalizations.of(context)!.itLooksLikeYouAlreadyHaveAllOurStockInYourCart,
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 17),
                                    textAlign: TextAlign.center,
                                  ),
                                const SizedBox(height: 16),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 15,
                                  runSpacing: 15,
                                  children: [
                                    _ProductDetailsTile(
                                      label: 'Poids :',
                                      text: '${product.grams}g',
                                    ),
                                    _ProductDetailsTile(
                                      label: 'Motif de la réduction :',
                                      text: product.reason,
                                    ),
                                    _ProductDetailsTile(
                                      label: 'À savoir :',
                                      text: product.productDetails.mustKnow,
                                    ),
                                    if (product.productDetails.nutritionalFacts != "")
                                      _ProductDetailsTile(
                                        label: 'Nutrition :',
                                        text: product.productDetails.nutritionalFacts,
                                      )
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: MediaQuery.of(context).size.width / 2 - _imageParentWidth / 2,
          child: SizedBox(
            height: _imageParentHeight,
            width: _imageParentWidth,
            child: Center(child: Image.network(product.imageUrl))
          )
        ),
      ],
    );
  }
}

class _ProductDetailsTile extends StatelessWidget {
  const _ProductDetailsTile({
    required this.label,
    required this.text,
  });

  final String label;
  final String text;

  double _getWidth(BuildContext context) => min(380, MediaQuery.of(context).size.width);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        width: _getWidth(context),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(255, 245, 245, 245)
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}