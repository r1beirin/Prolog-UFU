/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).

:- use_module(bd(email), []).

/*
   GET api/v1/email/
   Retorna uma lista com todos os emails.
*/
email(get, '', _Pedido):- !,
    envia_tabela_email.

/*
   GET api/v1/email/Id
   Retorna o `email` com Id 1 ou erro 404 caso o `email` não
   seja encontrado.
*/
email(get, AtomId, _Pedido):-
    atom_number(AtomId, SeqReg),
    !,
    envia_tupla_email(SeqReg).

/*
   POST api/v1/email
   Adiciona um novo email. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
email(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_email(Dados).

/*
  PUT api/v1/email/Id
  Atualiza o email com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
email(put, AtomId, Pedido):-
    atom_number(AtomId, SeqReg),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_email(Dados, SeqReg).

/*
   DELETE api/v1/email/Id
   Apaga o email com o Id informado
*/
email(delete, AtomId, _Pedido):-
    atom_number(AtomId, SeqReg),
    !,
    email:remove(SeqReg),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
email(Metodo, SeqReg, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, SeqReg))).

insere_tupla_email(_{ tipReg:TipReg, relat:Relat, emalTxt:EmalTxt, emaAss:EmaAss, emaCC:EmaCC }):-
    atom_number(TipReg, TipRegValidado),
    atom_number(Relat, RelatValidado),
    email:insere(SeqReg, TipRegValidado, RelatValidado, EmalTxt, EmaAss, EmaCC)
    -> envia_tupla_email(SeqReg)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_email( _{ tipReg:TipReg, relat:Relat, emalTxt:EmalTxt, emaAss:EmaAss, emaCC:EmaCC }, SeqReg):-
    atom_number(TipReg, TipRegValidado),
    atom_number(Relat, RelatValidado),
    email:atualiza(SeqReg, TipRegValidado, RelatValidado, EmalTxt, EmaAss, EmaCC)
    -> envia_tupla_email(SeqReg)
    ;  throw(http_reply(not_found(SeqReg))).

envia_tupla_email(SeqReg):-
       email:email(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC)
    -> reply_json_dict( _{seqReg:SeqReg, tipReg:TipReg, relat:Relat, emalTxt:EmalTxt, emaAss:EmaAss, emaCC:EmaCC})
    ;  throw(http_reply(not_found(SeqReg))).

envia_tabela_email :-
    findall( _{seqReg:SeqReg, tipReg:TipReg, relat:Relat, emalTxt:EmalTxt, emaAss:EmaAss, emaCC:EmaCC},
             email:email(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC),
             Tuplas ),
    reply_json_dict(Tuplas).
