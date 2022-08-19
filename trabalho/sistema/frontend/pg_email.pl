/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

:- use_module(elementos).

index_email(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Email')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \nav_inicial('navegacao-inicial'),
                \tabela_email,
                \titulo_pagina('Email'),
                \cadastro_botao('/email/cadastro'),
                \dados_individual_botao('/email/individual')
              ]) ]).

tabela_email -->
    html(div(class('container-fluid py-3'),
             [ \head_tabela('Email', '/email'),
               \tabelas_email
             ]
            )).

tabelas_email -->
    html(div(class('table-responsive-md'),
             table(class('table table-striped w-100 mb-3'),
                   [ \cabecalho_email,
                     tbody(\corpo_tabela_email)
                   ]))).

cabecalho_email -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'Ponto do sistema em que o e-mail será disparado'),
                    th([scope(col)], 'Relatório será enviado em anexo'),
                    th([scope(col)], 'Corpo da mensagem'),
                    th([scope(col)], 'Assunto do e-mail'),
                    th([scope(col)], 'Cópia do e-mail'),
                    th([scope(col)], 'Ações')
                  ]))).

corpo_tabela_email -->
    {
        findall( tr([th(scope(row), SeqReg), td(TipReg), td(Relat), td(EmalTxt), td(EmaAss), td(EmaCC), td(Action)]),
          linha_email(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC, Action),
        Linhas)
    },
    html(Linhas).

linha_email(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC, Action):-
    email:email(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC),
    acoes_email(SeqReg, Action).

acoes_email(SeqReg, Campo):-
    Campo = [ a([ class('text-success'), title('Alterar'),
                  href('/email/editar/~w' - SeqReg),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([ class('text-danger ms-1'), title('Excluir'),
                  href('/api/v1/email/~w' - SeqReg),
                  onClick("apagar( event, '/email' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].

/* Página de cadastro do email */
cadastro_email(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Criar email')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Criar email'),
                \form_email
              ]) ]).

form_email -->
    html(form([ id('email-form'),
                onsubmit("redirecionaResposta( event, '/email' )"),
                action('/api/v1/email/') ],
              [ \metodo_de_envio('POST'),
                \campo(tipReg, 'Ponto do sistema em que o e-mail será disparado', number),
                \campo(relat, 'Relatório será enviado em anexo', number),
                \campo(emalTxt, 'Corpo da mensagem', text),
                \campo(emaAss, 'Assunto do e-mail', text),
                \campo(emaCC, 'Cópia do e-mail', email),
                \enviar_ou_cancelar('/')
              ])).

/* Página para edição (alteração) de um integrante  */

editar_email(AtomId, _Pedido):-
    atom_number(AtomId, SeqReg),
    ( email:email(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar email')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar email'),
                \form_email(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC)
              ]) ])
    ; throw(http_reply(not_found(SeqReg)))
    ).


form_email(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC) -->
    html(form([ id('integrante-form'),
                onsubmit("redirecionaResposta( event, '/email' )"),
                action('/api/v1/email/~w' - SeqReg) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(seqReg, 'Id', text, SeqReg),
                \campo(tipReg, 'Ponto do sistema em que o e-mail será disparado', number, TipReg),
                \campo(relat, 'Relatório será enviado em anexo', number, Relat),
                \campo(emalTxt, 'Corpo da mensagem', text, EmalTxt),
                \campo(emaAss, 'Assunto do e-mail', text, EmaAss),
                \campo(emaCC, 'Cópia do e-mail', email, EmaCC),
                \enviar_ou_cancelar('/')
              ])).
