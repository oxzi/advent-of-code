-module(day05).
-export([solve/0]).

-define(INPUT, "input").

solve() ->
	{Ranges, Ingredients} = fetch_input(?INPUT),
	Part1 = length(lists:filter(fun(X) -> is_fresh(Ranges, X) end, Ingredients)),
	Part2 = fresh_total(Ranges),
	{Part1, Part2}.

is_fresh(Ranges, Id) ->
	lists:any(
	  fun({A, O}) when A =< Id, Id =< O -> true;
		 (_)                            -> false
	  end,
	  Ranges).

fresh_total(Ranges) ->
	Rs = lists:foldl(
		   fun({A, O}, Rs = [{PreA, PreO} | _]) when A >= PreA, O =< PreO            -> Rs;
			  ({A, O}, [{PreA, PreO} | Tail])   when A >= PreA, A =< PreO, O >= PreO -> [{PreA, O} | Tail];
			  (R, Rs)                                                                -> [R | Rs]
		   end,
		   [],
		   lists:sort(Ranges)),
	lists:sum(lists:map(fun({A, O}) -> O - A + 1 end, Rs)).

fetch_input(Input) ->
	{ok, Bin} = file:read_file(Input),
	[RangesStr, IngredientsStr] = string:split(binary_to_list(Bin), "\n\n"),
	Ranges = lists:map(
			   fun(X) -> [A, O] = string:split(X, "-"), {list_to_integer(A), list_to_integer(O)} end,
			   string:tokens(RangesStr, "\n")),
	Ingredients = lists:map(fun list_to_integer/1, string:tokens(IngredientsStr, "\n")),
	{Ranges, Ingredients}.
