import 'package:benebono_technical_ex/cart/bloc/cart_bloc.dart';
import 'package:benebono_technical_ex/products/bloc/products_bloc.dart';
import 'package:benebono_technical_ex/products/cubit/bool_cubit.dart';
import 'package:benebono_technical_ex/products/models/products.dart';
import 'package:benebono_technical_ex/products/widgets/cart_floating_button.dart';
import 'package:benebono_technical_ex/products/widgets/product.dart';
import 'package:benebono_technical_ex/scaffold_components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// this widget is stateful in order to keep endDrawer open even if locale change (and so app rebuild)
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const double appBarHeight = 50;

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
        BlocProvider(create: (context) => BoolCubit()),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            key: _scaffoldKey,
            endDrawer: const AppDrawer(),
            floatingActionButton: const CartFloatingButton(),
            body: Container(
              color: Colors.white,
              child: SafeArea(
                left: false,
                right: false,
                bottom: false,
                child: Material(
                  child: Stack(
                    children: [
                      Positioned.fill(
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
                            return const Center(child: Text('ca charge'));
                          },
                        ),
                      ),
                      // this is the dyamic appBar based on BoolCubit value.
                      AnimatedPositioned(
                        top: context.watch<BoolCubit>().state ? 0 : -HomeView.appBarHeight,
                        left: 0,
                        right: 0,
                        height: HomeView.appBarHeight,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                        child: Container(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).padding.left,
                            right: MediaQuery.of(context).padding.right
                          ),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 50),
                              Text(AppLocalizations.of(context)!.myCart, style: const TextStyle(fontSize: 24)),
                              SizedBox(
                                width: 50,
                                child: IconButton(
                                  onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                                  icon: const Icon(Icons.menu)
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
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
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          final metrics = notification.metrics;
          final scrollDelta = notification.scrollDelta ?? 0;
                                                                                                        // CHECKS IN THIS IF :
          if (scrollDelta.abs() > 10 &&                                                                 // user has scroll more than 10 pixel
            (metrics.pixels > metrics.minScrollExtent && metrics.pixels < metrics.maxScrollExtent) &&   // AND (scrollView is not < min OR > max) (this prevent from 'bounceEffect' unwanted notifications)
              ((context.read<BoolCubit>().state && scrollDelta > 0) ||                                  // AND user is scrolling in a way that need to trigers .invert()
              (!context.read<BoolCubit>().state && scrollDelta < 0))) {
            context.read<BoolCubit>().invert();
          }
        }

        return false ;
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 16 + HomeView.appBarHeight,
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
