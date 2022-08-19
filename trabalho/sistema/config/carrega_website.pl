% Configuração do servidor


% Carrega o servidor e as rotas

:- load_files([ servidor,
                rotas
              ],
              [ silent(true),
                if(not_loaded) ]).

% Inicializa o servidor para ouvir a porta 8000
:- initialization( servidor(8000) ).


% Carrega o frontend

:- load_files([ gabarito(bootstrap5),  % gabarito usando Bootstrap 5
                gabarito(boot5rest),   % Bootstrap 5 com API REST
                frontend(entrada),
                frontend(menu_topo),
                frontend(icones),
                frontend(linktabelas),
                frontend(elementos),
                frontend(pg_integrantes),
                frontend(pg_email),
                frontend(pg_complemento),
                frontend(pg_eventos),
                frontend(pg_lancamentos)
              ],
              [ silent(true),
                if(not_loaded) ]).


% Carrega o backend

:- load_files([ api1(integrante),
                api1(complemento),
                api1(eventos),
                api1(lancamentos),
                api1(email)
              ],
              [ silent(true),
                if(not_loaded) ]).
