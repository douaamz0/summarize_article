import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  Future<Map<String, dynamic>> getSummary(String url) async {
    final response = await http.post(
      Uri.parse('https://summarize-article.onrender.com/resumer'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': url}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors de la récupération du résumé");
    }
  }
}
