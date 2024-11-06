from flask import Flask, request, jsonify
from newspaper import Article
from flask_cors import CORS
import os
import nltk
nltk.download('punkt', download_dir='/opt/render/project/src/.venv/nltk_data')




app = Flask(__name__)

# CORS - Autoriser toutes les origines pendant le développement, ou préciser les origines pour la prod
CORS(app, resources={r"/resumer": {"origins": "https://summarize-article-64a2e.web.app"}})  # Pour le développement, "*" autorise toutes les origines.

@app.route('/resumer', methods=['POST'])
def resumer():
    data = request.get_json()
    url = data.get('url')

    # Télécharger et analyser l'article
    article = Article(url)
    article.download()
    article.parse()
    article.nlp()

    response = {
        "title": article.title,
        "author": article.authors,
        "publication_date": article.publish_date.strftime('%Y-%m-%d') if article.publish_date else "N/A",
        "summary": article.summary
    }

    return jsonify(response)

if __name__ == '__main__':
    # Utilisation du port dynamique de Render
    port = int(os.environ.get('PORT', 5000))  # Si la variable d'environnement PORT n'est pas définie, utilise 5000
    app.run(host='0.0.0.0', port=port, debug=True)

