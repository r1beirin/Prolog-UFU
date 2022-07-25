:- module(
    integrante,
    [ integrante/7 ]).

:- use_module(library(persistency)).

:- persistent
    integrante(codUsu:positive_integer,     %   Primary Key
                nomInt:string,              %   Armazena o nome completo do Integrante
                nomUsu:string,              %   Armazena o nome do usuário.
                senUsu:string,              %   Armazena a senha do usuário.
                tipUsu:nonneg,    %   Armazena um verificador 0 caso for usuário padrão e 1 caso for um usuário administrador.
                statUsu:nonneg,   %   Armazena um verificador 0 caso a conta estiver liberada e 1 caso estiver bloqueada. 
                emaUsu:string).             %   Armazena o endereço de e-mail do integrante

:- initialization(db_attach('tbl_integrante.pl', [])).

insere(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu) :-
    with_mutex(integrante,
                assert_integrante(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu)
                ).

remove(CodUsu) :-
    with_mutex(integrante,
                retract_integrante(CodUsu, _NomInt, _NomUsu, _SenUsu, _TipUsu, _StatUsu, _EmaUsu)
                ).

atualiza(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu) :-
    with_mutex(integrante,
                (retractall_integrante(CodUsu, _NomInt, _NomUsu, _SenUsu, _TipUsu, _StatUsu, _EmaUsu),
                assert_integrante(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu))
                ).

sincroniza :-
    db_sync(gc(always)).