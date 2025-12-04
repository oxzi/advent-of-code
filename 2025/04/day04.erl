-module(day04).
-export([solve/0]).

-define(INPUT, "input").

solve() ->
	Map = fetch_input(?INPUT),
	{_, Part1} = remove_and_count(Map),
	Part2 = remove_until(Map, 0),
	{Part1, Part2}.

remove_until(Map, Count) ->
	{NewMap, Inc} = remove_and_count(Map),
	if Inc =:= 0 -> Count;
	   Inc > 0   -> remove_until(NewMap, Count + Inc)
	end.

remove_and_count(Map) ->
	Rem = maps:filter(
			fun({Row, Col}, paper) ->
					Count = lists:foldl(
							  fun({RowOff, ColOff}, Count) ->
									  Neighbor = maps:get({Row + RowOff, Col + ColOff}, Map, void),
									  if Neighbor =:= paper -> Count + 1;
										 Neighbor =/= paper -> Count
									  end
							  end,
							  0,
							  [{-1, -1}, {-1, 0}, {-1, 1},
							   {0, -1}, {0, 1},
							   {1, -1}, {1, 0}, {1, 1}]),
					Count < 4;
			   (_, _) ->
					false
			end,
			Map),
	NewMap = maps:merge(Map, maps:map(fun(_, _) -> void end, Rem)),
	{NewMap, maps:size(Rem)}.

fetch_input(Input) ->
	{ok, Bin} = file:read_file(Input),
	Lines = lists:map(
			  fun(L) -> lists:enumerate(lists:map(fun($@) -> paper; (_) -> void end, L)) end,
			  string:tokens(binary_to_list(Bin), "\n")),
	PropL = lists:flatten(
			  lists:map(
				fun({Row, Cols}) ->
						lists:map(fun({Col, Kind}) -> {{Row, Col}, Kind} end, Cols)
				end,
				lists:enumerate(Lines))),
	proplists:to_map(PropL).
