/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

index_integrante(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Integrantes')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \nav_inicial('navegacao-inicial'),
                \tabela_integrante,
                \titulo_pagina('Integrantes'),
                \cadastro_botao('/integrante/cadastro'),
                \dados_individual_botao('/integrante/individual')
              ]) ]).

cadastro_botao(Link) -->
    html(div(class('py-4 row'), a([ class(['btn', 'btn-primary']),href(Link)],'Cadastrar') )).

dados_individual_botao(Link) -->
    html(div(class('row'), a([ class(['btn', 'btn-secondary']),href(Link)],'Ler dados individuais') )).

titulo_pagina(Title) -->
    html( div(class('text-center align-items-center w-100'),
              h1('display-3', Title))).

tabela_integrante -->
    html(div(class('container-fluid py-3'),
             [ \head_tabela('Integrante', '/integrante'),
               \tabelas_integrante
             ]
            )).

head_tabela(Titulo, Link) -->
    html( div(class('d-flex'),
              [ div(class('me-auto p-2'), h2(b(Titulo))),
                div(class('p-2'),
                    a([ href(Link), class('btn btn-primary')],
                      'Novo'))
              ]) ).

tabelas_integrante -->
    html(div(class('table-responsive-md'),
             table(class('table table-striped w-100 mb-3'),
                   [ \cabecalho_integrante,
                     tbody(\corpo_tabela_integrante)
                   ]))).

cabecalho_integrante -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'Nome completo do integrante'),
                    th([scope(col)], 'Nome do usuário'),
                    th([scope(col)], 'Senha do usuário'),
                    th([scope(col)], 'Tipo do usuário'),
                    th([scope(col)], 'Status do usuário'),
                    th([scope(col)], 'Email do usuário'),
                    th([scope(col)], 'Ações')
                  ]))).

corpo_tabela_integrante -->
    {
        findall( tr([th(scope(row), CodUsu), td(NomInt), td(NomUsu), td(SenUsu), td(TipUsu), td(StatUsu), td(EmaUsu), td(Action)]),
          linha_integrante(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu, Action),
          Linhas)
    },
    html(Linhas).

linha_integrante(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu, Action):-
    integrante:integrante(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu),
    acoes_integrante(CodUsu, Action).

acoes_integrante(CodUsu, Campo):-
    Campo = [ a([ class('text-success'), title('Alterar'),
                  href('/integrante/editar/~w' - CodUsu),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([ class('text-danger ms-1'), title('Excluir'),
                  href('/api/v1/integrante/~w' - CodUsu),
                  onClick("apagar( event, '/integrante' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].

/* Página de cadastro de integrante */
cadastro_integrante(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de integrante')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de integrante'),
                \form_integrante
              ]) ]).

form_integrante -->
    html(form([ id('integrante-form'),
                onsubmit("redirecionaResposta( event, '/integrante' )"),
                action('/api/v1/integrante/') ],
              [ \metodo_de_envio('POST'),
                \campo(nomInt, 'Nome completo', text),
                \campo(nomUsu, 'Nome do usuário', text),
                \campo(senUsu, 'Senha do usuário', password),
                \campo(tipUsu, 'Tipo do usuário', number),
                \campo(statUsu, 'Status do usuário', text),
                \campo(emaUsu, 'Email do usuário', email),
                \enviar_ou_cancelar('/integrante')
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
                       id(Nome), name(Nome), step('any')])
             ] )).

/* Página para edição (alteração) de um integrante  */
editar_integrante(AtomId, _Pedido):-
    atom_number(AtomId, CodUsu),
    ( integrante:integrante(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar integrante')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar integrantes'),
                \form_integrante(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu)
              ]) ])
    ; throw(http_reply(not_found(CodUsu)))
    ).


form_integrante(CodUsu, NomInt, NomUsu, SenUsu, TipUsu, StatUsu, EmaUsu) -->
    html(form([ id('integrante-form'),
                onsubmit("redirecionaResposta( event, '/integrante' )"),
                action('/api/v1/integrante/~w' - CodUsu) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(codUsu, 'Id', text, CodUsu),
                \campo(nomInt, 'Nome completo', text, NomInt),
                \campo(nomUsu, 'Nome do usuário', text, NomUsu),
                \campo(senUsu, 'Senha do usuário', text, SenUsu),
                \campo(tipUsu, 'Tipo do usuário', text, TipUsu),
                \campo(statUsu, 'Status do usuário', text, StatUsu),
                \campo(emaUsu, 'Email do usuário', text, EmaUsu),
                \enviar_ou_cancelar('/integrante')
              ])).


campo(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome), value(Valor), step('0.01')])
             ] )).

campo_nao_editavel(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3 w-100'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome), value(Valor),
                       readonly ])
             ] )).

metodo_de_envio(Metodo) -->
    html(input([type(hidden), name('_método'), value(Metodo)])).
