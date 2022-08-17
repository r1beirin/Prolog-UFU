/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

entrada(_):-
    %boot5rest,
    reply_html_page(
        [ title('Sistema de controle de receitas aplicado à equipe Amigos do Barney da gincana cidade de Blumenau')],
        [ div(class(container),
              [ \html_requires(css('bootstrap.min.css')),
                \html_requires(js('bootstrap.bundle.min.js')),
                \nav_inicial('navegacao-inicial'),
                \propaganda_entrada
              ]) ]).

propaganda_entrada -->
    html(div([ class='container-fluid' ],
             div([ id='propaganda',
                   class='py-5 text-center block block-1'],
                 [ div(class('py-5'), \cartao),
                   h1(class('py-5'), 'Sistema de controle de receitas aplicado à equipe Amigos do Barney da gincana cidade de Blumenau'),
                   p(class(lead),
                     [ 'Esse é um sistema para auxiliar o controle de receitas da equipe da gincana cidade de Blumenau, Amigos do Barney.']),
                   p(class(lead),
                     [ 'Os objetivos desse sistema é melhorar a comunicação da área financeira com os integrantes do grupo.'])
                ]))).
