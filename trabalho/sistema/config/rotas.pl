% http_handler, http_reply_file
:- use_module(library(http/http_dispatch)).

% http:location
:- use_module(library(http/http_path)).

:- ensure_loaded(caminhos).

/***********************************
 *                                 *
 *      Rotas do Servidor Web      *
 *                                 *
 ***********************************/

:- multifile http:location/3.
:- dynamic   http:location/3.

%% http:location(Apelido, Rota, Opções)
%      Apelido é como será chamada uma Rota do servidor.
%      Os apelidos css, icons e js já estão definidos na
%      biblioteca http/http_server_files, os demais precisam
%      ser definidos.

http:location(img, root(img), []).
http:location(api, root(api), []).
http:location(api1, api(v1), []).

/**************************
 *                        *
 *      Tratadores        *
 *                        *
 **************************/

% Recursos estáticos
:- http_handler( css(.),
                 serve_files_in_directory(dir_css), [prefix]).
:- http_handler( img(.),
                 serve_files_in_directory(dir_img), [prefix]).
:- http_handler( js(.),
                 serve_files_in_directory(dir_js),  [prefix]).

% Rotas do Frontend

%% A página inicial
:- http_handler(root(.), entrada,   []).
%% Página de link das tabelas
:- http_handler(root(linktabelas), linktabelas, []).

% Páginas da tabela integrante
:- http_handler(root(integrante), pg_integrantes:index_integrante, []).
:- http_handler(root(integrante/cadastro), pg_integrantes:cadastro_integrante, []).
:- http_handler(root(integrante/editar/Id), pg_integrantes:editar_integrante(Id), []).

% Páginas da tabela complemento
:- http_handler(root(complemento), pg_complemento:index_complemento, []).
:- http_handler(root(complemento/cadastro), pg_complemento:cadastro_complemento, []).
:- http_handler(root(complemento/editar/Id), pg_complemento:editar_complemento(Id), []).

% Páginas da tabela eventos
:- http_handler(root(eventos), pg_eventos:index_eventos, []).
:- http_handler(root(eventos/cadastro), pg_eventos:cadastro_eventos, []).
:- http_handler(root(eventos/editar/Id), pg_eventos:editar_eventos(Id), []).

% Páginas da tabela eventos
:- http_handler(root(lancamentos), pg_lancamentos:index_lancamentos, []).
:- http_handler(root(lancamentos/cadastro), pg_lancamentos:cadastro_lancamentos, []).
:- http_handler(root(lancamentos/editar/Id), pg_lancamentos:editar_lancamentos(Id), []).

% Páginas da tabela email
:- http_handler(root(email), pg_email:index_email, []).

% Rotas da API
:- http_handler( api1(integrante/Id), integrante(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(complemento/Id), complemento(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(eventos/Id), eventos(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(lancamentos/Id), lancamentos(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).
