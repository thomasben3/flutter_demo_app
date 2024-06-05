import 'package:benebono_technical_ex/counter/bloc/counter_bloc.dart';
import 'package:benebono_technical_ex/counter/view/counter.dart';
import 'package:benebono_technical_ex/products/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({
    super.key,
    required this.product,
    required this.addProducts
  });

  final Product             product;
  final void Function(int)  addProducts;

  static const double _imageParentHeight = 150;
  static const double _imageParentWidth = 200;

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
                        create: (context) => CounterBloc(1),
                        child: BlocBuilder<CounterBloc, CounterState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16.0),
                                const Counter(min: 1),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${(product.priceInEuros * state.count).toStringAsFixed(2)}€',
                                      style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      '${(product.publicPriceInEuros * state.count).toStringAsFixed(2)}€',
                                      style: const TextStyle(
                                        fontSize: 24.0,
                                        decoration: TextDecoration.lineThrough,
                                        color: Color.fromARGB(255, 119, 119, 119)
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white
                                  ),
                                  child: Text(AppLocalizations.of(context)!.addToCart),
                                  onPressed: () {
                                    addProducts(state.count);
                                    Navigator.of(context).pop();
                                  }
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  product.productDetails.longReason,
                                  style: const TextStyle(fontSize: 16.0),
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
