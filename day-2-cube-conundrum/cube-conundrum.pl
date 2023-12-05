score("blue", 14).
score("red", 12).
score("green", 13).

validate_score(Color, Score) :-
    score(Color, Max),
    Score =< Max.

validate_scores([]).
validate_scores([Score|Rest]) :-
    split_string(Score, " ", " ", [ScoreValue, Color]),
    atom_number(ScoreValue, ScoreNumber),
    validate_score(Color, ScoreNumber),
    validate_scores(Rest).

validate_subgames([]) :- !.
validate_subgames([Subgame|Rest]) :-
    split_string(Subgame, ",", "", Scores),
    validate_scores(Scores),
    validate_subgames(Rest).

validate_game(Game, Id) :-
    re_matchsub("Game (?<id>\\d+): (?<games>.*)", Game, Matches, []),
    split_string(Matches.games, ";", "", Subgames),
    validate_subgames(Subgames),
    atom_number(Matches.id, Id).

sum_valid_games(Input, Sum) :-
    sum_valid_games(Input, 0, Sum).

sum_valid_games([], Sum, Sum).
sum_valid_games([Game|Rest], Accum, Sum) :-
    validate_game(Game, Id),
    NewAccum is Accum + Id,
    sum_valid_games(Rest, NewAccum, Sum).
sum_valid_games([Game|Rest], Accum, Sum) :-
    \+ validate_game(Game, _),
    sum_valid_games(Rest, Accum, Sum).
    

%! test.

read_lines(Stream, [Line|Lines]) :-
    read_line_to_string(Stream, Line),
    Line \= end_of_file,
    read_lines(Stream, Lines).
read_lines(_, []).

load_file(Filename, Lines) :-
    open(Filename, read, Stream),
    read_lines(Stream, Lines),
    close(Stream).

main :-
	load_file("input.txt", Input),
	sum_valid_games(Input, Sum),
	write(Sum), nl.
