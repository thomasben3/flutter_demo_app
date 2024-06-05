import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:benebono_technical_ex/cart/bloc/cart_bloc.dart';
import 'package:benebono_technical_ex/cart/widgets/cart_product.dart';
import 'package:benebono_technical_ex/products/bloc/products_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  // getProductsState is for the ProductBloc and here to access CartBloc we use state inside
  // the BlocBuilder.
  ProductsState getProductsState(BuildContext context) => context.watch<ProductsBloc>().state;

  String _getTotalPrice(BuildContext context, CartState state) =>
    (getProductsState(context).getTotalPrice(state.products) / 100).toStringAsFixed(2);

  String _getTotalSaves(BuildContext context, CartState state) {
    final int totalPrice = getProductsState(context).getTotalPrice(state.products);
    final int totalPublicPrice = getProductsState(context).getTotalPublicPrice(state.products);

    return ((totalPublicPrice - totalPrice) / 100).toStringAsFixed(2);
  }

  double _getTotalSavesInPercentage(BuildContext context, CartState state) {
    final int totalPrice = getProductsState(context).getTotalPrice(state.products);
    final int totalPublicPrice = getProductsState(context).getTotalPublicPrice(state.products);

    if (totalPublicPrice == 0) return 0;

    return (1 - (totalPrice / totalPublicPrice)) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductsBloc()..add(const ProductsLoadEvent())),
        BlocProvider(create: (context) => CartBloc()..add(const CartInitEvent())),
      ],
      child: BlocBuilder<CartBloc, CartState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is CartLoadedState) {
            return Scaffold(
              body: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).padding.left,
                      right: MediaQuery.of(context).padding.right,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 50, child: BackButton()),
                        Text(AppLocalizations.of(context)!.myCart, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 50)
                      ],
                    ),
                  ),
                  Expanded(
                    child: state.products.isNotEmpty && getProductsState(context).products.isNotEmpty ? Stack(
                      children: [
                        SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 100),
                          child: Column(
                            children: [
                              ...List.generate(state.products.length, (index) => Column(
                                children: [
                                  if (index != 0)
                                    const Divider(color: Colors.grey, thickness: 0.2),
                                  CartProductWidget(
                                    cartProduct: state.products[index],
                                    product: getProductsState(context).products.firstWhere((p) => p.id == state.products[index].id)
                                  ),
                                ],
                              )),
                              const Divider(color: Color.fromARGB(255, 89, 89, 89), thickness: 0.5, indent: 40, endIndent: 40),
                              Text('Total : ${_getTotalPrice(context, state)}€'),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 60,
                                    child: AnimatedTextKit(
                                      pause: Duration.zero,
                                      animatedTexts: [
                                        RotateAnimatedText(
                                          '${_getTotalSaves(context, state)}€',
                                          duration: const Duration(seconds: 3),
                                          alignment: Alignment.centerRight,
                                          textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                        ),
                                        RotateAnimatedText(
                                          '${_getTotalSavesInPercentage(context, state).round().toString()}%',
                                          duration: const Duration(seconds: 3),
                                          alignment: Alignment.centerRight,
                                          textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                        ),
                                      ],
                                      repeatForever: true
                                    ),
                                  ),
                                  Text('  ${AppLocalizations.of(context)!.saved} !    ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ]
                          ),
                        ),
                        Positioned(
                          width: 200,
                          height: 45,
                          bottom: MediaQuery.of(context).padding.bottom + 20,
                          left: MediaQuery.of(context).size.width / 2 - 200 / 2,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                            ),
                            onPressed: () {},
                            child: FittedBox(child: Text(AppLocalizations.of(context)!.proceedToCheckout, style: const TextStyle(fontWeight: FontWeight.bold))),
                          )
                        )
                      ],
                    ) : Center(child: Text(AppLocalizations.of(context)!.yourCartIsEmpty)),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
