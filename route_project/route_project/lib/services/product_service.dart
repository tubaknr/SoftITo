import 'dart:convert'; // JSON Encode/Decode İşlemleri İçin dart:convert Library'sini import Eder.
import 'dart:developer' as developer; // Log Yazmak İçin dart:developer Library'sini developer Adıyla import Eder.

import 'package:http/http.dart' as http; // HTTP Request Atmak İçin http Package'ını http Adıyla import Eder.
import 'package:route_project/models/product_model.dart';
import '../services/product_service.dart';

abstract class IProductService { // Ürün Servislerinin Uyması Gereken abstract Interface'tir.
  /// Ürünleri getirir. Hata durumunda exception fırlatır.
  Future<List<ProductModel>> fetchProducts(); // Future<List<ProductModel>> Döndüren fetchProducts Metodunu Tanımlar.
}

class LiveApiProductService implements IProductService { // IProductService'i implement Edip Ürünleri Gerçek API'den Çeken Servistir.
  static const String _baseUrl = 'https://fakestoreapi.com/products'; // API'nin Base URL'idir.

  @override // Interface'teki Metodun Override Edildiğini Belirtir.
  Future<List<ProductModel>> fetchProducts() async { // Ürünleri API'den async Olarak Getirir.
    try { // Hataları Yakalamak İçin try Bloğu Açar.
      final response = await http // HTTP Response'unu await İle Bekler.
          .get(Uri.parse(_baseUrl)) // Base URL'e GET Request Atar.
          .timeout( // Request İçin Timeout Tanımlar.
            const Duration(seconds: 5), // En Fazla 5 Saniye Bekler.
            onTimeout: () => throw Exception('Network Timeout.'), // Süre Dolarsa Exception Fırlatır.
          );
      if (response.statusCode == 200) { // Status Code 200 İse Response'u İşler.
        return (json.decode(response.body) as List) // Response body'sini Decode Edip List'e Cast Eder.
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>)) // Her Elemanı fromJson İle ProductModel'e Map'ler.
            .toList(); // Sonucu List Olarak Döndürür.
      }
      throw Exception('Server Problem: ${response.statusCode}'); // Status Code 200 Değilse Exception Fırlatır.
    } catch (e) { // try İçinde Oluşan Hatayı catch Eder.
      developer.log('Network Error: $e'); // Hatayı developer.log İle Log'lar.
      rethrow; // Hatayı rethrow İle Çağıran Yere Tekrar Fırlatır.
    }
  }
}