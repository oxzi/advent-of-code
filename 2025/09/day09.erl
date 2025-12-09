-module(day09).
-export([solve/0]).

-define(INPUT, "input").

solve() ->
	Tiles = fetch_input(?INPUT),
	Combs = lists:sort(
			  fun({_, _, A}, {_, _, B}) -> A > B end,
			  combinations(
				fun(A = {XA, YA}, B = {XB, YB}) ->
						{A, B, (abs(XA - XB) + 1) * (abs(YA - YB) + 1)} end,
				Tiles)),
	[{_, _, Part1} | _] = Combs,
	Reds = red_tiles(Tiles),
	% Part 2 is the most braindead brute force attempt one can imagine. I tried some ray-casting
	% algorithm, but it somehow did not worked out. After a time, I went for the ol' reliable.
	% Took quite as long as taking down the old and hanging up the new laundry.
	Part2 = lists:foldl(
			  fun({I, {{X1, Y1}, {X2, Y2}, Dist}}, false) ->
					  if I rem 100 =:= 0 ->
							 io:format("~p / ~p~n", [I, length(Combs)]);
						 true -> false
					  end,
					  BorderIn = lists:any(fun({X,Y}) -> within({X,Y}, {X1,Y1}, {X2,Y2}) end, Reds),
					  if BorderIn -> false;
						 true     -> Dist
					  end;
				 (_, Dist) ->
					  Dist
			  end,
			  false,
			  lists:enumerate(Combs)),
	{Part1, Part2}.

within({X, Y}, {X1, Y1}, {X2, Y2}) ->
	[MinX, MaxX] = lists:sort([X1, X2]),
	[MinY, MaxY] = lists:sort([Y1, Y2]),
	(MinX < X) and (X < MaxX) and (MinY < Y) and (Y < MaxY).

red_tiles(Tiles) ->
	lists:foldl(
	  fun({{X, Y1}, {X, Y2}}, Reds) ->
			  [{X, Y} || Y <- lists:seq(min(Y1, Y2)+1, max(Y1, Y2)-1)] ++ Reds;
		 ({{X1, Y}, {X2, Y}}, Reds) ->
			  [{X, Y} || X <- lists:seq(min(X1, X2)+1, max(X1, X2)-1)] ++ Reds
	  end,
	  [],
	  lists:zip([lists:last(Tiles) | lists:droplast(Tiles)], Tiles)).

combinations(_, []) ->
	[];
combinations(MapFun, [H | Tail]) ->
	[MapFun(H, T) || T <- Tail] ++ combinations(MapFun, Tail).

fetch_input(Input) ->
	{ok, Bin} = file:read_file(Input),
	lists:map(
	  fun(Row) -> list_to_tuple([list_to_integer(X) || X <- string:tokens(Row, ",")]) end,
	  string:tokens(binary_to_list(Bin), "\n")).
