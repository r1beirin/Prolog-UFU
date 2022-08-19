/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

:- use_module(elementos).

index_pagamentos(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Pagamentos')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \nav_inicial('navegacao-inicial'),
                \tabela_pagamentos,
                \titulo_pagina('Pagamentos'),
                \cadastro_botao('/pagamentos/cadastro'),
                \dados_individual_botao('/pagamentos/individual')
              ]) ]).

tabela_pagamentos -->
    html(div(class('container-fluid py-3'),
             [ \head_tabela('Pagamentos', '/pagamentos'),
               \tabelas_pagamentos
             ]
            )).


tabelas_pagamentos -->
    html(div(class('table-responsive-md'),
             table(class('table table-striped w-100 mb-3'),
                   [ \cabecalho_pagamentos,
                     tbody(\corpo_tabela_pagamentos)
                   ]))).

cabecalho_pagamentos -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'Data do pagamento'),
                    th([scope(col)], 'Valor do pagamento'),
                    th([scope(col)], 'Observação'),
                    th([scope(col)], 'Tipo do pagamento'),
                    th([scope(col)], 'Código do administrador responsável pelo pagamento'),
                    th([scope(col)], 'Status do pagamento'),
                    th([scope(col)], 'Código do administrador responsável pelo cancelamento'),
                    th([scope(col)], 'Data do cancelamento'),
                    th([scope(col)], 'Data do registro do pagamento'),
                    th([scope(col)], 'Ações')
                  ]))).

corpo_tabela_pagamentos -->
    {
        findall( tr([th(scope(row), SeqPag), td(DatPag), td(VlrPag), td(ObsPag),  td(TipPag),  td(UsuPag),  td(StatPag), td(UsuCan), td(DatCan), td(DatCadPag), td(Action)]),
          linha_pagamentos(SeqPag, _NumPrc, _CodUsu, _CodEve, DatPag, VlrPag, ObsPag, TipPag, UsuPag, StatPag, UsuCan, DatCan, DatCadPag, Action),
          Linhas)
    },
    html(Linhas).

linha_pagamentos(SeqPag, NumPrc, CodUsu, CodEve, DatPag, VlrPag, ObsPag, TipPag, UsuPag, StatPag, UsuCan, DatCan, DatCadPag, Action):-
    pagamentos:pagamentos(SeqPag, NumPrc, CodUsu, CodEve, DatPag, VlrPag, ObsPag, TipPag, UsuPag, StatPag, UsuCan, DatCan, DatCadPag),
    acoes_pagamentos(SeqPag, Action).

acoes_pagamentos(SeqPag, Campo):-
    Campo = [ a([ class('text-success'), title('Alterar'),
                  href('/pagamentos/editar/~w' - SeqPag),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([ class('text-danger ms-1'), title('Excluir'),
                  href('/api/v1/pagamentos/~w' - SeqPag),
                  onClick("apagar( event, '/lancamentos' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].

/* Página de cadastro de pagamentos */
cadastro_pagamentos(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de pagamentos')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de pagamentos'),
                \form_pagamentos
              ]) ]).


form_pagamentos -->
    html(form([ id('pagamentos-form'),
                onsubmit("redirecionaResposta( event, '/pagamentos' )"),
                action('/api/v1/pagamentos/') ],
              [ \metodo_de_envio('POST'),
                \campo(codUsu, 'ID Integrante', text),
                \campo(codEve, 'ID Evento', text),
                \campo(numPrc, 'ID Lançamento', text),
                \campo(datPag, 'Data do pagamento', date),
                \campo(vlrPag, 'Valor do pagamento', number),
                \campo(obsPag, 'Observação', text),
                \campo(tipPag, 'Tipo do pagamento', number),
                \campo(usuPag, 'Código do administrador responsável pelo pagamento', number),
                \campo(statPag, 'Status do pagamento', number),
                \campo(usuCan, 'Código do administrador responsável pelo cancelamento', number),
                \campo(datCan, 'Data do cancelamento', date),
                \campo(datCadPag, 'Data do registro do pagamento', date),
                \enviar_ou_cancelar('/pagamentos')
              ])).

/* Página para edição (alteração) de um pagamento  */
editar_pagamentos(AtomId, _Pedido):-
    atom_number(AtomId, SeqPag),
    ( pagamentos:pagamentos(SeqPag, NumPrc, CodUsu, CodEve, DatPag, VlrPag, ObsPag, TipPag, UsuPag, StatPag, UsuCan, DatCan, DatCadPag)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar pagamento')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar pagamento'),
                \form_pagamentos(SeqPag, NumPrc, CodUsu, CodEve, DatPag, VlrPag, ObsPag, TipPag, UsuPag, StatPag, UsuCan, DatCan, DatCadPag)
              ]) ])
    ; throw(http_reply(not_found(SeqPag)))
    ).

form_pagamentos(SeqPag, NumPrc, CodUsu, CodEve, DatPag, VlrPag, ObsPag, TipPag, UsuPag, StatPag, UsuCan, DatCan, DatCadPag) -->
    html(form([ id('pagamentos-form'),
                onsubmit("redirecionaResposta( event, '/pagamentos' )"),
                action('/api/v1/pagamentos/~w' - SeqPag) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(codUsu, 'ID Integrante', text, CodUsu),
                \campo_nao_editavel(codEve, 'ID Evento', text, CodEve),
                \campo_nao_editavel(numPrc, 'ID Lançamento', text, NumPrc),
                \campo(datPag, 'Data do pagamento', date, DatPag),
                \campo(vlrPag, 'Valor do pagamento', number, VlrPag),
                \campo(obsPag, 'Observação', text, ObsPag),
                \campo(tipPag, 'Tipo do pagamento', number, TipPag),
                \campo(usuPag, 'Código do administrador responsável pelo pagamento', number, UsuPag),
                \campo(statPag, 'Status do pagamento', number, StatPag),
                \campo(usuCan, 'Código do administrador responsável pelo cancelamento', number, UsuCan),
                \campo(datCan, 'Data do cancelamento', date, DatCan),
                \campo(datCadPag, 'Data do registro do pagamento', date, DatCadPag),
                \enviar_ou_cancelar('/pagamentos')
              ])).
