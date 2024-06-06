import 'package:benebono_technical_ex/cart/models/cart_product.dart';
import 'package:sqflite/sqflite.dart';

// This function init the database and tables if needed then return an instance of Database.
Future<Database> initDatabase() async {
  return await openDatabase(
    'app_db',
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''CREATE TABLE IF NOT EXISTS cart_items (
        _id       INTEGER PRIMARY KEY,
        id        INTEGER NOT NULL,
        quantity  INTEGER NOT NULL
      )''');
    },
  );
}

abstract class CartService {

  /*
    Insert a new product inside the cart_items table.
    You must be sure that this productId isn't already present in the table if you want to avoid duplication
  */
  static Future<void> addProduct(int productId, {int quantity = 1}) async {
    final Database db = await initDatabase();

    await db.insert(
      'cart_items',
      {
        'id': productId,
        'quantity': quantity
      }
    );
  }

  /*
    Update quantity of a product inside the cart_items table.
    This function manage all cases. If update to quantity = 0 then delete the item,
    If items is new then insert a new row into the table. Else it adjusts quantity of existing item.
  */
  static Future<void> updateProductQuantity(int productId, int newQuantity) async {
    final Database db = await initDatabase();

    if (newQuantity == 0) {
      await db.delete(
        'cart_items',
        where: 'id = ?',
        whereArgs: [productId]
      );
    } else {
      if (await db.update(
        'cart_items',
        {
          'quantity': newQuantity
        },
        where: 'id = ?',
        whereArgs: [productId]
      ) == 0) {
        await addProduct(productId, quantity: newQuantity);
      }
    }
  }

  /*
    Return all products in the cart
  */
  static Future<List<CartProduct>> getProducts() async {
    final Database db = await initDatabase();

    final List<Map<String, dynamic>> rawRes = await db.query(
      'cart_items',
      columns: ['id', 'quantity']
    );

    return List.generate(
      rawRes.length,
      (index) => CartProduct(
        id: rawRes[index]['id'],
        quantity: rawRes[index]['quantity']
      )
    );
  }
} 