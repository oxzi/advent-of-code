-module(day06).
-export([solve/0]).

-define(INPUT, "input").

solve() ->
	{Map, Rows, Cols} = fetch_input(?INPUT),
	Part1 = cephalopod_wrong(Map, Rows, Cols),
	Part2 = cephalopod_right(Map, Rows, Cols),
	{Part1, Part2}.

-record(state, {operator=fun erlang:'+'/2, neutral=0, stack=#{}, sum=0}).

cephalopod_right(Map, Rows, Cols) ->
	cephalopod_right(Map, Rows, Cols, 1, Cols, #state{}).

cephalopod_right(_, _, _, 1, 0, #state{sum=Sum}) ->
	Sum;
cephalopod_right(Map, Rows, Cols, Rows, C, S = #state{}) ->
	X = maps:get({Rows, C}, Map),
	if X =:= $  -> cephalopod_right(Map, Rows, Cols, 1, C - 1, S);
	   X =/= $  ->
		   {Op, Neutral} = if X =:= $+ -> {fun erlang:'+'/2, 0};
							  X =:= $* -> {fun erlang:'*'/2, 1}
						   end,
		   NewSum = S#state.sum + maps:fold(
									fun(_, A, B) -> Op(A, B) end,
									Neutral,
									maps:filter(fun(_, 0) -> false; (_, _) -> true end, S#state.stack)),
		   cephalopod_right(Map, Rows, Cols, 1, C - 1,
							#state{sum=NewSum})
	end;
cephalopod_right(Map, Rows, Cols, R, C, S = #state{}) ->
	X = maps:get({R, C}, Map),
	Val = maps:get(C, S#state.stack, 0),
	NewVal = if X =:= $  -> Val;
				true     -> Val * 10 + X - $0
			 end,
	NewStack = maps:put(C, NewVal, S#state.stack),
	cephalopod_right(Map, Rows, Cols, R + 1, C, S#state{stack=NewStack}).

cephalopod_wrong(Map, Rows, Cols) ->
	cephalopod_wrong(Map, Rows, Cols, Rows, 1, #state{}).

cephalopod_wrong(Map, Rows, Cols, Rows, C, S = #state{}) ->
	X = maps:get({Rows, C}, Map, fin),
	if X =:= $  -> cephalopod_wrong(Map, Rows, Cols, Rows - 1, C, S);
	   X =/= $  ->
		   {NewOp, NewNeutral} = if X =:= $+  -> {fun erlang:'+'/2, 0};
									X =:= $*  -> {fun erlang:'*'/2, 1};
									X =:= fin -> {nobody, cares}
								 end,
		   NewSum = S#state.sum + maps:fold(
									fun(_, A, B) -> (S#state.operator)(A, B) end,
									S#state.neutral,
									S#state.stack),
		   if X =:= fin -> NewSum;
			  true      -> cephalopod_wrong(Map, Rows, Cols, Rows - 1, C,
											#state{operator=NewOp,
												   neutral=NewNeutral,
												   sum=NewSum})
		   end
	end;
cephalopod_wrong(Map, Rows, Cols, R, C, S = #state{}) ->
	X = maps:get({R, C}, Map),
	Val = maps:get(R, S#state.stack, 0),
	NewVal = if X =:= $  -> Val;
				true     -> Val * 10 + X - $0
			 end,
	NewStack = maps:put(R, NewVal, S#state.stack),
	{NewR, NewC} = if R =:= 1 -> {Rows, C + 1};
					  R > 1   -> {R - 1, C}
				   end,
	cephalopod_wrong(Map, Rows, Cols, NewR, NewC, S#state{stack=NewStack}).

fetch_input(Input) ->
	{ok, Bin} = file:read_file(Input),
	Rows = lists:map(fun lists:enumerate/1, string:tokens(binary_to_list(Bin), "\n")),
	PropL = lists:flatten(
			  lists:map(
				fun({Row, Cols}) -> lists:map(fun({Col, V}) -> {{Row, Col}, V} end, Cols) end,
				lists:enumerate(Rows))),
	{proplists:to_map(PropL), length(Rows), length(PropL) div length(Rows)}.
