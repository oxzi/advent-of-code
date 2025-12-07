-module(day07).
-export([solve/0]).

-define(INPUT, "input").

solve() ->
	{Map, Rows, Cols} = fetch_input(?INPUT),
	[{StartPos, start}] = maps:to_list(maps:filter(
										 fun(_, start) -> true;
											(_, _) -> false end,
										 Map)), 
	Part1 = beam(Map, Rows, Cols, [StartPos]),
	Part2 = quantum(Map, Rows, Cols, [{StartPos, 1}], []),
	{Part1, Part2}.

quantum(_Map, _Rows, _Cols, [], Prev) ->
	lists:foldl(fun({_, Ctr}, Acc) -> Ctr + Acc end, 0, Prev);
quantum(Map, Rows, Cols, Tachyons, _Prev) ->
	{C, N, S} = lists:foldl(
				  fun({{Row, Col}, Ctr}, {Splits, NextStep, SplitStep}) when Col < 1; Col > Cols; Row > Rows ->
						  {Splits, NextStep, [{{Row, Col}, Ctr} | SplitStep]};
					 ({{Row, Col}, Ctr}, {Splits, NextStep, SplitStep}) ->
						  X = maps:get({Row, Col}, Map),
						  case X of
							  splitter ->
								  {Splits + 1, [], [{{Row, Col - 1}, Ctr}, {{Row, Col + 1}, Ctr}] ++ SplitStep};
							  _ ->
								  {Splits, [{{Row + 1, Col}, Ctr} | NextStep], [{{Row, Col}, Ctr} | SplitStep]}
						  end
				  end,
				  {0, [], []},
				  Tachyons),
	quantum(Map, Rows, Cols, if C > 0 -> merge_timelines(S); C =:= 0 -> lists:uniq(N) end, Tachyons).

merge_timelines(Tachyons) ->
	lists:foldl(
	  fun({{Row, Col}, LCtr}, [{{Row, Col}, RCtr} | Tail]) -> [{{Row, Col}, LCtr + RCtr} | Tail];
		 (Tachyon, Tail)                                   -> [Tachyon | Tail]
	  end,
	  [],
	  lists:sort(Tachyons)).

beam(_Map, _Rows, _Cols, []) ->
	0;
beam(Map, Rows, Cols, Tachyons) ->
	{C, N, S} = lists:foldl(
				  fun({Row, Col}, {Splits, NextStep, SplitStep}) when Col < 1; Col > Cols; Row > Rows ->
						  {Splits, NextStep, [{Row, Col} | SplitStep]};
					 ({Row, Col}, {Splits, NextStep, SplitStep}) ->
						  X = maps:get({Row, Col}, Map),
						  case X of
							  splitter ->
								  {Splits + 1, [], [{Row, Col - 1}, {Row, Col + 1}] ++ SplitStep};
							  _ ->
								  {Splits, [{Row + 1, Col} | NextStep], [{Row, Col} | SplitStep]}
						  end
				  end,
				  {0, [], []},
				  Tachyons),
	if C > 0   -> C + beam(Map, Rows, Cols, lists:uniq(S));
	   C =:= 0 -> C + beam(Map, Rows, Cols, lists:uniq(N))
	end.

fetch_input(Input) ->
	{ok, Bin} = file:read_file(Input),
	Rows = lists:map(
			 fun(L) -> lists:enumerate(lists:map(
										 fun($S) -> start;
											($^) -> splitter;
											(_)  -> space end,
										 L)) end,
			 string:tokens(binary_to_list(Bin), "\n")),
	PropL = lists:flatten(
			  lists:map(
				fun({Row, Cols}) ->
						lists:map(fun({Col, Kind}) -> {{Row, Col}, Kind} end, Cols)
				end,
				lists:enumerate(Rows))),
	{proplists:to_map(PropL), length(Rows), length(PropL) div length(Rows)}.
