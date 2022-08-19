/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).

:- use_module(bd(eventos), []).

/*
   GET api/v1/eventos/
   Retorna uma lista com todos os eventos.
*/
eventos(get, '', _Pedido):- !,
    envia_tabela_eventos.

/*
   GET api/v1/eventos/Id
   Retorna o `evento` com Id 1 ou erro 404 caso o `evento` não
   seja encontrado.
*/
eventos(get, AtomId, _Pedido):-
    atom_number(AtomId, CodEve),
    !,
    envia_tupla_eventos(CodEve).

/*
   POST api/v1/eventos
   Adiciona um novo eventos. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
eventos(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_eventos(Dados).

/*
  PUT api/v1/eventos/Id
  Atualiza o eventos com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
eventos(put, AtomId, Pedido):-
    atom_number(AtomId, CodEve),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_eventos(Dados, CodEve).

/*
   DELETE api/v1/eventos/Id
   Apaga o evento com o Id informado
*/
eventos(delete, AtomId, _Pedido):-
    atom_number(AtomId, CodEve),
    !,
    eventos:remove(CodEve),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
eventos(Metodo, CodEve, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, CodEve))).

insere_tupla_eventos( _{desEve:DesEve, vlrPrc:VlrPrc, prmVct:PrmVct, qtdPrc:QtdPrc}):-
    %   Validação e transformação de atomo para número
    atom_number(VlrPrc, VlrPrcValidado),
    atom_number(QtdPrc, QtdPrcValidado),

    eventos:insere(CodEve, DesEve, VlrPrcValidado, PrmVct, QtdPrcValidado)
    -> envia_tupla_eventos(CodEve)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_eventos( _{ desEve:DesEve, vlrPrc:VlrPrc, prmVct:PrmVct, qtdPrc:QtdPrc}, CodEve):-
    %   Validação e transformação de atomo para número
    atom_number(VlrPrc, VlrPrcValidado),
    atom_number(QtdPrc, QtdPrcValidado),

    eventos:atualiza(CodEve, DesEve, VlrPrcValidado, PrmVct, QtdPrcValidado)
    -> envia_tupla_eventos(CodEve)
    ;  throw(http_reply(not_found(CodEve))).

envia_tupla_eventos(CodEve):-
       eventos:eventos(CodEve, DesEve, VlrPrc, PrmVct, QtdPrc)
    -> reply_json_dict( _{codEve:CodEve, desEve:DesEve, vlrPrc:VlrPrc, prmVct:PrmVct, qtdPrc:QtdPrc} )
    ;  throw(http_reply(not_found(CodEve))).

envia_tabela_eventos :-
    findall( _{codEve:CodEve, desEve:DesEve, vlrPrc:VlrPrc, prmVct:PrmVct, qtdPrc:QtdPrc},
             eventos:eventos(CodEve, DesEve, VlrPrc, PrmVct, QtdPrc),
             Tuplas ),
    reply_json_dict(Tuplas).
