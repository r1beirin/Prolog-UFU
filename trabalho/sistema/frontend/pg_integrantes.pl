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
                \titulo_pagina('Integrantes')
              ]) ]).

titulo_pagina(Title) -->
    html( div(class('text-center align-items-center w-100'),
              h1('display-3', Title))).