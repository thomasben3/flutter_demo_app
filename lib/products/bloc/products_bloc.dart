import 'package:benebono_technical_ex/cart/models/cart_product.dart';
import 'package:benebono_technical_ex/products/models/products.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(const ProductsInitialState()) {
    on<ProductsLoadEvent>((event, emit) async {
      final dynamic products = await _fetchProduct();
      if (products is List<Product>) {
        emit(ProductsLoadedState(products: products));
      } else if (products is Exception) {
        emit(ProductsErrorState(products));
      }
    });
  }

  Future<dynamic> _fetchProduct() async {
    final Dio dio = Dio();

    try {
      final res = await dio.get("https://static.horsnormes.co/mobile-practical-test/products.json");

      return List<Map<String, dynamic>>.from(res.data['data']).map((e) => Product(rawData: e)).toList();
    } on DioException catch (e) {
      return e;
    } catch (e) {
      return e;
    }
  }
}
