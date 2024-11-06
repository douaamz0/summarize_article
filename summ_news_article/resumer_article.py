import nltk
from newspaper import Article

# Télécharger une fois le modèle 'punkt'
nltk.download('punkt', quiet=True)


def resumer_article(url):
    article = Article(url)
    article.download()
    article.parse()
    article.nlp()

    # Retourne les informations sous forme de dictionnaire
    return {
        'title': article.title,
        'authors': article.authors,
        'publish_date': article.publish_date,
        'summary': article.summary
    }



