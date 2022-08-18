/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).

:- use_module(bd(integrante), []).

/*
   GET api/v1/integrante/
   Retorna uma lista com todos os integrantes.
*/
integrante(get, '', _Pedido):- !,
    envia_tabela_integrante.

/*
   GET api/v1/integrante/Id
   Retorna o `integrante` com Id 1 ou erro 404 caso o `integrante` não
   seja encontrado.
*/
integrante(get, AtomId, _Pedido):-
    atom_number(AtomId, CodUsu),
    !,
    envia_tupla_integrante(CodUsu).

/*
   POST api/v1/integrante
   Adiciona um novo integrante. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
integrante(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_integrante(Dados).    

/*
  PUT api/v1/integrante/Id
  Atualiza o integrante com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
integrante(put, AtomId, Pedido):-
    atom_number(AtomId, CodUsu),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_integrante(Dados, CodUsu).

/*
   DELETE api/v1/integrante/Id
   Apaga o integrante com o Id informado
*/
integrante(delete, AtomId, _Pedido):-
    atom_number(AtomId, CodUsu),
    !,
    integrante:remove(CodUsu),
    throw(http_reply(no_content)).    

/* 
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
integrante(Metodo, CodUsu, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, CodUsu))).

insere_tupla_integrante( _{ nomInt:NomInt, nomUsu:NomUsu, senUsu:SenUsu, tipUsu:TipUsu, statUsu:StatUsu, emaUsu:EmaUsu}):-
    %   Validação e transformação de atomo para número
    atom_number(TipUsu, TipUsuValidado),
    atom_number(StatUsu, StatUsuValidado),

    integrante:insere(CodUsu, NomInt, NomUsu, SenUsu, TipUsuValidado, StatUsuValidado, EmaUsu)
    -> envia_tupla_integrante(CodUsu)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_integrante( _{ nomInt:NomInt, nomUsu:NomUsu, senUsu:SenUsu, tipUsu:TipUsu, statUsu:StatUsu, emaUsu:EmaUsu}, CodUsu):-
    %   Validação e transformação de atomo para número
    atom_number(TipUsu, TipUsuValidado),
    atom_number(StatUsu, StatUsuValidado),

    integrante:atualiza(CodUsu, NomInt, NomUsu, SenUsu, TipUsuValidado, StatUsuValidado, EmaUsu)
    -> envia_tupla_integrante(CodUsu)
    ;  throw(http_reply(not_found(CodUsu))).    

envia_tupla_integrante(CodUsu):-
       integrante:integrante(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu)
    -> reply_json_dict( _{codUsu:CodUsu, nomInt:NomInt, nomUsu:NomUsu, senUsu:SenUsu, tipUsu:TipUsu, statUsu:StatUsu, emaUsu:EmaUsu} )
    ;  throw(http_reply(not_found(CodUsu))).

envia_tabela_integrante :-
    findall( _{codUsu:CodUsu, nomInt:NomInt, nomUsu:NomUsu, senUsu:SenUsu, tipUsu:TipUsu, statUsu:StatUsu, emaUsu:EmaUsu},
             integrante:integrante(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu),
             Tuplas ),
    reply_json_dict(Tuplas).    