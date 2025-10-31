import spacy

nlp = spacy.load("fr_core_news_sm")

def texte_vers_arbre(texte):
    doc = nlp(texte)
    return [
        {
            "pos": token.pos_,
            "dep": token.dep_,
            "head": token.head.text
        }
        for token in doc
    ]