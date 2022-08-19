:- module(
  pagamentos,
  [ carrega_tab/1,
    pagamentos/13,
    insere/13,
    remove/1,
    atualiza/13  ]
).

:- use_module(library(persistency)).
:- use_module(eventos, []).
:- use_module(integrante, []).
:- use_module(lancamentos, []).
:- use_module(chave, []).

:- persistent
    pagamentos(
        seqPag: positive_integer,     % Primary Key
        numPrc: positive_integer,     % Foreign Key - tabela Lancamentos
        codUsu: positive_integer,     % Foreign Key - tabela Integrante
        codEve: positive_integer,     % Foreign Key - tabela Eventos
        datPag: text,                % Armazena a data do pagamento.
        vlrPag: float,                % Armazena o valor pago.
        obsPag: text,                 % Armazena uma observação para o pagamento. - Opcional
        tipPag: positive_integer,     % Armazena o tipo do pagamento.
        usuPag: positive_integer,     % Armazena o código do usuário administrador que registrou o pagamento
        statPag: positive_integer,    % Armazena um verificador 1 caso o pagamento estiver ok e 2 se estiver cancelado.
        usuCan: positive_integer,     % Armazena o código do usuário administrador que realizou o cancelamento do lançamento. - Opcional
        datCan: text,                % Armazena a data e hora do cancelamento do pagamento. - Opcional
        datCadPag: text              % Armazena a data em que o pagamento foi registrado no sistema.
    ).

%:- initialization(db_attach('tbl_pagamentos.pl', [])).
:- initialization(at_halt(db_sync(gc(always)))).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).

insere(SeqPag, NumPrc, CodUsu, CodEve, DatPag, VlrPag, ObsPag, TipPag, UsuPag, StatPag, UsuCan, DatCan, DatCadPag) :-
  integrante:integrante(CodUsu, _, _, _, _, _, _),
  eventos:eventos(CodEve, _, _, _, _),
  lancamentos:lancamentos(NumPrc, _, _, _, _, _, _, _, _, _, _),
  chave:pk(pagamentos, SeqPag),
  with_mutex(pagamentos,
              assert_pagamentos(SeqPag, NumPrc, CodUsu, CodEve, DatPag, VlrPag, ObsPag, TipPag, UsuPag, StatPag, UsuCan, DatCan, DatCadPag)
              ).

remove(SeqPag) :-
  with_mutex(pagamentos,
              retract_pagamentos(SeqPag, _NumPrc, _CodUsu, _CodEve, _DatPag, _VlrPag, _ObsPag, _TipPag, _UsuPag, _StatPag, _UsuCan, _DatCan, _DatCadPag)
                ).

atualiza(SeqPag, NumPrc, CodUsu, CodEve, DatPag, VlrPag, ObsPag, TipPag, UsuPag, StatPag, UsuCan, DatCan, DatCadPag) :-
    pagamentos(SeqPag, _, _, _, _, _, _, _, _, _, _, _, _),
    integrante:integrante(CodUsu, _, _, _, _, _, _),
    eventos:eventos(CodEve, _, _, _, _),
    lancamentos:lancamentos(NumPrc, _, _, _, _, _, _, _, _, _, _),
    with_mutex(pagamentos,
                (
                assert_pagamentos(SeqPag, NumPrc, CodUsu, CodEve, DatPag, VlrPag, ObsPag, TipPag, UsuPag, StatPag, UsuCan, DatCan, DatCadPag),
                retract_pagamentos(SeqPag, _NumPrc, _CodUsu, _CodEve, _DatPag, _VlrPag, _ObsPag, _TipPag, _UsuPag, _StatPag, _UsuCan, _DatCan, _DatCadPag))
                ).
