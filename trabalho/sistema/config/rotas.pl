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
:- http_handler( root(.), entrada,   []).
%% Página de link das tabelas
:- http_handler(root(linktabelas), linktabelas, []).

% Página da tabela integrante
%:-use_module(frontend(pg_integrantes),[]).
:- http_handler( root(integrante), pg_integrantes:index_integrante, []).
:- http_handler( root(integrante/cadastro), pg_integrantes:cadastro_integrante, []).
:- http_handler( root(integrante/editar/Id), pg_integrantes:editar_integrante(Id), []).


% Rotas da API
:- http_handler( api1(integrante/Id), integrante(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).
