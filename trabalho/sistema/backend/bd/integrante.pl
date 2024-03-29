:- module(
    integrante,
    [   carrega_tab/1,
        integrante/7, 
        insere/7,
        remove/1,
        atualiza/7 ]).

:- use_module(library(persistency)).
:- use_module(chave, []).   %   Geração de chaves primárias

:- persistent
    integrante(codUsu:positive_integer, %   Primary Key
                nomInt:text,            %   Armazena o nome completo do Integrante
                nomUsu:text,            %   Armazena o nome do usuário.
                senUsu:text,            %   Armazena a senha do usuário.
                tipUsu:nonneg,          %   Armazena um verificador 0 caso for usuário padrão e 1 caso for um usuário administrador.
                statUsu:nonneg,         %   Armazena um verificador 0 caso a conta estiver liberada e 1 caso estiver bloqueada. 
                emaUsu:text).           %   Armazena o endereço de e-mail do integrante

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).

insere(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu) :-
    chave:pk(integrante, CodUsu),
    with_mutex(integrante,
                assert_integrante(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu)
                ).

remove(CodUsu) :-
    with_mutex(integrante,
                retract_integrante(CodUsu, _NomInt, _NomUsu, _SenUsu, _TipUsu, _StatUsu, _EmaUsu)
                ).

atualiza(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu) :-
    integrante(CodUsu, _, _, _, _, _, _),
    with_mutex(integrante,
                (retract_integrante(CodUsu, _NomInt, _NomUsu, _SenUsu, _TipUsu, _StatUsu, _EmaUsu),
                assert_integrante(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu))
                ).