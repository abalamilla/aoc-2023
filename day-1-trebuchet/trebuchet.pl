numbers(one, '1').
numbers(two, '2').
numbers(three, '3').
numbers(four, '4').
numbers(five, '5').
numbers(six, '6').
numbers(seven, '7').
numbers(eight, '8').
numbers(nine, '9').

first_digit([H|_], Digit) :-
	char_type(H, digit),
	Digit = H.
first_digit([_|T], Digit) :-
	first_digit(T, Digit).

verify_fact(String, Fact, Remaining) :-
	append(FactAtom, Remaining, String),
	atom_string(FactString, FactAtom),
	numbers(FactString, Fact).

find_spelled_numbers([], []).
find_spelled_numbers([C|Rest], [NewC|NewRest]) :-
	verify_fact([C|Rest], Fact, Remaining),
	!,
	find_spelled_numbers(Remaining, NewRest),
	NewC = Fact.
find_spelled_numbers([C|Rest], [C|NewRest]) :-
	find_spelled_numbers(Rest, NewRest).

replace_spelled_numbers(String, Replaced) :-
	atom_chars(String, Chars),
	find_spelled_numbers(Chars, Replaced).

process_lines([First|Rest], Accum, Sum) :-
	replace_spelled_numbers(First, Replaced),
	first_digit(Replaced, FirstDigit),
	reverse(Replaced, Reversed),
	first_digit(Reversed, LastDigit),
	concat_atom([FirstDigit, LastDigit], Concat),
	atom_number(Concat, Digit),
	process_lines(Rest, Digit + Accum, Sum).
process_lines([], Accum, Sum) :- 
	Sum is Accum.

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
	sum_calibration(Input, Sum),
	write(Sum), nl.
