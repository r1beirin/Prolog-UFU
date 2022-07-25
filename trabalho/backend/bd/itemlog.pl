:- module(
    itemlog, 
    [ itemlog/5 ]).

:- use_module(library(persistency)).

:- persistent
    itemlog(seqLog:positive_integer,    %   Primary Key
            ocorrencia:string,          %   Armazena a ocorrência do log.
            datReg:string,              %   Armazena a data e hora do log.
            usuAdm:positive_integer,    %   Armazena o código do usuário administrador que gerou o log.
            codUsu:positive_integer).   %   Extern Key

:- initialization(db_attach('tbl_itemlog.pl', [])).

insere(SeqLog, Ocorrencia, DataReg, UsuAdm, CodUsu) :-
    with_mutex(itemlog,
                assert_itemlog(SeqLog, Ocorrencia, DataReg, UsuAdm, CodUsu)
                ).

remove(SeqLog) :-
    with_mutex(itemlog,
                retract_itemlog(SeqLog, _Ocorrencia, _DataReg, _UsuAdm, _CodUsu)
                ).

atualiza(SeqLog, Ocorrencia, DataReg, UsuAdm, CodUsu) :-
    with_mutex(itemlog,
                (retractall_itemlog(SeqLog, _Ocorrencia, _DataReg, _UsuAdm, _CodUsu),
                assert_itemlog(SeqLog, Ocorrencia, DataReg, UsuAdm, CodUsu))
                ).

sincroniza :-
    db_sync(gc(always)).