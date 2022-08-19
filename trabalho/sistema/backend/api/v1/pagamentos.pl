/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).

:- use_module(bd(integrante), []).
:- use_module(bd(eventos), []).
:- use_module(bd(lancamentos), []).
:- use_module(bd(pagamentos), []).

/*
   GET api/v1/pagamentos/
   Retorna uma lista com todos os pagamentos.
*/
pagamentos(get, '', _Pedido):- !,
    envia_tabela_pagamentos.

/*
   GET api/v1/pagamentos/Id
   Retorna o `pagamento` com Id 1 ou erro 404 caso o `pagamento` não
   seja encontrado.
*/
pagamentos(get, AtomId, _Pedido):-
    atom_number(AtomId, SeqPag),
    !,
    envia_tupla_pagamentos(SeqPag).

/*
   POST api/v1/pagamentos
   Adiciona um novo pagamento. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
pagamentos(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_pagamentos(Dados).

/*
  PUT api/v1/pagamentos/Id
  Atualiza o pagamento com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
pagamentos(put, AtomId, Pedido):-
    atom_number(AtomId, SeqPag),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_pagamentos(Dados, SeqPag).

/*
   DELETE api/v1/pagamentos/Id
   Apaga o pagamento com o Id informado
*/
pagamentos(delete, AtomId, _Pedido):-
    atom_number(AtomId, SeqPag),
    !,
    pagamentos:remove(SeqPag),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
pagamentos(Metodo, SeqPag, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, SeqPag))).

insere_tupla_pagamentos( _{ codUsu:CodUsu, codEve:CodEve, numPrc:NumPrc, datPag:DatPag, vlrPag:VlrPag, obsPag:ObsPag, tipPag:TipPag, usuPag:UsuPag, statPag:StatPag, usuCan:UsuCan, datCan:DatCan, datCadPag:DatCadPag}):-
    atom_number(CodUsu, CodUsuValidado),
    atom_number(CodEve, CodEveValidado),
    atom_number(NumPrc, NumPrcValidado),
    atom_number(VlrPag, VlrPagValidado),
    atom_number(TipPag, TipPagValidado),
    atom_number(UsuPag, UsuPagValidado),
    atom_number(StatPag, StatPagValidado),
    atom_number(UsuCan, UsuCanValidado),

    pagamentos:insere(SeqPag, NumPrcValidado, CodUsuValidado, CodEveValidado, DatPag, VlrPagValidado, ObsPag, TipPagValidado, UsuPagValidado, StatPagValidado, UsuCanValidado, DatCan, DatCadPag)
    -> envia_tupla_pagamentos(SeqPag)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_pagamentos( _{codUsu:CodUsu, codEve:CodEve, numPrc:NumPrc, datPag:DatPag, vlrPag:VlrPag, obsPag:ObsPag, tipPag:TipPag, usuPag:UsuPag, statPag:StatPag, usuCan:UsuCan, datCan:DatCan, datCadPag:DatCadPag}, SeqPag):-
    atom_number(CodUsu, CodUsuValidado),
    atom_number(CodEve, CodEveValidado),
    atom_number(NumPrc, NumPrcValidado),
    atom_number(VlrPag, VlrPagValidado),
    atom_number(TipPag, TipPagValidado),
    atom_number(UsuPag, UsuPagValidado),
    atom_number(StatPag, StatPagValidado),
    atom_number(UsuCan, UsuCanValidado),

    pagamentos:atualiza(SeqPag, NumPrcValidado, CodUsuValidado, CodEveValidado, DatPag, VlrPagValidado, ObsPag, TipPagValidado, UsuPagValidado, StatPagValidado, UsuCanValidado, DatCan, DatCadPag)
    -> envia_tupla_pagamentos(SeqPag)
    ;  throw(http_reply(not_found(SeqPag))).

envia_tupla_pagamentos(SeqPag):-
       pagamentos:pagamentos(SeqPag, NumPrc, CodUsu, CodEve, DatPag, VlrPag, ObsPag, TipPag, UsuPag, StatPag, UsuCan, DatCan, DatCadPag)
    -> reply_json_dict( _{seqPag:SeqPag, codUsu:CodUsu, codEve:CodEve, numPrc:NumPrc, datPag:DatPag, vlrPag:VlrPag, obsPag:ObsPag, tipPag:TipPag, usuPag:UsuPag, statPag:StatPag, usuCan:UsuCan, datCan:DatCan, datCadPag:DatCadPag} )
    ;  throw(http_reply(not_found(SeqPag))).

envia_tabela_pagamentos :-
    findall( _{seqPag:SeqPag, codUsu:CodUsu, codEve:CodEve, numPrc:NumPrc, datPag:DatPag, vlrPag:VlrPag, obsPag:ObsPag, tipPag:TipPag, usuPag:UsuPag, statPag:StatPag, usuCan:UsuCan, datCan:DatCan, datCadPag:DatCadPag},
             pagamentos:pagamentos(SeqPag, NumPrc, CodUsu, CodEve, DatPag, VlrPag, ObsPag, TipPag, UsuPag, StatPag, UsuCan, DatCan, DatCadPag),
             Tuplas ),
    reply_json_dict(Tuplas).
