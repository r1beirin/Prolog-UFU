/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).

:- use_module(bd(integrante), []).
:- use_module(bd(eventos), []).
:- use_module(bd(lancamentos), []).

/*
   GET api/v1/lancamentos/
   Retorna uma lista com todos os lancamentos.
*/
lancamentos(get, '', _Pedido):- !,
    envia_tabela_lancamentos.

/*
   GET api/v1/lancamentos/Id
   Retorna o `lançamento` com Id 1 ou erro 404 caso o `lançamentos` não
   seja encontrado.
*/
lancamentos(get, AtomId, _Pedido):-
    atom_number(AtomId, NumPrc),
    !,
    envia_tupla_lancamentos(NumPrc).

/*
   POST api/v1/lancamentos
   Adiciona um novo lançamento. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
lancamentos(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_lancamentos(Dados).

/*
  PUT api/v1/lancamentos/Id
  Atualiza o lançamento com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
lancamentos(put, AtomId, Pedido):-
    atom_number(AtomId, NumPrc),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_lancamentos(Dados, NumPrc).

/*
   DELETE api/v1/lancamentos/Id
   Apaga o lançamento com o Id informado
*/
lancamentos(delete, AtomId, _Pedido):-
    atom_number(AtomId, NumPrc),
    !,
    lancamentos:remove(NumPrc),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
lancamentos(Metodo, NumPrc, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, NumPrc))).

insere_tupla_lancamentos( _{ codUsu:CodUsu, codEve:CodEve, vlrPrc:VlrPrc, datLan:DatLan, vctPrc:VctPrc, statPrc:StatPrc, vlrAbe:VlrAbe, usuPrc:UsuPrc, datCan:DatCan, usuCan:UsuCan}):-
    atom_number(CodUsu, CodUsuValidado),
    atom_number(CodEve, CodEveValidado),
    atom_number(VlrPrc, VlrPrcValidado),
    atom_number(StatPrc, StatPrcValidado),
    atom_number(VlrAbe, VlrAbeValidado),
    atom_number(UsuPrc, UsuPrcValidado),
    atom_number(UsuCan, UsuCanValidado),

    lancamentos:insere(NumPrc, CodUsuValidado, CodEveValidado, VlrPrcValidado, DatLan, VctPrc, StatPrcValidado, VlrAbeValidado, UsuPrcValidado, DatCan, UsuCanValidado)
    -> envia_tupla_lancamentos(NumPrc)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_lancamentos( _{codUsu:CodUsu, codEve:CodEve, vlrPrc:VlrPrc, datLan:DatLan, vctPrc:VctPrc, statPrc:StatPrc, vlrAbe:VlrAbe, usuPrc:UsuPrc, datCan:DatCan, usuCan:UsuCan}, NumPrc):-
    atom_number(CodUsu, CodUsuValidado),
    atom_number(CodEve, CodEveValidado),
    atom_number(VlrPrc, VlrPrcValidado),
    atom_number(StatPrc, StatPrcValidado),
    atom_number(VlrAbe, VlrAbeValidado),
    atom_number(UsuPrc, UsuPrcValidado),
    atom_number(UsuCan, UsuCanValidado),

    lancamentos:atualiza(NumPrc, CodUsuValidado, CodEveValidado, VlrPrcValidado, DatLan, VctPrc, StatPrcValidado, VlrAbeValidado, UsuPrcValidado, DatCan, UsuCanValidado)
    -> envia_tupla_lancamentos(NumPrc)
    ;  throw(http_reply(not_found(NumPrc))).

envia_tupla_lancamentos(NumPrc):-
       lancamentos:lancamentos(NumPrc, CodUsu, CodEve, VlrPrc, DatLan, VctPrc, StatPrc, VlrAbe, UsuPrc, DatCan, UsuCan)
    -> reply_json_dict( _{numPrc:NumPrc, codUsu:CodUsu, codEve:CodEve, vlrPrc:VlrPrc, datLan:DatLan, vctPrc:VctPrc, statPrc:StatPrc, vlrAbe:VlrAbe, usuPrc:UsuPrc, datCan:DatCan, usuCan:UsuCan} )
    ;  throw(http_reply(not_found(NumPrc))).

envia_tabela_lancamentos :-
    findall( _{numPrc:NumPrc, codUsu:CodUsu, codEve:CodEve, vlrPrc:VlrPrc, datLan:DatLan, vctPrc:VctPrc, statPrc:StatPrc, vlrAbe:VlrAbe, usuPrc:UsuPrc, datCan:DatCan, usuCan:UsuCan},
             lancamentos:lancamentos(NumPrc, CodUsu, CodEve, VlrPrc, DatLan, VctPrc, StatPrc, VlrAbe, UsuPrc, DatCan, UsuCan),
             Tuplas ),
    reply_json_dict(Tuplas).
