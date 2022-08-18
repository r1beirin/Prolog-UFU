/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).

:- use_module(bd(complemento), []).

/*
   GET api/v1/complemento/
   Retorna uma lista com todos os complementos.
*/
complemento(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/complemento/Id
   Retorna o `complemento` com Id 1 ou erro 404 caso o `complemento` não
   seja encontrado.
*/
complemento(get, AtomId, _Pedido):-
    atom_number(AtomId, CodUsu),
    !,
    envia_tupla(CodUsu).

/*
   POST api/v1/complemento
   Adiciona um novo complemento. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
complemento(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).    

/*
  PUT api/v1/complemento/Id
  Atualiza o complemento com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
complemento(put, AtomId, Pedido):-
    atom_number(AtomId, CodUsu),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, CodUsu).

/*
   DELETE api/v1/complemento/Id
   Apaga o complemento com o Id informado
*/
complemento(delete, AtomId, _Pedido):-
    atom_number(AtomId, CodUsu),
    !,
    complemento:remove(CodUsu),
    throw(http_reply(no_content)).    

/* 
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
complemento(Metodo, CodUsu, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, CodUsu))).

insere_tupla( _{ apeInt:ApeInt, datNas:DatNas, numCel:NumCel, numTel:NumTel, endInt:EndInt, baiInt:BaiInt, cidInt:CidInt, cepInt:CepInt, ufInt:UFInt}):-
    complemento:insere(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt)
    -> envia_tupla(CodUsu)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{ apeInt:ApeInt, datNas:DatNas, numCel:NumCel, numTel:NumTel, endInt:EndInt, baiInt:BaiInt, cidInt:CidInt, cepInt:CepInt, ufInt:UFInt}, CodUsu):-
    complemento:atualiza(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt)
    -> envia_tupla(CodUsu)
    ;  throw(http_reply(not_found(CodUsu))).    

envia_tupla(CodUsu):-
       complemento:complemento(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt)
    -> reply_json_dict( _{codUsu:CodUsu, apeInt:ApeInt, datNas:DatNas, numCel:NumCel, numTel:NumTel, endInt:EndInt, baiInt:BaiInt, cidInt:CidInt, cepInt:CepInt, ufInt:UFInt} )
    ;  throw(http_reply(not_found(CodUsu))).

envia_tabela :-
    findall( _{codUsu:CodUsu, apeInt:ApeInt, datNas:DatNas, numCel:NumCel, numTel:NumTel, endInt:EndInt, baiInt:BaiInt, cidInt:CidInt, cepInt:CepInt, ufInt:UFInt},
             complemento:complemento(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt),
             Tuplas ),
    reply_json_dict(Tuplas).    