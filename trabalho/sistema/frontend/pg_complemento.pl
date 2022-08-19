/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

:- use_module(elementos).

index_complemento(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Complementos')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \nav_inicial('navegacao-inicial'),
                \tabela_complemento,
                \titulo_pagina('Complementos'),
                \cadastro_botao('/complemento/cadastro'),
                \dados_individual_botao('/complemento/individual')
              ]) ]).

tabela_complemento -->
    html(div(class('container-fluid py-3'),
             [ \head_tabela('Complemento', '/complemento'),
               \tabelas_complemento
             ]
            )).


tabelas_complemento -->
    html(div(class('table-responsive-md'),
             table(class('table table-striped w-100 mb-3'),
                   [ \cabecalho_complemento,
                     tbody(\corpo_tabela_complemento)
                   ]))).

cabecalho_complemento -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'Apelido do integrante'),
                    th([scope(col)], 'Data de nascimento'),
                    th([scope(col)], 'Celular'),
                    th([scope(col)], 'Telefone'),
                    th([scope(col)], 'Endereço'),
                    th([scope(col)], 'Bairro'),
                    th([scope(col)], 'Cidade'),
                    th([scope(col)], 'CEP'),
                    th([scope(col)], 'Estado'),
                    th([scope(col)], 'Ações')
                  ]))).

corpo_tabela_complemento -->
    {
        findall( tr([th(scope(row), CodUsu), td(ApeInt), td(DatNas), td(NumCel), td(NumTel), td(EndInt), td(BaiInt),  td(CidInt),  td(CepInt),  td(UFInt), td(Action)]),
          linha_complemento(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt, Action),
          Linhas)
    },
    html(Linhas).

linha_complemento(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt, Action):-
    complemento:complemento(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt),
    acoes_complemento(CodUsu, Action).

acoes_complemento(CodUsu, Campo):-
    Campo = [ a([ class('text-success'), title('Alterar'),
                  href('/complemento/editar/~w' - CodUsu),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([ class('text-danger ms-1'), title('Excluir'),
                  href('/api/v1/complemento/~w' - CodUsu),
                  onClick("apagar( event, '/complemento' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].

/* Página de cadastro do complemento do integrante */
cadastro_complemento(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de complemento')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de complemento'),
                \form_complemento
              ]) ]).

form_complemento -->
    html(form([ id('complemento-form'),
                onsubmit("redirecionaResposta( event, '/complemento' )"),
                action('/api/v1/complemento/') ],
              [ \metodo_de_envio('POST'),
                \campo(codUsu, 'Id', text),
                \campo(apeInt, 'Apelido do integrante', text),
                \campo(datNas, 'Data de nascimento', date), % verificar se retorna string pro sistema
                \campo(numCel, 'Celular', text),
                \campo(numTel, 'Telefone', text),
                \campo(endInt, 'Endereço', text),
                \campo(baiInt, 'Bairro', text),
                \campo(cidInt, 'Cidade', text),
                \campo(cepInt, 'CEP', text),
                \campo(ufInt, 'Estado', text),
                \enviar_ou_cancelar('/complemento')
              ])).

/* Página para edição (alteração) de um complemento  */
editar_complemento(AtomId, _Pedido):-
    atom_number(AtomId, CodUsu),
    ( complemento:complemento(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar complemento')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar complemento'),
                \form_complemento(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt)
              ]) ])
    ; throw(http_reply(not_found(CodUsu)))
    ).


form_complemento(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt) -->
    html(form([ id('complemento-form'),
                onsubmit("redirecionaResposta( event, '/complemento/editar/5' )"),
                action('/api/v1/complemento/~w' - CodUsu) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(codUsu, 'Id', text, CodUsu),
                \campo(apeInt, 'Apelido do integrante', text, ApeInt),
                \campo(datNas, 'Data de nascimento', date, DatNas),
                \campo(numCel, 'Celular', text, NumCel),
                \campo(numTel, 'Telefone', text, NumTel),
                \campo(endIt, 'Endereço', text, EndInt),
                \campo(baiInt, 'Bairro', text, BaiInt),
                \campo(cidInt, 'Cidade', text, CidInt),
                \campo(cepInt, 'CEP', text, CepInt),
                \campo(ufInt, 'Estado', text, UFInt),
                \enviar_ou_cancelar('/complemento')
              ])).
