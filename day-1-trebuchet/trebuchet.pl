first_digit([H|_], Digit) :-
	char_type(H, digit),
	Digit = H.
first_digit([_|T], Digit) :-
	first_digit(T, Digit).

lookup_digit(String, Digit) :-
	string_chars(String, Chars),
	first_digit(Chars, Digit).

process_lines([First|Rest], Accum, Sum) :-
	string_chars(First, Chars),
	first_digit(Chars, FirstDigit),
	reverse(Chars, Reversed),
	first_digit(Reversed, LastDigit),
	concat_atom([FirstDigit, LastDigit], Concat),
	atom_number(Concat, Digit),
	process_lines(Rest, Digit + Accum, Sum).
process_lines([], Accum, Sum) :- Sum is Accum, !.

sum_calibration(Input, Sum) :-
	process_lines(Input, 0, Sum).

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
	write(Input), nl,
	sum_calibration(Input, Sum),
	write(Sum), nl.
