:- module(
  email, 
  [ carrega_tab/1,
    email/6, 
    insere/6,
    remove/1,
    atualiza/6 ]
).

:- use_module(library(persistency)).
:- use_module(chave, []).

:- persistent
    email(
      seqReg: positive_integer, % Primary Key
      tipReg: positive_integer, % Armazena o ponto do sistema em que o e-mail será disparado
      relat: positive_integer,  % Armazena qual relatório será enviado em anexo.
      emalTxt: text,            % Armazena o corpo da mensagem.
      emaAss: text,             % Armazena o assunto do e-mail.
      emaCC: text               % Armazena o e-mail que deverá ser adicionado como cópia no e-mail. - Opcional
    ).

% :- initialization(db_attach('tbl_email.pl', [])).
:- initialization(at_halt(db_sync(gc(always)))).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).

insere(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC) :- 
  chave:pk(email, SeqReg),
  with_mutex(
    email, 
    assert_email(
      SeqReg, 
      TipReg, 
      Relat, 
      EmalTxt, 
      EmaAss, 
      EmaCC
  )).

remove(SeqReg) :-
  with_mutex(
    email,
    retract_email(SeqReg, _, _,  _,  _, _)
  ).

atualiza(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC) :- 
  email(SeqReg, _, _, _, _, _),
  with_mutex(
    email,
    (
      retract_email(SeqReg, _, _, _, _, _),
      assert_email(
        SeqReg, 
        TipReg, 
        Relat, 
        EmalTxt, 
        EmaAss, 
        EmaCC
      )
    )
  ).