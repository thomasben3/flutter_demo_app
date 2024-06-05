import 'package:benebono_technical_ex/cart/bloc/cart_bloc.dart';
import 'package:benebono_technical_ex/cart/view/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartFloatingButton extends StatelessWidget {
  const CartFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 5),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                shape: const CircleBorder(),
                onPressed: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartView())).then((value) =>
                    context.read<CartBloc>().add(const CartInitEvent())
                  ),
                child: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
              ),
            ),
            if (state.nbProducts > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 25,
                  width: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  child: FittedBox(
                    child: Text(state.nbProducts.toString())
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
