:- use_module(library(http/json)).
:- use_module(library(lists)).
:- use_module(library(assoc)).

% Prédicat principal
similarite_cosinus(Arbre1JSON, Arbre2JSON, Score) :-
    % Conversion JSON
    atom_json_term(Arbre1JSON, Term1, []),
    atom_json_term(Arbre2JSON, Term2, []),
    
    % Extraction des features
    extract_features(Term1, Features1),
    extract_features(Term2, Features2),
    
    % Création des vecteurs
    union_features(Features1, Features2, AllFeatures),
    create_vector(Features1, AllFeatures, Vector1),
    create_vector(Features2, AllFeatures, Vector2),
    
    % Calcul de similarité
    cosine_similarity(Vector1, Vector2, Score).

% Extraction des features (POS-DEP)
extract_features(Tree, Features) :-
    is_list(Tree),
    findall(Feature, (
        member(Node, Tree),
        get_feature(Node, pos, Pos),
        get_feature(Node, dep, Dep),
        atomic_list_concat([Pos, '-', Dep], Feature)
    ), Features).
extract_features(_, []).

% Helper pour extraction
get_feature(json(Pairs), Key, Value) :-
    member(=(Key, Val), Pairs),
    atom_string(Val, Value).

% Union des features
union_features(Features1, Features2, AllFeatures) :-
    append(Features1, Features2, All),
    list_to_set(All, AllFeatures).

% Création vecteur
create_vector(Features, AllFeatures, Vector) :-
    empty_assoc(Assoc0),
    count_features(Features, Assoc0, Assoc),
    maplist(get_feature_count(Assoc), AllFeatures, Vector).

count_features([], Assoc, Assoc).
count_features([F|Fs], Assoc0, Assoc) :-
    (get_assoc(F, Assoc0, Count) ->
        NewCount is Count + 1,
        put_assoc(F, Assoc0, NewCount, Assoc1)
    ;
        put_assoc(F, Assoc0, 1, Assoc1)),
    count_features(Fs, Assoc1, Assoc).

get_feature_count(Assoc, Feature, Count) :-
    (get_assoc(Feature, Assoc, C) -> Count = C ; Count = 0).

% Calcul similarité cosinus
cosine_similarity(V1, V2, Similarity) :-
    dot_product(V1, V2, Dot),
    norm(V1, Norm1),
    norm(V2, Norm2),
    (Norm1 * Norm2 =:= 0 -> Similarity = 0 ; Similarity is Dot / (Norm1 * Norm2)).

% Produit scalaire
dot_product([], [], 0).
dot_product([X|Xs], [Y|Ys], Dot) :-
    dot_product(Xs, Ys, Rest),
    Dot is X * Y + Rest.

% Norme vectorielle (remplace magnitude)
norm(V, Norm) :-
    maplist(square, V, Squares),
    sumlist(Squares, Sum),
    Norm is sqrt(Sum).

square(X, X2) :- X2 is X * X.