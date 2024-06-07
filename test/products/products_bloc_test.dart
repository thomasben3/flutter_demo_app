import 'package:benebono_technical_ex/products/bloc/products_bloc.dart';
import 'package:benebono_technical_ex/products/models/products.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Dio])
import 'products_bloc_test.mocks.dart';

void main() {
  group('products_bloc', () {
    late ProductsBloc productsBloc;

    setUp(() => productsBloc = ProductsBloc());

    tearDown(() => productsBloc.close());

    test('initial state is ProductsInitialState', () {
      expect(productsBloc.state, const ProductsInitialState());
    });

    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsLoaded] when ProductsLoadEvent is added.',
      build: () {
        productsBloc.close();
        final MockDio mockDio = MockDio();
        productsBloc = ProductsBloc(dio: mockDio);

        when(mockDio.get(ProductsBloc.productsUrl)).thenAnswer((_) async {
          return Response(
            data: {'data': [const Product.sample().rawData]},
            statusCode: 200,
            requestOptions: RequestOptions(path: ProductsBloc.productsUrl),
          ) as dynamic;
        });
        return productsBloc;
      },
      act: (bloc) => bloc.add(const ProductsLoadEvent()),
      wait: const Duration(milliseconds: 50),
      expect: () => [
        const ProductsLoadedState(products: [Product.sample()])
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsErrorState] when ProductsLoadEvent is added and fetching products fails.',
      build: () {
        productsBloc.close();
        final MockDio mockDio = MockDio();
        productsBloc = ProductsBloc(dio: mockDio);

        when(mockDio.get(ProductsBloc.productsUrl)).thenThrow(Exception('test'));
        return productsBloc;
      },
      act: (bloc) => bloc.add(const ProductsLoadEvent()),
      wait: const Duration(milliseconds: 50),
      expect: () => <ProductsState>[
        ProductsErrorState(Exception('test')),
      ],
    );
    
  });
}