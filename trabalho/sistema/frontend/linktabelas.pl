/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

linktabelas(_):-
    reply_html_page(  
        boot5rest,
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
                   h1(class('py-5 font-weight-bold'), 'Tabelas'),
                    table(class('table table-striped table-responsive-md table-bordered'),
                        [   \table_header_link_tabelas,
                            %tbody(\table_body_link_tabela_integrante),
                            tbody(\table_body_link_tabela('1', 'Integrante', 'Tabela responsável pelo armazenamento de dados dos usuários do sistema.', '/integrante')),
                            tbody(\table_body_link_tabela('2', 'Complemento', 'Tabela responsável pelo armazenamento dos dados complementares do integrante.', '/complemento')),
                            tbody(\table_body_link_tabela('3', 'Evento', 'Tabela responsável pelo armazenamento dos eventos cadastrados.', '/eventos')),
                            tbody(\table_body_link_tabela('4', 'Lançamento', 'Tabela responsável pelo armazenamento dos lançamentos cadastrados.', '/lancamentos')),
                            tbody(\table_body_link_tabela('5', 'Pagamento', 'Tabela responsável pelo armazenamento dos pagamentos cadastrados.', '/pagamentos')),
                            tbody(\table_body_link_tabela('6', 'Email', 'Tabela responsável pelo armazenamento dos e-mails cadastrados.', '/email'))
                        ])
                  ]))).

table_header_link_tabelas -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'Nome da tabela'),
                    th([scope(col)], 'Informações'),
                    th([scope(col)], '#')
                  ]))).

table_body_link_tabela(Id, Tabela, Info, TabelaLink) -->
    html(tr([th(scope(row), Id), td(Tabela), td(Info), td(p(a(href(TabelaLink), 'Acessar')))])).