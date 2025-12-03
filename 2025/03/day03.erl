-module(day03).
-export([solve/0]).

-define(INPUT, "input").

solve() ->
	Banks = fetch_input(?INPUT),
	Part1 = lists:sum(lists:map(fun(Bank) -> max_n_in_bank(Bank, 2) end, Banks)),
	Part2 = lists:sum(lists:map(fun(Bank) -> max_n_in_bank(Bank, 12) end, Banks)),
	{Part1, Part2}.

max_n_in_bank(Bank, Len) ->
	lists:foldl(fun(X, Sum) -> X + Sum * 10 end, 0, max_n_in_bank(Bank, 1, Len)).

max_n_in_bank(_, _, 0) -> [];
max_n_in_bank(Bank, Start, Len) ->
	% Sliding window from start/latest biggest number to Len-th last element
	% Pick biggest number from this window, move next window directly afterwards
	Window = lists:sublist(Bank, Start, length(Bank) - Start + 1 - Len + 1),
	Max = lists:max(Window),
	Pos = string:str(Window, [Max]),
	[Max | max_n_in_bank(Bank, Start + Pos, Len - 1)].

fetch_input(Input) ->
	{ok, Bin} = file:read_file(Input),
	Lines = string:tokens(binary_to_list(Bin), "\n"),
	lists:map(
	  fun(L) -> lists:map(fun(X) -> X - $0 end, L) end,
	  Lines).
