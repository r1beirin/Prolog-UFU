/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

index_lancamentos(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Lançamentos')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \nav_inicial('navegacao-inicial'),
                \tabela_lancamentos,
                \titulo_pagina('Lançamentos'),
                \cadastro_botao('/lancamentos/cadastro'),
                \dados_individual_botao('/lancamentos/individual')
              ]) ]).

tabela_lancamentos -->
    html(div(class('container-fluid py-3'),
             [ \head_tabela('Lançamentos', '/lancamentos'),
               \tabelas_lancamentos
             ]
            )).


tabelas_lancamentos -->
    html(div(class('table-responsive-md'),
             table(class('table table-striped w-100 mb-3'),
                   [ \cabecalho_lancamentos,
                     tbody(\corpo_tabela_lancamentos)
                   ]))).

cabecalho_lancamentos -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'ID Integrante'),
                    th([scope(col)], 'ID Evento'),
                    th([scope(col)], 'Valor da parcela'),
                    th([scope(col)], 'Data do lançamento'),
                    th([scope(col)], 'Data de vencimento da parcela'),
                    th([scope(col)], 'Status do lançamento'),
                    th([scope(col)], 'Valor aberto da parcela'),
                    th([scope(col)], 'Administrador responsável pelo lançamento'),
                    th([scope(col)], 'Data do cancelamento'),
                    th([scope(col)], 'Administrador responsável pelo cancelamento'),
                    th([scope(col)], 'Ações')
                  ]))).

corpo_tabela_lancamentos -->
    {
        findall( tr([th(scope(row), NumPrc), td(CodUsu), td(CodEve), td(VlrPrc), td(DatLan), td(VctPrc), td(StatPrc),  td(VlrAbe),  td(UsuPrc),  td(DatCan), td(UsuCan), td(Action)]),
          linha_lancamentos(NumPrc, CodUsu, CodEve, VlrPrc, DatLan, VctPrc, StatPrc, VlrAbe, UsuPrc, DatCan, UsuCan, Action),
          Linhas)
    },
    html(Linhas).

linha_lancamentos(NumPrc, CodUsu, CodEve, VlrPrc, DatLan, VctPrc, StatPrc, VlrAbe, UsuPrc, DatCan, UsuCan, Action):-
    lancamentos:lancamentos(NumPrc, CodUsu, CodEve, VlrPrc, DatLan, VctPrc, StatPrc, VlrAbe, UsuPrc, DatCan, UsuCan),
    acoes_lancamentos(NumPrc, Action).

acoes_lancamentos(NumPrc, Campo):-
    Campo = [ a([ class('text-success'), title('Alterar'),
                  href('/lancamentos/editar/~w' - NumPrc),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([ class('text-danger ms-1'), title('Excluir'),
                  href('/api/v1/lancamentos/~w' - NumPrc),
                  onClick("apagar( event, '/lancamentos' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].

/* Página de cadastro de lançamentos */
cadastro_lancamentos(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de lançamentos')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de lançamentos'),
                \form_lancamentos
              ]) ]).

form_lancamentos -->
    html(form([ id('lancamentos-form'),
                onsubmit("redirecionaResposta( event, '/lancamentos' )"),
                action('/api/v1/lancamentos/') ],
              [ \metodo_de_envio('POST'),
                \campo(codUsu, 'ID Integrante', text),
                \campo(codEve, 'ID Evento', text),
                \campo(vlrPrc, 'Valor da parcela', number),
                \campo(datLan, 'Data do lançamento', date),
                \campo(vctPrc, 'Data de vencimento da parcela', date),
                \campo(statPrc, 'Status do lançamento', number),
                \campo(vlrAbe, 'Valor aberto da parcela', number),
                \campo(usuPrc, 'Código do administrador responsável pelo lançamento', number),
                \campo(datCan, 'Data do cancelamento', date),
                \campo(usuCan, 'Código do administrador responsável pelo cancelamento', number),
                \enviar_ou_cancelar('/lancamentos')
              ])).

/* Página para edição (alteração) de um lançamento  */
editar_lancamentos(AtomId, _Pedido):-
    atom_number(AtomId, NumPrc),
    ( lancamentos:lancamentos(NumPrc, CodUsu, CodEve, VlrPrc, DatLan, VctPrc, StatPrc, VlrAbe, UsuPrc, DatCan, UsuCan)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar lançamento')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar lançamento'),
                \form_lancamentos(NumPrc, CodUsu, CodEve, VlrPrc, DatLan, VctPrc, StatPrc, VlrAbe, UsuPrc, DatCan, UsuCan)
              ]) ])
    ; throw(http_reply(not_found(NumPrc)))
    ).


form_lancamentos(NumPrc, CodUsu, CodEve, VlrPrc, DatLan, VctPrc, StatPrc, VlrAbe, UsuPrc, DatCan, UsuCan) -->
    html(form([ id('lancamentos-form'),
                onsubmit("redirecionaResposta( event, '/lancamentos' )"),
                action('/api/v1/lancamentos/~w' - NumPrc) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(codUsu, 'ID Integrante', text, CodUsu),
                \campo_nao_editavel(codEve, 'ID Evento', text, CodEve),
                \campo(vlrPrc, 'Valor da parcela', text, VlrPrc),
                \campo(datLan, 'Data do lançamento', date, DatLan),
                \campo(vctPrc, 'Data de vencimento da parcela', date, VctPrc),
                \campo(statPrc, 'Status do lançamento', number, StatPrc),
                \campo(vlrAbe, 'Valor aberto da parcela', text, VlrAbe),
                \campo(usuPrc, 'Código do administrador responsável pelo lançamento', number, UsuPrc),
                \campo(datCan, 'Data do cancelamento', date, DatCan),
                \campo(usuCan, 'Código do administrador responsável pelo cancelamento', number, UsuCan),
                \enviar_ou_cancelar('/lancamentos')
              ])).
