:- discontiguous sintomas/2.
:- discontiguous probabilidade/2.
%%%%%%%%%%%%%%%%%%% SINTOMAS %%%%%%%%%%%%%%%%%%%%
sintomas(gripe, [febre, tosse, dor_de_cabeca, dores_no_corpo]). % sintomas da gripe
probabilidade(gripe, 0.8).

sintomas(resfriado, [nariz_entupido, coriza, dor_de_garganta, tosse]). % sintomas do resfriado
probabilidade(resfriado, 0.8).

sintomas(asma, [falta_de_ar, chiado_no_peito, tosse, respiracao_rapida]). % sintomas da asma
probabilidade(asma, 0.5).

sintomas(bronquite, [tosse_com_catarro, falta_de_ar, chiado_no_peito, dor_no_peito]). % sintomas da bronquite
probabilidade(bronquite, 0.05).

sintomas(pneumonia, [febre_alta, tosse_com_catarro, dor_no_peito, respiracao_rapida]). % sintomas da pneumonia
probabilidade(pneumonia, 0.1).

sintomas(dengue, [febre_alta, dor_de_cabeca, dor_nas_articulacoes, manchas_na_pele]). % sintomas da dengue
probabilidade(dengue, 0.4).

sintomas(zika, [febre_baixa, coceira, vermelhidao_na_pele, dor_nas_articulacoes]). % sintomas da zika
probabilidade(zika, 0.03).

sintomas(chikungunya, [febre_alta, dor_nas_articulacoes, dor_de_cabeca, vermelhidao_na_pele]). % sintomas da chikungunya
probabilidade(chikungunya, 0.1).

sintomas(diabetes, [sede_excessiva, fome_excessiva, vontade_frequente_de_urinar, perda_de_peso]). % sintomas da diabetes
probabilidade(diabetes, 0.1).

sintomas(hipertensao, [dor_de_cabeca, tontura, visao_embasada, dor_no_peito]). % sintomas da hipertensao
probabilidade(hipertensao, 0.15).
