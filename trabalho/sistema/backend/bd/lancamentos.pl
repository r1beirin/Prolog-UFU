:- module(
  lancamentos, 
  [ lancamentos/11 ]
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
      vlrPrc: float,              % Armazena o valor da parcela.
      datLan: float,              % Armazena a data e hora em que o lançamento foi gerado.
      vctPrc: float,              % Armazena a data de vencimento da parcela
      statPrc: positive_integer,  % Armazena um verificador 0 caso o lançamento estiver quitado, 1 se estiver em aberto e 2 se estiver cancelado.
      vlrAbe: float,              % Armazena o valor em aberto da parcela.
      usuPrc: positive_integer,   % Armazena o código do usuário administrador que gerou este lançamento
      datCan: float,              % Armazena a data e a hora do cancelamento do lançamento  - Opcional
      usuCan: positive_integer    % Armazena o código do usuário administrador que realizou o cancelamento do lançamento. - Opcional
    ).

:- initialization(db_attach('tbl_lancamentos.pl', [])).
:- initialization(at_halt(db_sync(gc(always)))).

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
  %lancamentos(NumPrc, CodUsu, CodEve, _, _, _, _, _, _, _, _),
  with_mutex(
    lancamentos,
    retract_lancamentos(NumPrc, _, _,  _,  _, _, _, _, _, _, _)
  ).

atualiza(NumPrc, CodUsu, CodEve, VlrPrc, DatLan, VctPrc, StatPrc, VlrAbe, UsuPrc, DatCan, UsuCan) :- 
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