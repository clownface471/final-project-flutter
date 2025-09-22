import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dessert.dart';

class ApiService {
  // URL endpoint untuk kategori Dessert dari TheMealDB
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert';

  // Fungsi untuk mengambil daftar dessert
  Future<List<Dessert>> fetchDesserts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // Jika server merespon OK, parse JSON
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> meals = jsonResponse['meals'];
        
        // Ubah setiap item JSON menjadi objek Dessert
        return meals.map((json) => Dessert.fromJson(json)).toList();
      } else {
        // Jika server tidak merespon OK, lempar exception
        throw Exception('Failed to load desserts from API');
      }
    } catch (e) {
      // Menangani error koneksi atau lainnya
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
