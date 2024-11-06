import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SummaryApp extends StatefulWidget {
  @override
  _SummaryAppState createState() => _SummaryAppState();
}

class _SummaryAppState extends State<SummaryApp> {
  final TextEditingController urlController = TextEditingController();
  String? title;
  String? author;
  String? publicationDate;
  String? summary;
  bool isLoading = false;
  String errorMessage = '';
  final APIService apiService = APIService();

  Future<void> getSummary() async {
    setState(() {
      isLoading = true;
      title = null;
      author = null;
      publicationDate = null;
      summary = null;
      errorMessage = '';
    });

    try {
      final data = await apiService.getSummary(urlController.text);
      setState(() {
        title = data['title'] ?? 'Titre non disponible';
        author = (data['author'] as List).join(', ') ?? 'Auteur non disponible';
        publicationDate =
            data['publication_date'] ?? 'Date de publication non disponible';
        summary = data['summary'] ?? 'Résumé non disponible';
      });
    } catch (error) {
      setState(() {
        errorMessage = "Une erreur est survenue : $error";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Résumé d'articles",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24, // Augmentation de la taille de la police
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.pink,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 24), // Espace entre l'AppBar et le champ de texte
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: "Entrez l'URL de l'article",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24), // Espace entre le champ et le bouton
            ElevatedButton(
              onPressed: isLoading ? null : getSummary,
              child: Text("Obtenir le résumé"),
            ),
            SizedBox(height: 24), // Espace entre le bouton et le contenu
            if (isLoading) Center(child: CircularProgressIndicator()),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            if (title != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Titre : $title",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          18, // Augmentation de la taille de la police du titre
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("Auteur(s) : $author"),
                  SizedBox(height: 8),
                  Text("Date de publication : $publicationDate"),
                  SizedBox(height: 16),
                  Text(
                    "Résumé : ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(summary!, style: TextStyle(fontSize: 16)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
