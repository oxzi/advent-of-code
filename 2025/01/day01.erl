-module(day01).
-export([main/0]).

-define(INPUT, "input").

main() ->
	Rotations = parse_input(?INPUT),
	{EndPos, ZerosOne} = lists:foldl(fun rotate_part1/2, {50, 0}, Rotations),
	{EndPos, ZerosTwo} = lists:foldl(fun rotate_part2/2, {50, 0}, Rotations),
	{EndPos, ZerosOne, ZerosTwo}.

%% rotate the safe position by a direction and an amount, part one.
rotate_part1({D, N}, {Pos, Zeros}) when N > 100 ->
	rotate_part1({D, N rem 100}, {Pos, Zeros});
rotate_part1({l, N}, {Pos, Zeros}) ->
	zero_incr({(Pos - N + 100) rem 100, Zeros});
rotate_part1({r, N}, {Pos, Zeros}) ->
	zero_incr({(Pos + N) rem 100, Zeros}).

%% increase the rotate accumulator for zero positions.
zero_incr({0, Zeros}) ->
	{0, Zeros + 1};
zero_incr(Acc) ->
	Acc.

%% rotate the safe position by a direction and an amount, part two.
rotate_part2({D, N}, {Pos, Zeros}) when N > 100 ->
	rotate_part2({D, N rem 100}, {Pos, Zeros + N div 100});
rotate_part2({l, N}, {Pos, Zeros}) ->
	{(Pos - N + 100) rem 100, Zeros + boolean_to_integer((Pos =/= 0) and (Pos =< N))};
rotate_part2({r, N}, {Pos, Zeros}) ->
	{(Pos + N) rem 100, Zeros + boolean_to_integer(Pos + N >= 100)}.

%% casts true to 1 and false to 0.
boolean_to_integer(true)  -> 1;
boolean_to_integer(false) -> 0.

%% parse an input file and returns a list of rotations.
parse_input(Filename) ->
	{ok, Bin} = file:read_file(Filename),
	Str = binary_to_list(Bin),
	lists:map(fun parse_line/1, string:tokens(Str, "\n")).

%% parse some "L68" or "R48" to {l, 68} and {r, 48}.
parse_line([$L|Rotation]) ->
	{l, list_to_integer(Rotation)};
parse_line([$R|Rotation]) ->
	{r, list_to_integer(Rotation)}.
