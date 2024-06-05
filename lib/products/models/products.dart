part 'product_details.dart';

class Product {
  Product({this.rawData = const {}}) : _productDetails = ProductDetails(rawData['product_details'] ?? const {});

  // constructor used to make error checks like List<Product>.firstWhere(...., orElse: () => Product.sample())
  Product.sample() : rawData = {'id': -1, 'availableUnits': 0}, _productDetails = ProductDetails(const {});

  final Map<String, dynamic> rawData;
  final ProductDetails _productDetails;

  int get id => rawData['id'];

  int get productId => rawData['product_id'];

  int get variantID => rawData['variantID'];

  int get shopifyId => rawData['shopify_id'];

  int get shopifyProductId => rawData['shopify_product_id'];

  int get availableUnits => rawData['availableUnits'];

  int get prixRatio => rawData['prixRatio'];

  String get title => rawData['title'];

  String get sku => rawData['sku'];

  String get position => rawData['position'];

  int get grams => rawData['grams'];

  int get price => rawData['price'];

  double get priceInEuros => rawData['price'] / 100;

  String get createdAt => rawData['created_at'];

  String get updatedAt => rawData['updated_at'];

  String get barcode => rawData['barcode'];

  String get shopifyCreatedAt => rawData['shopify_created_at'];

  String get shopifyUpdatedAt => rawData['shopify_updated_at'];

  String get reason => rawData['reason'];

  String get producer => rawData['producer'];

  String get vatrate => rawData['vatrate'];

  String get origin => rawData['origin'];

  String get nature => rawData['nature'];

  String get imageUrl => rawData['image_url'];

  int? get stripeId => rawData['stripe_id'];

  int? get stripePriceId => rawData['stripe_price_id'];

  ProductDetails get productDetails => _productDetails;

  bool get fragile => rawData['fragile'];

  int get netWeight => rawData['net_weight'];

  int get grossWeight => rawData['gross_weight'];

  int get publicPrice => rawData['public_price'];

  double get publicPriceInEuros => rawData['public_price'] / 100;

  int get ean_13 => rawData['ean_13'];

  int? get unit => rawData['unit'];

  int? get weight => rawData['weight'];

  int? get legalNotice => rawData['legal_notice'];

  int get volume => rawData['volume'];

  int? get originState => rawData['origin_state'];

  double get reductionInPercentage => (1 - (price / publicPrice)) * 100;

}