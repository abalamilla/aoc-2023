max_score("blue", 14).
max_score("green", 13).
max_score("red", 12).

color("blue").
color("green").
color("red").

id(N) :- between(1, 100, N).

score([Score, Color]) :-
    color(Color),
    max_score(Color, Max),
    between(0, Max, Score).

valid_subset([]).
valid_subset([Set|Rest]) :-
    score(Set),
    valid_subset(Rest).

valid_set([]).
valid_set([Subset|Rest]) :-
    valid_subset(Subset),
    valid_set(Rest).

game(Id, Sets) :-
    id(Id),
    valid_set(Sets).

my_split_string(Sep, String, Substrings) :-
    split_string(String, Sep, " ", Substrings).

split_set([], []).
split_set(Set, Output) :-
    split_string(Set, " ", "", [ScoreStr, Color]),
    atom_number(ScoreStr, Score),
    Output = [Score, Color].

parse_line("", _, []).
parse_line(Line, Id, Sets) :-
    split_string(Line, ":", "", [GameId, Rest]),
    split_string(GameId, " ", "", [_, IdStr]),
    atom_number(IdStr, Id),
    split_string(Rest, ";", "", Substrings),
    maplist(my_split_string(","), Substrings, ColorSets),
    maplist(maplist(split_set), ColorSets, Sets).

sum_valid_games([], 0).
sum_valid_games([Line|Rest], Sum) :-
    parse_line(Line, Id, Sets),
    game(Id, Sets),
    sum_valid_games(Rest, RestSum),
    Sum is RestSum + Id.
sum_valid_games([Line|Rest], Sum) :-
    parse_line(Line, Id, Sets),
    \+ game(Id, Sets),
    sum_valid_games(Rest, Sum).

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
    %sum_valid_games_v2(Input, SumV2),
	write(Sum), nl.
    %write(SumV2), nl.

