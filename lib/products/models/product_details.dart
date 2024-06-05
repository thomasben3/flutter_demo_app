part of 'products.dart';

class ProductDetails {
  ProductDetails(this.rawData);

  final Map<String, dynamic> rawData;

  String get ddm => rawData['ddm'];

  int get tva => rawData['tva'];

  List<String> get tags => rawData['tags'];
  
  List<String> get flags => rawData['flags'];
  
  String get recipe => rawData['recipe'];
  
  String get review => rawData['review'];
  
  String get caliber => rawData['caliber'];
  
  String get variety => rawData['variety'];
  
  String get ecoScore => rawData['ecoScore'];
  
  List get mentions => rawData['mentions'];
  
  String get mustKnow => rawData['mustKnow'];
  
  String get fabricant => rawData['fabricant'];
  
  List get internals => rawData['internals'];
  
  String get longReason => rawData['longReason'];
  
  String get grossWeight => rawData['grossWeight'];
  
  String get ingredients => rawData['ingredients'];
  
  String get pricePerUnit => rawData['pricePerUnit'];
  
  String get nutritionalFacts => rawData['nutritionalFacts'];
  
  String get nutritionalScore => rawData['nutritionalScore'];
  
}