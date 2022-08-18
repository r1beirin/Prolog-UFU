/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

index_email(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Email')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \nav_inicial('navegacao-inicial'),
                \tabela_email,
                \titulo_pagina('Email')
              ]) ]).

titulo_pagina(Title) -->
  html( div(class('text-center align-items-center w-100'),
            h1('display-3', Title))).

tabela_email -->
    html(div(class('container-fluid py-3'),
             [ \head_tabela('Email', '/email'),
               \tabela
             ]
            )).

head_tabela(Titulo, Link) -->
    html( div(class('d-flex'),
              [ div(class('me-auto p-2'), h2(b(Titulo))),
                div(class('p-2'),
                    a([ href(Link), class('btn btn-primary')],
                      'Novo'))
              ]) ).

tabela -->
    html(div(class('table-responsive-md'),
             table(class('table table-striped w-100 mb-3'),
                   [ \cabecalho,
                     tbody(\corpo_tabela)
                   ]))).

cabecalho -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'Identificador do email'),
                    th([scope(col)], 'Ponto do sistema em que o e-mail será disparado'),
                    th([scope(col)], 'Relatório será enviado em anexo'),
                    th([scope(col)], 'Corpo da mensagem'),
                    th([scope(col)], 'Assunto do e-mail'),
                    th([scope(col)], 'Cópia do e-mail'),
                    th([scope(col)], 'Ações')
                  ]))).

corpo_tabela -->
    {
        findall( tr([th(scope(row), SeqReg), td(TipReg), td(Relat), td(EmalTxt), td(EmaAss), td(EmaCC), td(Action)]),
          linha(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC, Action),
        Linhas)
    },
    html(Linhas).

linha(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC):-
    email:email(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC),
    acoes(SeqReg, Action).

acoes(SeqReg, Campo):-
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
                \campo(TipReg, 'Ponto do sistema em que o e-mail será disparado', text),
                \campo(Relat, 'Relatório será enviado em anexo', text),
                \campo(EmalTxt, 'Corpo da mensagem', text),
                \campo(EmaAss, 'Assunto do e-mail', text),
                \campo(EmaCC, 'Cópia do e-mail', email),
                \enviar_ou_cancelar('/')
              ])).         

enviar_ou_cancelar(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Enviar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Enviar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).

campo(Nome, Rotulo, Tipo) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label') ], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome)])
             ] )).

/* Página para edição (alteração) de um integrante  */

editar_email(AtomId, _Pedido):-
    atom_number(AtomId, CodUsu),
    ( integrante:integrante(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar email')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar email'),
                \form_email(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC)
              ]) ])
    ; throw(http_reply(not_found(CodUsu)))
    ).


form_email(SeqReg, TipReg, Relat, EmalTxt, EmaAss, EmaCC) -->
    html(form([ id('integrante-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/integrante/~w' - CodUsu) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(seqReg, 'Id', text, SeqReg),
                \campo(tipReg, 'Ponto do sistema em que o e-mail será disparado', text),
                \campo(relat, 'Relatório será enviado em anexo', text),
                \campo(emalTxt, 'Corpo da mensagem', text),
                \campo(emaAss, 'Assunto do e-mail', text),
                \campo(emaCC, 'Cópia do e-mail', email),
                \enviar_ou_cancelar('/')
              ])).


campo(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome), value(Valor)])
             ] )).

campo_nao_editavel(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3 w-25'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome),
                       % name(Nome),
                       value(Valor),
                       readonly ])
             ] )).

metodo_de_envio(Metodo) -->
    html(input([type(hidden), name('_método'), value(Metodo)])).
