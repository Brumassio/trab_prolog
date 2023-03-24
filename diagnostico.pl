#  Doença 1: Gripe
sintoma(gripe, febre).
sintoma(gripe, tosse_seca).
sintoma(gripe, dor_de_cabeça).
sintoma(gripe, dores_no_corpo).
probabilidade(gripe, 0.6).

#  Doença 2: Resfriado
sintoma(resfriado, nariz_entupido).
sintoma(resfriado, coriza).
sintoma(resfriado, dor_de_garganta).
sintoma(resfriado, tosse).
probabilidade(resfriado, 0.4).

#  Doença 3: Asma
sintoma(asma, falta_de_ar).
sintoma(asma, chiado_no_peito).
sintoma(asma, tosse).
sintoma(asma, respiração_rápida).
probabilidade(asma, 0.2).

#  Doença 4: Bronquite
sintoma(bronquite, tosse_com_catarro).
sintoma(bronquite, falta_de_ar).
sintoma(bronquite, chiado_no_peito).
sintoma(bronquite, dor_no_peito).
probabilidade(bronquite, 0.3).

#  Doença 5: Pneumonia
sintoma(pneumonia, febre_alta).
sintoma(pneumonia, tosse_com_catarro).
sintoma(pneumonia, dor_no_peito).
sintoma(pneumonia, respiração_rápida).
probabilidade(pneumonia, 0.1).

#  Doença 6: Dengue
sintoma(dengue, febre_alta).
sintoma(dengue, dor_de_cabeça).
sintoma(dengue, dor_nas_articulações).
sintoma(dengue, manchas_na_pele).
probabilidade(dengue, 0.05).

#  Doença 7: Zika
sintoma(zika, febre_baixa).
sintoma(zika, coceira).
sintoma(zika, vermelhidão_na_pele).
sintoma(zika, dor_nas_articulações).
probabilidade(zika, 0.03).

#  Doença 8: Chikungunya
sintoma(chikungunya, febre_alta).
sintoma(chikungunya, dor_nas_articulações).
sintoma(chikungunya, dor_de_cabeça).
sintoma(chikungunya, vermelhidão_na_pele).
probabilidade(chikungunya, 0.02).

# Doença 9: Diabetes
sintoma(diabetes, sede_excessiva).
sintoma(diabetes, fome_excessiva).
sintoma(diabetes, vontade_frequente_de_urinar).
sintoma(diabetes, perda_de_peso).
probabilidade(diabetes, 0.1).

#  Doença 10: Hipertensão
sintoma(hipertensao, dor_de_cabeça).
sintoma(hipertensao, tontura).
sintoma(hipertensao, visão_embasada).
sintoma(hipertensao, dor_no_peito).
probabilidade(hipertensao, 0.15).

sintomas_da_doenca(Doenca, Sintomas) :-
    findall(Sintoma, sintoma(Doenca, Sintoma), Sintomas).

minha_lista(lista).
grau_febre(resposta2) :-
    write("\nSua temperatura esta ate 38 graus ou acima de 39 (responda com 38 ou 39)")
    read(resposta2)
    (resposta == 38 -> resposta2 = febre_baixa; resposta2 = febre_alta).    
    
pergunta_febre(RespostaF) :-
    write("\nEsta sentindo febre? (sim ou nao)"),
    read(resposta),
    (resposta == sim -> grau_febre(resposta2), RespostaF = resposta2; RespostaF =  sem_febre). 

grau_tosse(resposta2) :-
    write("\ntosse com catarro ou sem (responda com ou sem)")
    read(resposta2)
    (resposta == com -> resposta2 = tosse_com_catarro; resposta2 = tosse_sem_catarro).    
    
pergunta_tosse(RespostaT) :-
    write("\nEsta com tosse? (sim ou nao)"),
    read(resposta),
    (resposta == sim -> grau_tosse(resposta2), RespostaT = resposta2; RespostaT =  sem_tosse). 

pergunta_dor_cabeca(RespostaDC) :-
    write("\nEsta sentindo dor de cabeca? (sim ou nao)"),
    read(resposta),
    (resposta == sim -> RespostaDC = dor_de_cabeça; RespostaDC = sem_dor_de_cabeça ).

pergunta_dor_garganta(RespostaDG) :-
    write("\nEsta sentindo dor de garganta? (sim ou nao)"),
    read(resposta),
    (resposta == sim -> RespostaDG = dor_de_garganta; RespostaDG = sem_dor_de_garganta ).

pergunta_coriza(RespostaC) :-
    write("\nEsta com coriza? (sim ou nao)"),
    read(resposta),
    (resposta == sim -> RespostaC = coriza; RespostaC = sem_coriza ).

pergunta_dor_no_peito(RespostaDP) :-
    write("\nEsta com dor no peito? (sim ou nao)"),
    read(resposta),
    (resposta == sim -> RespostaDP = dor_no_peito; RespostaDP = sem_dor_no_peito ).

pergunta_dor_nas_articulacoes(RespostaDNA) :-
    write("\nEsta com dor no peito? (sim ou nao)"),
    read(resposta),
    (resposta == sim -> RespostaDNA = dor_nas_articulações; RespostaDNA = sem_dor_nas_articulações).

pergunta_tontura(RespostaTon) :-
    write("\nEsta com dor no peito? (sim ou nao)"),
    read(resposta),
    (resposta == sim -> RespostaTon = tontura; RespostaTon = sem_tontura). 

pergunta_vontade_frequente_de_urinar(RespostaUrina) :-
    write("\nEsta com vontade frequente de urinar? (sim ou nao)"),
    read(resposta),
    (resposta == sim -> RespostaUrina = vontade_frequente_de_urinar; RespostaUrina = sem_vontade_frequente_de_urinar). 

pergunta_vermelhidão_na_pele(RespostaVNP) :-
    write("\nEsta com vermelhidão na pele? (sim ou nao)"),
    read(resposta),
    (resposta == sim -> RespostaVNP = vermelhidão_na_pele; RespostaVNP = sem_vermelhidão_na_pele). 

pergunta_visão_embasada(RespostaVisao) :-
    write("\nEsta com a visao embasada? (sim ou nao)"),
    read(resposta),
    (resposta == sim -> RespostaVisao = visão_embasada; RespostaVisao = sem_visão_embasada). 

pergunta_fome_excessiva(RespostaFome) :-
    write("\nEsta com fome excessiva ?"),
    read(resposta),
    (resposta == sim -> RespostaFome = fome_excessiva; RespostaFome = sem_fome_excessiva). 

pergunta_sede_excessiva(RespostaSede) :- 
    write("\nEsta com sede excessiva ?"),
    read(resposta),
    (resposta == sim -> RespostaSede = sede_excessiva; RespostaSede = sem_sede_excessiva). 

questionario(lista) :-
    write('Responda as seguintes perguntas: '),
    pergunta_febre(RespostaF),
    pergunta_dor_cabeca(RespostaDC),
    pergunta_dor_garganta(RespostaDG),


