:- module(
    complemento,
    [ complemento/10 ]).

:- use_module(library(persistency)).

:- persistent
    complemento(codUsu:positive_integer,    %   Foreign Key
                apeInt:text,                %   Armazena o apelido do integrante - Opcional
                datNas:text,                %   Armazena a data de nascimento do integrante - Opcional 
                numCel:text,                %   Armazena o numero celular do integrante - Opcional
                numTel:text,                %   Armazena o numero do telefone residencial do integrante. - Opcional
                endInt:text,                %   Armazena o endereço do integrante. - Opcional
                baiInt:text,                %   Armazena o bairro do integrante. - Opcional
                cidInt:text,                %   Armazena a cidade do integrante. - Opcional
                cepInt:text,                %   Armazena o CEP do integrante. - Opcional
                ufInt:text).                %   Armazena o estado do integrante. - Opcional

:- initialization(db_attach('tbl_complemento.pl', [])).

insere(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt) :-
    with_mutex(complemento,
                assert_complemento(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt)
                ).

remove(CodUsu) :-
    with_mutex(complemento,
                retract_complemento(CodUsu, _ApeInt, _DatNas, _NumCel, _NumTel, _EndInt, _BaiInt, _CidInt, _CepInt, _UFInt)
                ).

atualiza(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt) :-
    with_mutex(complemento,
                (retractall_complemento(CodUsu, _ApeInt, _DatNas, _NumCel, _NumTel, _EndInt, _BaiInt, _CidInt, _CepInt, _UFInt),
                assert_complemento(CodUsu, ApeInt, DatNas, NumCel, NumTel, EndInt, BaiInt, CidInt, CepInt, UFInt))
                ).

sincroniza :-
    db_sync(gc(always)).
