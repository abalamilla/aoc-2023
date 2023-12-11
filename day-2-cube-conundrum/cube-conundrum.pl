max_score(blue, 14).
max_score(green, 13).
max_score(red, 12).

color(blue).
color(green).
color(red).

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
    split_string(Set, " ", "", [ScoreStr, ColorStr]),
    atom_number(ScoreStr, Score),
    atom_string(Color, ColorStr),
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

get_color_max_score([], _, Accum, Accum).
get_color_max_score([Score, CurrentColor|Rest], Color, Accum, Max) :-
    CurrentColor = Color,
    Score > Accum,
    get_color_max_score(Rest, Color, Score, Max), !.
get_color_max_score([Score, CurrentColor|Rest], Color, Accum, Max) :-
    CurrentColor = Color,
    Score =< Accum,
    get_color_max_score(Rest, Color, Accum, Max).
get_color_max_score([_, CurrentColor|Rest], Color, Accum, Max) :-
    CurrentColor \= Color,
    get_color_max_score(Rest, Color, Accum, Max).

get_max_score(Set, Result) :-
    get_color_max_score(Set, blue, 0, BlueMax),
    get_color_max_score(Set, green, 0, GreenMax),
    get_color_max_score(Set, red, 0, RedMax),
    Result = [BlueMax, GreenMax, RedMax].

multiply([], 1).
multiply([X|Rest], Result) :-
    multiply(Rest, RestResult),
    X > 0,
    Result is RestResult * X.
multiply([X|Rest], Result) :-
    multiply(Rest, RestResult),
    X =< 0,
    Result is RestResult.

sum_power_set([], 0).
sum_power_set([Set|Rest], Sum) :-
    sum_power_set(Rest, RestSum),
    parse_line(Set, _, Sets),
    flatten(Sets, FlatSet),
    get_max_score(FlatSet, MaxScores),
    multiply(MaxScores, MaxScore),
    Sum is RestSum + MaxScore.

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
    sum_power_set(Input, SumV2),
    write(Sum), nl,
    write(SumV2), nl.

