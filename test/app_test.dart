import 'package:benebono_technical_ex/cart/models/cart_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'cart/cart_bloc_test.dart';
import 'counter/counter_cubit_test.dart';
import 'products/products_bloc_test.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();

    // Set the database factory to ffi factory.
    databaseFactory = databaseFactoryFfi;
  });

  tearDownAll(() {
    initDatabase().then((database) => database.close());
  });

  counterCubitTests();
  productsBlocTests();
  cartBlocTests();
}