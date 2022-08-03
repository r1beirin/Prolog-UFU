:- module(
  eventos, 
  [ eventos/5 ]
).

:- use_module(library(persistency)).
:- use_module(chave, []).

:- persistent
    eventos(
      codEve: positive_integer, % Chave primária da tabela eventos que identifica o evento.
      desEve: text,             % Armazena a descrição do evento.
      vlrPrc: float,            % Armazena o valor de cada parcela.
      prmVct: float,            % Armazena o primeiro vencimento da parcela.
      qtdPrc: positive_integer  % Armazena a quantidade de parcelas do evento.
    ).

:- initialization(db_attach('tbl_eventos.pl', [])).
:- initialization(at_halt(db_sync(gc(always)))).

insere(CodEve, DesEve, VlrPrc, PrmVct, QtdPrc) :- 
  chave:pk(eventos, CodEve),
  with_mutex(
    eventos, 
    assert_eventos(
      CodEve, 
      DesEve, 
      VlrPrc, 
      PrmVct, 
      QtdPrc
  )).

remove(CodEve) :-
  with_mutex(
    eventos,
    retract_eventos(CodEve, _, _,  _,  _)
  ).

atualiza(CodEve, DesEve, VlrPrc, PrmVct, QtdPrc) :- 
  with_mutex(
    eventos,
    (
      retract_eventos(CodEve, _, _, _, _),
      assert_eventos(
        CodEve, 
        DesEve, 
        VlrPrc, 
        PrmVct, 
        QtdPrc
      )
    )
  ).