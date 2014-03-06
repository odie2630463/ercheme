Nonterminals form list elements element.
Terminals quote symbol integer op left right.
Rootsymbol form.

form -> element : {form,'$1'}.

list -> left right : nil.
list -> left elements right : '$2'.

elements -> element : {cons, '$1', nil}.
elements -> element elements : {cons,'$1','$2'}.

element -> symbol : '$1'.
element -> op : '$1'.
element -> integer : '$1'.
element -> list :'$1'.
element -> quote element : {quote,'$2'}.