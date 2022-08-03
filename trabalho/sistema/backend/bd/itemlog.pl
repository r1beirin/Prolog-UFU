:- module(
    itemlog, 
    [ itemlog/5 ]).

:- use_module(library(persistency)).
:- use_module(chave, []).   %   Geração de chaves primárias
:- use_module(integrante, []).

:- persistent
    itemlog(seqLog:positive_integer,    %   Primary Key
            ocorrencia:text,            %   Armazena a ocorrência do log.
            datReg:float,               %   Armazena a data e hora do log.
            usuAdm:positive_integer,    %   Armazena o código do usuário administrador que gerou o log.
            codUsu:positive_integer).   %   Foreign Key - tabela Integrante

:- initialization(db_attach('tbl_itemlog.pl', [])).
:- initialization( at_halt(db_sync(gc(always))) ).

insere(SeqLog, Ocorrencia, DataReg, UsuAdm, CodUsu) :-
    integrante:integrante(CodUsu, _, _, _, _, _, _),
    chave:pk(itemlog, SeqLog),
    with_mutex(itemlog,
                assert_itemlog(SeqLog, Ocorrencia, DataReg, UsuAdm, CodUsu)
                ).

remove(SeqLog) :-
    with_mutex(itemlog,
                retract_itemlog(SeqLog, _Ocorrencia, _DataReg, _UsuAdm, _CodUsu)
                ).

atualiza(SeqLog, Ocorrencia, DataReg, UsuAdm, CodUsu) :-
    integrante:integrante(CodUsu, _, _, _, _, _, _),
    with_mutex(itemlog,
                (retractall_itemlog(SeqLog, _Ocorrencia, _DataReg, _UsuAdm, _CodUsu),
                assert_itemlog(SeqLog, Ocorrencia, DataReg, UsuAdm, CodUsu))
                ).