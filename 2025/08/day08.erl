-module(day08).
-export([solve/0]).

-define(INPUT, {"input", 1000}).

solve() ->
	{Filename, Conns} = ?INPUT,
	Boxes = fetch_input(Filename),
	BoxCombinations = distances(Boxes),
	Part1 = shortest_conns(BoxCombinations, Conns),
	Part2 = connect_all(BoxCombinations, length(Boxes)),
	{Part1, Part2}.

connect_all(BoxCombinations, Count) ->
	lists:foldl(
	  fun({A={XA,_,_}, B={XB,_,_}, Dist}, Circuits) when is_list(Circuits) ->
			  NewCircuits = join_junction_boxes({A, B, Dist}, Circuits),
			  CircuitLengths = lists:map(fun erlang:length/1, NewCircuits),
			  if CircuitLengths =:= [Count] -> XA * XB;
				 true                       -> NewCircuits
			  end;
		 (_, Prod) ->
			  Prod
	  end,
	  [],
	  BoxCombinations).

shortest_conns(BoxCombinations, Conns) ->
	Circuits = lists:foldl(
				 fun join_junction_boxes/2,
				 [],
				 lists:sublist(BoxCombinations, Conns)),
	[A,B,C | _] = lists:sort(fun(A, B) -> A > B end, lists:map(fun erlang:length/1, Circuits)),
	A * B * C.

join_junction_boxes({A, B, _}, Circuits) ->
	ACircs = lists:filter(fun(C) -> lists:any(fun(X) -> X =:= A end, C) end, Circuits),
	BCircs = lists:filter(fun(C) -> lists:any(fun(X) -> X =:= B end, C) end, Circuits),
	case {length(ACircs), length(BCircs)} of
		{0, 0} ->
			[[A, B] | Circuits];
		{1, 0} ->
			[ACirc] = ACircs,
			lists:map(fun(C) when C =:= ACirc -> [B | ACirc]; (C) -> C end, Circuits);
		{0, 1} ->
			[BCirc] = BCircs,
			lists:map(fun(C) when C =:= BCirc -> [A | BCirc]; (C) -> C end, Circuits);
		{1, 1} ->
			{[ACirc], [BCirc]} = {ACircs, BCircs},
			if ACirc =:= BCirc ->
				   Circuits;
			   ACirc =/= BCirc ->
				   [lists:uniq(ACirc ++ BCirc)
					| lists:filter(fun(L) -> (L =/= ACirc) and (L =/= BCirc) end, Circuits)]
			end
	end.

distances(Boxes) ->
	lists:sort(
	  fun({_, _, DistA}, {_, _, DistB}) -> DistA =< DistB end,
	  lists:map(
		fun({A={XA,YA,ZA}, B={XB,YB,ZB}}) ->
				{A, B, math:sqrt(math:pow(XA - XB, 2) + math:pow(YA - YB, 2) + math:pow(ZA - ZB, 2))}
		end,
		combinations(Boxes))).

combinations([]) ->
	[];
combinations([Head | Tail]) ->
	[{Head, T} || T <- Tail] ++ combinations(Tail).

fetch_input(Input) ->
	{ok, Bin} = file:read_file(Input),
	lists:map(
	  fun(Row) -> list_to_tuple([list_to_integer(X) || X <- string:tokens(Row, ",")]) end,
	  string:tokens(binary_to_list(Bin), "\n")).
