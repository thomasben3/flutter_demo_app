import 'package:benebono_technical_ex/cart/models/cart_product.dart';
import 'package:benebono_technical_ex/products/models/products.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {

  static const String productsUrl = "https://static.horsnormes.co/mobile-practical-test/products.json";  

  // this Dio is a variable to make the class testable with Mock.
  final Dio _dio;

  ProductsBloc({Dio? dio}) : _dio = dio ?? Dio(), super(const ProductsInitialState()) {

    /*
      This event try to fetch products. Then if succeed change state to ProductsLoadedState with these products.
      In case of failure change state to ProductsErrorState to display the error
    */
    on<ProductsLoadEvent>((event, emit) async {
      final dynamic products = await fetchProduct();
      if (products is List<Product>) {
        emit(ProductsLoadedState(products: products));
      } else if (products is Exception) {
        emit(ProductsErrorState(products));
      }
    });
  }

  // try to fetch product from API, returns its if succeed, return exception if failed.
  Future<dynamic> fetchProduct() async {
    try {
      final res = await _dio.get(productsUrl);

      return List<Map<String, dynamic>>.from(res.data['data']).map((e) => Product(rawData: e)).toList();
    } on DioException catch (e) {
      return e;
    } catch (e) {
      return e;
    }
  }

  int getTotalPrice(List<CartProduct> cartProducts) {
    int count = 0;
    
    for (CartProduct cartProduct in cartProducts) {
      final Product product = state.products.firstWhere((p) => p.id == cartProduct.id, orElse: () => Product.sample());
      if (product.id == -1) continue;

      count += product.price * cartProduct.quantity;
    }

    return count;
  }

  int getTotalPublicPrice(List<CartProduct> cartProducts) {
    int count = 0;
    
    for (CartProduct cartProduct in cartProducts) {
      final Product product = state.products.firstWhere((p) => p.id == cartProduct.id, orElse: () => Product.sample());
      if (product.id == -1) continue;

      count += product.publicPrice * cartProduct.quantity;
    }

    return count;
  }

  // Returns the difference between totalPublicPrice and totalPrice in euros.
  double getTotalSaves(List<CartProduct> cartProducts) {
    final int totalPrice = getTotalPrice(cartProducts);
    final int totalPublicPrice = getTotalPublicPrice(cartProducts);

    return (totalPublicPrice - totalPrice) / 100;
  }

  // Returns the difference between totalPublicPrice and totalPrice in percentage.
  double getTotalSavesInPercentage(List<CartProduct> cartProducts) {
    final int totalPrice = getTotalPrice(cartProducts);
    final int totalPublicPrice = getTotalPublicPrice(cartProducts);

    if (totalPublicPrice == 0) return 0;

    return (1 - (totalPrice / totalPublicPrice)) * 100;
  }
}
