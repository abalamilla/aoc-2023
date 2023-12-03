filter_numbers([], []).
filter_numbers([H|T], Numbers) :-
	char_type(H, digit),
	filter_numbers(T, RestNumbers),
	Numbers = [H|RestNumbers].
filter_numbers([_|T], Numbers) :-
	filter_numbers(T, Numbers).

first([H|_], H).

last([_|T], Last) :-
	last(T, Last).
last([H], H).

process_lines([First|Rest], Accum, Sum) :-
	string_chars(First, Chars),
	filter_numbers(Chars, Numbers),
	first(Numbers, FirstNumber),
	last(Numbers, LastNumber),
	concat_atom([FirstNumber, LastNumber], Concat),
	atom_number(Concat, Number),
	process_lines(Rest, Number + Accum, Sum).
process_lines([], Accum, Sum) :- Sum is Accum, !.

sum_calibration(Input, Sum) :-
	process_lines(Input, 0, Sum).

%! test.

read_lines(Stream, [Line|Lines]) :-
    read_string(Stream, "\n", "\r", _, Line),
    Line \= "",
    read_lines(Stream, Lines).
read_lines(_, []).

load_file(Filename, Lines) :-
    open(Filename, read, Stream),
    read_lines(Stream, Lines),
    close(Stream).

main :-
	load_file("input.txt", Input),
	sum_calibration(Input, Sum),
	write(Sum), nl.
