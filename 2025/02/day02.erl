-module(day02).
-export([main/0]).

-define(INPUT, "input").

main() ->
	Ids = lists:flatten(lists:map(fun({A, O}) -> lists:seq(A, O) end, fetch_input(?INPUT))),
	Part1 = lists:sum(lists:filter(fun is_invalid_id_part1/1, Ids)),
	Part2 = lists:sum(lists:filter(fun is_invalid_id_part2/1, Ids)),
	{Part1, Part2}.

is_invalid_id_part1(X) ->
	Digits = trunc(math:log10(X)) + 1,
	case Digits of
		_ when Digits rem 2 == 1 -> false;
		_ ->
			High = trunc(X / math:pow(10, Digits/2)),
			Low = X - trunc(High * math:pow(10, Digits/2)),
			High =:= Low
	end.

is_invalid_id_part2(X) ->
	Digits = trunc(math:log10(X)) + 1,
	is_invalid_id_part2(X, Digits, Digits - 1).

is_invalid_id_part2(_, _, 0) ->
	false;
is_invalid_id_part2(X, Digits, PatternLen) when Digits rem PatternLen =/= 0 ->
	is_invalid_id_part2(X, Digits, PatternLen - 1);
is_invalid_id_part2(X, Digits, PatternLen) ->
	Pattern = trunc(X / math:pow(10, Digits - PatternLen)),
	Repeat = lists:sum(lists:map(
						 fun(I) -> trunc(Pattern * math:pow(10, PatternLen * I)) end,
						 lists:seq(0, Digits div PatternLen - 1))),
	if Repeat =:= X -> true;
	   Repeat =/= X -> is_invalid_id_part2(X, Digits, PatternLen - 1)
	end.

fetch_input(Input) ->
	{ok, Bin} = file:read_file(Input),
	lists:map(
	  fun(X) ->
			  [A, O] = string:split(string:trim(X), "-"),
			  {list_to_integer(A), list_to_integer(O)}
	  end,
	  string:tokens(binary_to_list(Bin), ",")).
