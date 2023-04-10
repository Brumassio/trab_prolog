%%%%%%%%%%%%%%%%%%% QUESTIONARIO DE SINTOMAS DO PACIENTE %%%%%%%%%%%%%%%%%%%%
pergunta_febre(RespostaF) :-
    write('\nEsta sentindo febre? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> grau_febre(RespostaF); RespostaF = 0).
    
grau_febre(RespostaF) :-
    write('\nSua temperatura esta ate 38 graus ou acima de 39 (responda maior ou igual a 39 ou inferior a 39)'),
    read(Resposta),
    (Resposta >= 39 -> RespostaF = febre_alta; RespostaF = febre_baixa).

pergunta_tosse(RespostaT) :-
    write('\nEsta com tosse? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> grau_tosse(RespostaT); RespostaT = 0).

grau_tosse(RespostaT) :-
    write('\ntosse com catarro (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaT = tosse_com_catarro; RespostaT = tosse_sem_catarro).

pergunta_dor_no_corpo(RespostaDNC) :-
    write('\nEsta sentindo dor no corpo? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaDNC = dor_no_corpo; RespostaDNC = 0).

pergunta_dor_cabeca(RespostaDC) :-
    write('\nEsta sentindo dor de cabeca? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaDC = dor_de_cabeca; RespostaDC = 0).

pergunta_dor_garganta(RespostaDG) :-
    write('\nEsta sentindo dor de garganta? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaDG = dor_de_garganta; RespostaDG = 0 ).

pergunta_nariz_entupido(RespostaNE) :-
    write('\nEsta com o nariz entupido? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaNE = nariz_entupido; RespostaNE = 0 ).

pergunta_coriza(RespostaC) :-
    write('\nEsta com coriza? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaC = coriza; RespostaC = 0).

pergunta_dor_no_peito(RespostaDP) :-
    write('\nEsta com dor no peito? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaDP = dor_no_peito; RespostaDP = 0).

pergunta_chiado_no_peito(RespostaCNP) :-
    write('\nEsta com chiado no peito? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim-> RespostaCNP = chiado_no_peito; RespostaCNP = 0).

pergunta_falta_de_ar(RespostaFDA) :-
    write('\nEsta com falta de ar? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaFDA = falta_de_ar; RespostaFDA = 0).

pergunta_dor_nas_articulacoes(RespostaDNA) :-
    write('\nEsta com dor nas articulacões? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaDNA = dor_nas_articulacoes; RespostaDNA = 0).

pergunta_tontura(RespostaTon) :-
    write('\nEsta com tontura? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaTon = tontura; RespostaTon = 0).

pergunta_vontade_frequente_de_urinar(RespostaUrina) :-
    write('\nEsta com vontade frequente de urinar? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim-> RespostaUrina = vontade_frequente_de_urinar; RespostaUrina = 0).

pergunta_vermelhidao_na_pele(RespostaVNP) :-
    write('\nEsta com vermelhidao na pele? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaVNP = vermelhidao_na_pele; RespostaVNP = 0).

pergunta_coceira(RespostaCoceira) :-
    write('\nEsta com coceira? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaCoceira = coceira; RespostaCoceira = 0).

pergunta_visao_embasada(RespostaVisao) :-
    write('\nEsta com a visao embasada? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaVisao = visao_embasada; RespostaVisao = 0).

pergunta_fome_excessiva(RespostaFome) :-
    write('\nEsta com fome excessiva ? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaFome = fome_excessiva; RespostaFome = 0).

pergunta_sede_excessiva(RespostaSede) :- 
    write('\nEsta com sede excessiva ? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaSede = sede_excessiva; RespostaSede = 0).

pergunta_manchas_na_pele(RespostaManchas) :-
    write('\nEsta com manchas na pele ? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaManchas = manchas_na_pele;  RespostaManchas = 0).

pergunta_respiracao_rapida(RespostaRespira) :-
    write('\nEsta com a respiracao rapida ? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaRespira = respiracao_rapida; RespostaRespira = 0).

pergunta_perda_de_peso(RespostaPeso) :-
    write('\nPercebeu uma perda de peso repentina ? (sim ou nao): '),
    read(Resposta),
    (Resposta == sim -> RespostaPeso = perda_de_peso; RespostaPeso = 0).