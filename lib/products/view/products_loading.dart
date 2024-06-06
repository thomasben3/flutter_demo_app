import 'dart:math';
import 'package:benebono_technical_ex/products/widgets/product.dart';
import 'package:benebono_technical_ex/scaffold_components/widgets/dynamic_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/*
  This is the loading list of products.
  This widget is used to display list of fake products with Shimmer effect on it.
*/
class ProductsLoadingList extends StatelessWidget {
  const ProductsLoadingList({super.key});


  @override
  Widget build(BuildContext context) {
    int getListLength() => min(5, MediaQuery.of(context).size.height / ProductWidget.productHeight).floor();

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
          children: List.generate(getListLength(), (index) => const _ProductLoading())
        ),
      ),
    );
  }
}

/*
  This is the shimmer loading product.
  It is based on the ProductWidget properties.
*/
class _ProductLoading extends StatelessWidget {
  const _ProductLoading();

  @override
  Widget build(BuildContext context) {
    return Animate(
      autoPlay: true,
      onComplete: (controller) => controller.repeat(),
      effects: const [ShimmerEffect(duration: Duration(seconds: 1))],
      child: Container(
        height: ProductWidget.productHeight,
        width: ProductWidget.getProductWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ProductWidget.productBorderRadius),
          color: ProductWidget.backgroundColor
        ),
      ),
    );
  }
}