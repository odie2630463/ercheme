ercheme
=======

little Lisp/Scheme implement on Erlang
***
##How to test it 
in Erlang Shell

	>cd(yourdir).
	>ercheme:repl([]).
	>>> 5
	{5,[]}
	>>> (def a 10)
	{10,[{a,10}]}
	>>> a
	{10,[{a,10}]}
	>>> (+ 1 a)
	{11,[{a,10}]}
	>>> (def add (lambda (x) (+ x 10)))
	{#Fun<erl_eval.6.80484245>,[{a,10},{add,#Fun<erl_eval.	6.80484245>}]}
	>>> (add 5)
	{15,[{a,10},{add,#Fun<erl_eval.6.80484245>}]}
	>>> (add a)
	{20,[{a,10},{add,#Fun<erl_eval.6.80484245>}]}

***

##Translate S-express to Erlang Abstract Format
[Erlang Abstract Format](http://www.erlang.org/doc/apps/erts/absform.html)
