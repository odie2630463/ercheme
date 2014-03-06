-module(reader).
-export([reader/1,test_erl_reader/1]).

-define(scanner,scanner).
-define(parser,parser).

reader(S) ->
	{_,T,_} = ?scanner:string(S),
	?parser:parse(T).

test_erl_reader(S) ->
	{_,Toks,_} = erl_scan:string(S),
	Result = erl_parse:parse_exprs(Toks),
	Result.