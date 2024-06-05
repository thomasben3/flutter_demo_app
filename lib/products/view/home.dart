import 'package:benebono_technical_ex/cart/bloc/cart_bloc.dart';
import 'package:benebono_technical_ex/products/bloc/products_bloc.dart';
import 'package:benebono_technical_ex/products/models/products.dart';
import 'package:benebono_technical_ex/products/widgets/cart_floating_button.dart';
import 'package:benebono_technical_ex/products/widgets/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductsBloc()..add(const ProductsLoadEvent())), // <-- event added here to load products when init widget.
        BlocProvider(create: (context) => CartBloc()..add(const CartInitEvent())),
      ],
      child: Scaffold(
        floatingActionButton: const CartFloatingButton(),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state is ProductsLoadedState) {
              return const _ProductsList();
            } else if (state is ProductsErrorState) {
              return SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('Une erreur est survenue lors de la récupération des produits :'),
                        const SizedBox(height: 15),
                        Text(state.exception.toString()),
                      ]
                    ),
                  ),
                ),
              );
            }
            return const Center(child: Text('ca charge'));
          },
        ),
      ),
    );
  }
}

// List view of the products
class _ProductsList extends StatelessWidget {
  const _ProductsList();

  List<Product> getProducts(BuildContext context) => context.read<ProductsBloc>().state.products;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          bottom: MediaQuery.of(context).padding.bottom + 16
        ),
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 15,
            runSpacing: 15,
            children: List.generate(getProducts(context).length, (index) {
              final Product product = getProducts(context)[index];
          
              return ProductWidget(product);
            }),
          ),
        ),
      ),
    );
  }
}
