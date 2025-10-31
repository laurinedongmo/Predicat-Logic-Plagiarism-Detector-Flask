:- use_module(library(http/json)).

% Prédicat principal modifié
similarite_phrases(Arbre1JSON, Arbre2JSON, Score) :-
    % 1. Conversion des chaînes JSON en termes Prolog
    catch(atom_json_term(Arbre1JSON, Term1, []), Error1, (writef('Erreur de parsing JSON (Arbre 1): %t\n', [Error1]), fail)),
    catch(atom_json_term(Arbre2JSON, Term2, []), Error2, (writef('Erreur de parsing JSON (Arbre 2): %t\n', [Error2]), fail)),

    % 2. Extraction des caractéristiques
    extract_features(Term1, Pos1, Dep1),
    extract_features(Term2, Pos2, Dep2),

    % 3. Calcul des similarités
    list_similarity(Pos1, Pos2, PosScore),
    list_similarity(Dep1, Dep2, DepScore),

    % 4. Combinaison pondérée
    Score is (0.6 * PosScore + 0.4 * DepScore).

% Nouvelle extraction des features
extract_features(Tree, PosList, DepList) :-
    is_list(Tree),
    maplist(get_pos_from_json_term, Tree, PosList),
    maplist(get_dep_from_json_term, Tree, DepList).
extract_features(Tree, [], []) :- \+ is_list(Tree), writef('Warning: L''arbre n''est pas une liste: %t\n', [Tree]).

% Extraction POS tag à partir du terme json(...)
get_pos_from_json_term(json(ListOfPairs), Pos) :-
    member(=(pos, PosValue), ListOfPairs),
    atom_string(PosValue, Pos).
get_pos_from_json_term(_, ''). % Si la structure n'est pas celle attendue

% Extraction dépendance à partir du terme json(...)
get_dep_from_json_term(json(ListOfPairs), Dep) :-
    member(=(dep, DepValue), ListOfPairs),
    atom_string(DepValue, Dep).
get_dep_from_json_term(_, ''). % Si la structure n'est pas celle attendue

% Similarité entre listes (inchangé)
list_similarity(A, B, Score) :-
    length(A, LenA),
    length(B, LenB),
    (   LenA =:= 0 -> Score = 0
    ;   LenB =:= 0 -> Score = 0
    ;   intersection(A, B, Common),
        length(Common, N),
        Score is (N / max(LenA, LenB)) * 100
    ).

intersection([], _, []).
intersection([X|Xs], Y, [X|Zs]) :- member(X, Y), intersection(Xs, Y, Zs).
intersection([X|Xs], Y, Zs) :- \+ member(X, Y), intersection(Xs, Y, Zs).