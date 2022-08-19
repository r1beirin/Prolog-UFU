/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

cadastro_botao(Link) --> 
    html(div(class('py-4 row'), a([ class(['btn', 'btn-primary']),href(Link)],'Cadastrar') )).

dados_individual_botao(Link) -->
    html(div(class('row'), a([ class(['btn', 'btn-secondary']),href(Link)],'Ler dados individuais') )).

titulo_pagina(Title) -->
    html( div(class('text-center align-items-center w-100'),
              h1('display-3', Title))).