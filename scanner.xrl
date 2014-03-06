Definitions.

D   = [0-9]
L   = [A-Za-z]
WS  = ([\000-\s]|%.*)
N   = [\n]
Op  = [\+|\-|\*|\/|\>|\<|\=]

Rules.

{L}+   : {token,{symbol,TokenLine,list_to_atom(TokenChars)}}.
{D}+   : {token,{integer,TokenLine,list_to_integer(TokenChars)}}.
[(]    : {token,{left,TokenLine}}.
[)]    : {token,{right,TokenLine}}.
[\']   : {token,{quote,TokenLine}}.
{Op}   : {token,{op,TokenLine,list_to_atom(TokenChars)}}.
{WS}+  : skip_token.
{N}+   : skip_token.

Erlang code.
