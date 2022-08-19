:- module(
  lancamentos, 
  [ carrega_tab/1,
    lancamentos/11,
    insere/11,
    remove/1,
    atualiza/11  ]
).

:- use_module(library(persistency)).
:- use_module(eventos, []).
:- use_module(integrante, []).
:- use_module(chave, []).

:- persistent
    lancamentos(
      numPrc: positive_integer,   % Primary Key
      codUsu: positive_integer,   % Foreign Key - tabela Integrante
      codEve: positive_integer,   % Foreign Key - tabela Eventos
      vlrPrc: positive_integer,              % Armazena o valor da parcela.
      datLan: text,              % Armazena a data e hora em que o lançamento foi gerado.
      vctPrc: text,              % Armazena a data de vencimento da parcela
      statPrc: positive_integer,  % Armazena um verificador 0 caso o lançamento estiver quitado, 1 se estiver em aberto e 2 se estiver cancelado.
      vlrAbe: positive_integer,              % Armazena o valor em aberto da parcela.
      usuPrc: positive_integer,   % Armazena o código do usuário administrador que gerou este lançamento
      datCan: text,              % Armazena a data e a hora do cancelamento do lançamento  - Opcional
      usuCan: positive_integer    % Armazena o código do usuário administrador que realizou o cancelamento do lançamento. - Opcional
    ).

%:- initialization(db_attach('tbl_lancamentos.pl', [])).
:- initialization(at_halt(db_sync(gc(always)))).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).

insere(NumPrc, CodUsu, CodEve, VlrPrc, DatLan, VctPrc, StatPrc, VlrAbe, UsuPrc, DatCan, UsuCan) :- 
  integrante:integrante(CodUsu, _, _, _, _, _, _),
  eventos:eventos(CodEve, _, _, _, _),
  chave:pk(lancamentos, NumPrc),
  with_mutex(
    lancamentos, 
    assert_lancamentos(
      NumPrc, 
      CodUsu, 
      CodEve, 
      VlrPrc, 
      DatLan,
      VctPrc,
      StatPrc,
      VlrAbe,
      UsuPrc,
      DatCan,
      UsuCan
  )).


remove(NumPrc) :-
  with_mutex(
    lancamentos,
    retract_lancamentos(NumPrc, _, _,  _,  _, _, _, _, _, _, _)
  ).

atualiza(NumPrc, CodUsu, CodEve, VlrPrc, DatLan, VctPrc, StatPrc, VlrAbe, UsuPrc, DatCan, UsuCan) :- 
  lancamentos(NumPrc, _, _, _, _, _, _, _, _, _, _),
  integrante:integrante(CodUsu, _, _, _, _, _, _),
  eventos:eventos(CodEve, _, _, _, _),
  with_mutex(
    lancamentos,
    (
      retract_lancamentos(NumPrc, _, _, _, _, _, _, _, _, _, _),
      assert_lancamentos(
        NumPrc, 
        CodUsu, 
        CodEve, 
        VlrPrc, 
        DatLan,
        VctPrc,
        StatPrc,
        VlrAbe,
        UsuPrc,
        DatCan,
        UsuCan
      )
    )
  ).