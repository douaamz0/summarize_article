import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  Future<Map<String, dynamic>> getSummary(String url) async {
    try {
      // Créez une requête POST vers l'API
      final response = await http.post(
        Uri.parse('https://summarize-article.onrender.com/resumer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      );

      // Vérifier le statut de la réponse
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Gérer le cas où la réponse a un statut d'erreur
        throw Exception(
            "Erreur lors de la récupération du résumé: ${response.statusCode}");
      }
    } catch (e) {
      // Gérer toutes les erreurs de la requête ou d'autres exceptions
      throw Exception("Une erreur s'est produite: $e");
    }
  }
}
