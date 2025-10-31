from flask import Flask, request, render_template
from Prolog.nlp_unit import texte_vers_arbre
import subprocess
import json
import re
import os

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html", result=None, error=None)

@app.route("/compare", methods=["POST"])
def compare():
    try:
        texte1 = request.form["texte1"]
        texte2 = request.form["texte2"]

        arbre1 = texte_vers_arbre(texte1)
        arbre2 = texte_vers_arbre(texte2)

        # Préparation des données pour Prolog
        arbre1_pl = json.dumps(arbre1)
        arbre2_pl = json.dumps(arbre2)

        # Échappement des guillemets et construction du chemin absolu
        arbre1_pl_escaped = arbre1_pl.replace('"', '\\"')
        arbre2_pl_escaped = arbre2_pl.replace('"', '\\"')
        prolog_script_path = os.path.abspath("Prolog/compare_cosinus.pl")

        cmd = [
            "swipl",
            "-q",
            "-s", prolog_script_path,
            "-g", f"similarite_cosinus('{arbre1_pl_escaped}', '{arbre2_pl_escaped}', Score), format('~2f', [Score])",
            "-t", "halt"
        ]

        result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)

        if result.returncode != 0:
            raise Exception(
                f"Erreur Prolog:\nCommande: {' '.join(cmd)}\nSortie d'erreur: {result.stderr}"
            )

        # Extraction numérique du résultat
        score = re.findall(r"\d+\.\d+", result.stdout)
        if not score:
            raise Exception("Format de score invalide")

        return render_template("index.html", result=float(score[0])*100, error=None,text1=texte1,text2=texte2)

    except Exception as e:
        app.logger.error(f"Erreur: {str(e)}")
        return render_template("index.html", result=None, error=str(e),text1=texte1,text2=texte2)

if __name__ == "__main__":
    app.run(debug=True)