/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

index_eventos(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Eventos')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \nav_inicial('navegacao-inicial'),
                \tabela_eventos,
                \titulo_pagina('Eventos'),
                \cadastro_botao('/eventos/cadastro'),
                \dados_individual_botao('/eventos/individual')
              ]) ]).


tabela_eventos -->
    html(div(class('container-fluid py-3'),
             [ \head_tabela('Eventos', '/eventos'),
               \tabelas_eventos
             ]
            )).

tabelas_eventos -->
  html(div(class('table-responsive-md'),
           table(class('table table-striped w-100 mb-3'),
                 [ \cabecalho_eventos,
                   tbody(\corpo_tabela_eventos)
                 ]))).

cabecalho_eventos -->
  html(thead(tr([ th([scope(col)], '#'),
                  th([scope(col)], 'Descrição do evento'),
                  th([scope(col)], 'Valor da parcela'),
                  th([scope(col)], 'Vencimento da primeira parcela'),
                  th([scope(col)], 'Quantidade de parcelas'),
                  th([scope(col)], 'Ações')
                ]))).

corpo_tabela_eventos -->
  {
      findall( tr([th(scope(row), CodEve), td(DesEve), td(VlrPrc), td(PrmVct), td(QtdPrc), td(Action)]),
        linha_eventos(CodEve, DesEve, VlrPrc, PrmVct, QtdPrc, Action),
        Linhas)
  },
  html(Linhas).

linha_eventos(CodEve, DesEve, VlrPrc, PrmVct, QtdPrc, Action):-
  eventos:eventos(CodEve, DesEve, VlrPrc, PrmVct, QtdPrc),
  acoes_eventos(CodEve, Action).

acoes_eventos(CodEve, Campo):-
  Campo = [ a([ class('text-success'), title('Alterar'),
                href('/eventos/editar/~w' - CodEve),
                'data-toggle'(tooltip)],
              [ \lapis ]),
            a([ class('text-danger ms-1'), title('Excluir'),
                href('/api/v1/eventos/~w' - CodEve),
                onClick("apagar( event, '/eventos' )"),
                'data-toggle'(tooltip)],
              [ \lixeira ])
          ].

/* Página de cadastro de eventos */
cadastro_eventos(_Pedido):-
  reply_html_page(
      boot5rest,
      [ title('Cadastro de eventos')],
      [ div(class(container),
            [ \html_requires(js('sistema.js')),
              h1('Cadastro de eventos'),
              \form_eventos
            ]) ]).

form_eventos -->
  html(form([ id('eventos-form'),
              onsubmit("redirecionaResposta( event, '/eventos' )"),
              action('/api/v1/eventos/') ],
            [ \metodo_de_envio('POST'),
              \campo(desEve, 'Descrição do evento', text),
              \campo(vlrPrc, 'Valor da parcela', number),
              \campo(prmVct, 'Vencimento da primeira parcela', date),
              \campo(qtdPrc, 'Quantidade de parcelas', text),
              \enviar_ou_cancelar('/eventos')
            ])).

/* Página para edição (alteração) de um evento  */
editar_eventos(AtomId, _Pedido):-
   atom_number(AtomId, CodEve),
   ( eventos:eventos(CodEve, DesEve, VlrPrc, PrmVct, QtdPrc)
   ->
   reply_html_page(
       boot5rest,
       [ title('Editar eventos')],
       [ div(class(container),
             [ \html_requires(js('sistema.js')),
               h1('Editar eventos'),
               \form_eventos(CodEve, DesEve, VlrPrc, PrmVct, QtdPrc)
             ]) ])
   ; throw(http_reply(not_found(CodEve)))
   ).


form_eventos(CodEve, DesEve, VlrPrc, PrmVct, QtdPrc) -->
   html(form([ id('eventos-form'),
               onsubmit("redirecionaResposta( event, '/eventos' )"),
               action('/api/v1/eventos/~w' - CodEve) ],
             [ \metodo_de_envio('PUT'),
               \campo_nao_editavel(codEve, 'Id', text, CodEve),
               \campo(desEve, 'Descrição do evento', text, DesEve),
               \campo(vlrPrc, 'Valor da parcela', number, VlrPrc),
               \campo(prmVct, 'Vencimento da primeira parcela', date, PrmVct),
               \campo(qtdPrc, 'Quantidade de parcelas', text, QtdPrc),
               \enviar_ou_cancelar('/eventos')
             ])).
