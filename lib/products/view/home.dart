import 'package:benebono_technical_ex/cart/bloc/cart_bloc.dart';
import 'package:benebono_technical_ex/products/bloc/products_bloc.dart';
import 'package:benebono_technical_ex/products/models/products.dart';
import 'package:benebono_technical_ex/products/view/products_loading.dart';
import 'package:benebono_technical_ex/products/widgets/cart_floating_button.dart';
import 'package:benebono_technical_ex/products/widgets/product.dart';
import 'package:benebono_technical_ex/scaffold_components/widgets/drawer.dart';
import 'package:benebono_technical_ex/scaffold_components/widgets/dynamic_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


/*
  This is the view of the products and also the home page.
  This widget is Stateful to prevent it from being rebuilt when the locale is changed, which would otherwise close the EndDrawer.
*/

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductsBloc()..add(const ProductsLoadEvent())), // <-- event added here to load products when init widget.
        BlocProvider(create: (context) => CartBloc()..add(const CartInitEvent())),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            key: _scaffoldKey,
            endDrawer: const AppDrawer(),
            floatingActionButton: const CartFloatingButton(),
            body: DynamicAppBarView(
              title: AppLocalizations.of(context)!.ourProducts,
              scaffoldKey: _scaffoldKey,
              child: BlocBuilder<ProductsBloc, ProductsState>(
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
                              Text(AppLocalizations.of(context)!.anErrorOccurredWhileRetrievingTheProducts),
                              const SizedBox(height: 15),
                              Text(state.exception.toString()),
                            ]
                          ),
                        ),
                      ),
                    );
                  }
                  return const ProductsLoadingList();
                },
              ),
            ),
          );
        }
      ),
    );
  }
}

/*
  List view of the products
*/
class _ProductsList extends StatelessWidget {
  const _ProductsList();

  List<Product> getProducts(BuildContext context) => context.read<ProductsBloc>().state.products;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 16 + DynamicAppBarView.appBarHeight,
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
    );
  }
}
