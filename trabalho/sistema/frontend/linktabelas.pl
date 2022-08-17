/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

linktabelas(_):-
    %boot5rest,
    reply_html_page(
        [ title('Sistema de controle de receitas aplicado à equipe Amigos do Barney da gincana cidade de Blumenau')],
        [ div(class(container),
              [ \html_requires(css('bootstrap.min.css')),
                \html_requires(js('bootstrap.bundle.min.js')),
                \nav_inicial('navegacao-inicial'),
                \propaganda_link_tabelas
              ]) ]).

propaganda_link_tabelas -->
    html(div([ class='container-fluid' ],
             div([ id='propaganda',
                   class='py-5 text-center block block-1'],
                 [ div(class('py-5'), \cartao),
                   h1(class('py-5'), 'Tabelas'),
                    table(class('table table-striped table-responsive-md table-bordered'),
                        [ \table_header_link_tabelas,
                        tbody(\table_body_link_tabela_integrante),
                        tbody(\table_body_link_tabela_complemento),
                        tbody(\table_body_link_tabela_itemlog),
                        tbody(\table_body_link_tabela_evento),
                        tbody(\table_body_link_tabela_lancamento),
                        tbody(\table_body_link_tabela_pagamento),
                        tbody(\table_body_link_tabela_email)
                        ])
                  ]))).

table_header_link_tabelas -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'Nome da tabela'),
                    th([scope(col)], 'Informações'),
                    th([scope(col)], '#')
                  ]))).

table_body_link_tabela_integrante -->
    html(tr([th(scope(row), '1'), td('Integrante'), td('Tabela responsável pelo armazenamento de dados dos usuários do sistema.'), td(p(a(href('/integrante'), 'Acessar')))])).
table_body_link_tabela_complemento -->
    html(tr([th(scope(row), '2'), td('Complemento'), td('Tabela responsável pelo armazenamento dos dados complementares do integrante..'), td(p(a(href('/complemento'), 'Acessar')))])).
table_body_link_tabela_itemlog -->
    html(tr([th(scope(row), '3'), td('Itemlog'), td('Tabela responsável pelo armazenamento dos logs cadastrados.'), td(p(a(href('/itemlog'), 'Acessar')))])).
table_body_link_tabela_evento -->
    html(tr([th(scope(row), '4'), td('Evento'), td('Tabela responsável pelo armazenamento dos eventos cadastrados.'), td(p(a(href('/evento'), 'Acessar')))])).
table_body_link_tabela_lancamento -->
    html(tr([th(scope(row), '5'), td('Lançamento'), td('Tabela responsável pelo armazenamento dos lançamentos cadastrados.'), td(p(a(href('/lancamento'), 'Acessar')))])).
table_body_link_tabela_pagamento -->
    html(tr([th(scope(row), '6'), td('Pagamento'), td('Tabela responsável pelo armazenamento dos pagamentos cadastrados.'), td(p(a(href('/pagamento'), 'Acessar')))])).
table_body_link_tabela_email -->
    html(tr([th(scope(row), '7'), td('Email'), td('Tabela responsável pelo armazenamento dos e-mails cadastrados.'), td(p(a(href('/email'), 'Acessar')))])).
   