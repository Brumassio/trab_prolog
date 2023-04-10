:- consult('sintomas.pl').
:- consult('diagnostico.pl').
:- use_module(library(plunit)).

:- begin_tests(tests).

    %%%%%%%%%%%%%%%%%%%%%%% TESTS CERTOS %%%%%%%%%%%%%%%%%%%%%%%
    test(probs, R == 0.8) :- 
        probabilidade(gripe, R).
            
    test(doenca, R == [nariz_entupido, coriza, dor_de_garganta, tosse_com_catarro]) :- 
        sintomas(resfriado, R).

    test(doenca, R == [sede_excessiva, fome_excessiva, vontade_frequente_de_urinar, perda_de_peso]) :-
        sintomas(diabetes, R).

    %%%%%%%%%%%%%%%%%%%%%%% TESTS ERRADOS %%%%%%%%%%%%%%%%%%%%%%%
    test(prob, [fail]) :-
            probabilidade(resfriado, 0.6).

    test(test_sintoma, [fail] ) :-
            sintomas(covid_19, [falta_de_ar, chiado_no_peito, tosse, respiracao_rapida]).

    test(test_sintoma, [fail] ) :-
            sintomas(resfriado, [febre_alta, tosse_sem_catarro, dor_de_cabeca, dor_no_corpo]).

:- end_tests(tests).