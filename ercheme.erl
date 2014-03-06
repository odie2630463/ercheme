-module(ercheme).
-export([repl/1]).

% list op
car(S_exp) ->
	{cons,H,_} = S_exp,
	H.
cdr(S_exp) ->
	{cons,_,T} = S_exp,
	T.
listp(S_exp) ->
	case S_exp of 
		{cons,_,_} -> true;
		_ -> false
	end.
% 
args2list(Args,Acc) ->
	case Args of 
		nil -> Acc;
		_ -> args2list(cdr(Args),Acc++[ercheme2erlangAst(car(Args))])
	end.
%
ercheme2erlangAst(Erc) ->
	case Erc of 
		% true or false
		{symbol,_,true} -> {atom,1,true};
		{symbol,_,false} -> {atom,1,false};
		% interger
		{integer,_,Number} ->  
			Ast = {integer,1,Number},
			Ast;
		% Symbol
		{symbol,_,Var} -> 
			Ast = {var,1,Var},
			Ast;
		% List
		{cons,_,_} ->
			Op = car(Erc),
			Arg = cdr(Erc),
			case Op of 
				% scheme's define
				{symbol,_,def} -> 
					Sym = ercheme2erlangAst(car(Arg)),
					Val = ercheme2erlangAst(car(cdr(Arg))),
					{match,1,Sym,Val};
				% scheme's if
				{symbol,_,'if'} ->
					Pred = ercheme2erlangAst(car(Arg)),
					Then = ercheme2erlangAst(car(cdr(Arg))),
					Else = ercheme2erlangAst(car(cdr(Arg))),
					{'if',1,
						[{clause,1,[],
								[[Pred]],
								[Then]},
						 {clause,1,[],[[{atom,1,else}]],
						 			  [Else]}]};
				% scheme's lambda
				{symbol,_,lambda} ->
					Arg_list = args2list(car(Arg),[]),
					Bodys = ercheme2erlangAst(car(cdr(Arg))),
					{'fun',1,
							{clauses,[
										{clause,1,Arg_list,[],[Bodys]}
										]}};
				% base op + - * / > < = 
				{op,_,Operation} ->
					Arg1 = ercheme2erlangAst(car(Arg)),
					Arg2 = ercheme2erlangAst(car(cdr(Arg))),
					O = case Operation of 
							'=' -> '==';
							_ -> Operation
						end,
					{op,1,O,Arg1,Arg2};
				% apply symbol
				{symbol,_,Var} ->
					Arg_list = args2list(Arg,[]),
					{call,1,{var,1,Var},Arg_list};

				_ -> {error_2,Op,Arg}
			end;
		_ -> {error,Erc}
	end.
read_erscheme(Str) ->
	A= reader:reader(Str),
	{_,{form,Erc}} = A,
	Erc.
compile_ercheme(Erc) ->
	case Erc of 
		{quote,_} -> Erc;
		_ -> ercheme2erlangAst(Erc)
	end.
repl(Env) ->
	S = io:get_line(">>>"),
	E = read_erscheme(S),
	A = compile_ercheme(E),
	{M,O,N_Env} = erl_eval:expr(A,Env),
	io:format("~w~n",[{O,N_Env}]),
	repl(N_Env).