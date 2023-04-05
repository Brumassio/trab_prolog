% Alunos:
% Diogo Brumassio 120122 
% Gabriel Rodrigues de Souza 

% Curso:
% Ciência da Computação (UEM)

% Diciplina: 
% Paradigmas de Programação Lógica e Funcional 
% 2 Trabalho Prático


% o resultado do protótipo é apenas informativo e que o paciente deve consultar um médico para obter um diagnóstico correto e preciso.

:- use_module(library(readutil)).
:- use_module(library(lists)).
:- use_module(library(system)).

:- dynamic(paciente/2).

ler_arquivo_pacientes(NomeArquivo) :-
    open(NomeArquivo, read, Stream),
    ler_linha(Stream),
    close(Stream).

ler_linha(Stream) :-
    read_line_to_codes(Stream, Line),
    (Line == end_of_file -> true ; processar_linha(Line), ler_linha(Stream)).

processar_linha(Line) :-
    ascii_para_string(Line, String),
    write(String), nl. % Exemplo: apenas imprime a linha lid

ascii_para_string(Codes, String) :-
    atom_codes(String, Codes).


menu :-
    repeat,
    write('---------------------------'), nl,
    write('       MENU PRINCIPAL      '), nl,
    write('---------------------------'), nl,
    write('1 - Listar pacientes'), nl,
    write('2 - Cadastrar novo paciente'), nl,
    write('3 - Editar paciente'), nl,
    write('4 - Excluir paciente'), nl,
    write('5 - Realizar Diagnostico'), nl,
    write('6 - Sair'), nl,
    
    read(Opcao),
    opcao_menu(Opcao),
    Opcao =:= 5, !.

opcao_menu(1) :-
    write('Listando pacientes: \n'),
    ler_arquivo_pacientes('pacientes.txt').
    
opcao_menu(2) :-
    adicionar_paciente(Nome,Idade).
    
opcao_menu(3) :-
    write('Digite o nome do paciente: '),
    read(Nome),
    editar_paciente(Nome, Idade),
    write('Paciente editado com sucesso!'), nl.
    
opcao_menu(4) :-
    input_do_paciente(Nome, Idade),
    excluir_paciente(Nome, Idade),
    write('Paciente excluido com sucesso!'), nl.

    

opcao_menu(6) :- 
    write('Saindo do sistema...').

% cadastrar paciente no arquivo .txt
input_do_paciente(Nome, Idade) :-
    write('Digite o nome do paciente: '),
    read(Nome),
    write('Digite a idade do paciente: '),
    read(Idade).

adicionar_paciente(Nome, Idade) :-
    input_do_paciente(Nome, Idade),
    open('pacientes.txt', append, Stream), 
    write(Stream, Nome), 
    write(Stream, ','),
    write(Stream, Idade), 
    nl(Stream),
    close(Stream),
    write('Paciente cadastrado com sucesso!'), nl.

%editar paciente (Nome, Idade) do arquivo pacientes.txt, caso o paciente não exista, retorna erro

excluir_paciente(Nome, Idade) :-
    open('pacientes.txt', read, In),
    open('pacientes_tmp.txt', write, Out),
    excluir_paciente_aux(Nome, Idade, In, Out),
    close(In),
    close(Out),
    rename_file('pacientes_tmp.txt', 'pacientes.txt').

excluir_paciente_aux(Nome, Idade, In, Out) :-
    read_line_to_codes(In, Line),
    (   Line == end_of_file
    ->  true
    ;   atom_codes(NomeIdade, Line),
        atomic_list_concat([NomeA, IdadeA], ',', NomeIdade),
        (   NomeA == Nome,
            IdadeA == Idade
        ->  true
        ;   atom_codes(NewLine, Line),
            writeln(Out, NewLine)
        ),
        excluir_paciente_aux(Nome, Idade, In, Out)
    ).


%  Doenca 1: Gripe
sintoma(gripe, febre).
sintoma(gripe, tosse).
sintoma(gripe, dor_de_cabeca).
sintoma(gripe, dores_no_corpo).
probabilidade(gripe, 0.6).

%  Doenca 2: Resfriado
sintoma(resfriado, nariz_entupido).
sintoma(resfriado, coriza).
sintoma(resfriado, dor_de_garganta).
sintoma(resfriado, tosse).
probabilidade(resfriado, 0.4).

%  Doenca 3: Asma
sintoma(asma, falta_de_ar).
sintoma(asma, chiado_no_peito).
sintoma(asma, tosse).
sintoma(asma, respiracao_rapida).
probabilidade(asma, 0.2).

%  Doenca 4: Bronquite
sintoma(bronquite, tosse_com_catarro).
sintoma(bronquite, falta_de_ar).
sintoma(bronquite, chiado_no_peito).
sintoma(bronquite, dor_no_peito).
probabilidade(bronquite, 0.3).

%  Doenca 5: Pneumonia
sintoma(pneumonia, febre_alta).
sintoma(pneumonia, tosse_com_catarro).
sintoma(pneumonia, dor_no_peito).
sintoma(pneumonia, respiracao_rapida).
probabilidade(pneumonia, 0.1).

%  Doenca 6: Dengue
sintoma(dengue, febre_alta).
sintoma(dengue, dor_de_cabeca).
sintoma(dengue, dor_nas_articulacões).
sintoma(dengue, manchas_na_pele).
probabilidade(dengue, 0.05).

%  Doenca 7: Zika
sintoma(zika, febre_baixa).
sintoma(zika, coceira).
sintoma(zika, vermelhidao_na_pele).
sintoma(zika, dor_nas_articulacões).
probabilidade(zika, 0.03).

%  Doenca 8: Chikungunya
sintoma(chikungunya, febre_alta).
sintoma(chikungunya, dor_nas_articulacões).
sintoma(chikungunya, dor_de_cabeca).
sintoma(chikungunya, vermelhidao_na_pele).
probabilidade(chikungunya, 0.02).
% Doenca 9: Diabetes
sintoma(diabetes, sede_excessiva).
sintoma(diabetes, fome_excessiva).
sintoma(diabetes, vontade_frequente_de_urinar).
sintoma(diabetes, perda_de_peso).
probabilidade(diabetes, 0.1).

%  Doenca 10: Hipertensao
sintoma(hipertensao, dor_de_cabeca).
sintoma(hipertensao, tontura).
sintoma(hipertensao, visao_embasada).
sintoma(hipertensao, dor_no_peito).
probabilidade(hipertensao, 0.15).

sintomas_da_doenca(Doenca, Sintomas) :-
    findall(Sintoma, sintoma(Doenca, Sintoma), Sintomas).

minha_lista(lista).

grau_febre(resposta2) :-
    write("\nSua temperatura esta ate 38 graus ou acima de 39 (responda com 38 ou 39)"),
    read(Resposta2),
    (Resposta2 = 38 -> resposta2 = febre_baixa; resposta2 = febre_alta).    
    
pergunta_febre(RespostaF) :-
    write("\nEsta sentindo febre? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim'-> grau_febre(resposta2); RespostaF = sem_febre). 

grau_tosse(resposta2) :-
    write("\ntosse com catarro ou sem (responda com ou sem):\n"),
    read_string(user_input, "\n", "\r", _, Resposta2),
    (Resposta2 == com -> resposta2 = tosse_com_catarro; resposta2 = tosse_sem_catarro).    
    
pergunta_tosse(RespostaT) :-
    write("\nEsta com tosse? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> grau_tosse(resposta2), RespostaT = resposta2; RespostaT =  sem_tosse).

pergunta_dores_no_corpo(RespostaDNC) :-
    write("\nEsta sentindo dores no corpo? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaDNC = dores_no_corpo; RespostaDNC = sem_dores_no_corpo ).

pergunta_dor_cabeca(RespostaDC) :-
    write("\nEsta sentindo dor de cabeca? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaDC = dor_de_cabeca; RespostaDC = sem_dor_de_cabeca ).

pergunta_dor_garganta(RespostaDG) :-
    write("\nEsta sentindo dor de garganta? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaDG = dor_de_garganta; RespostaDG = sem_dor_de_garganta ).

pergunta_nariz_entupido(RespostaNE) :-
    write("\nEsta com o nariz entupido? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaNE = nariz_entupido; RespostaNE = sem_nariz_entupido ).

pergunta_coriza(RespostaC) :-
    write("\nEsta com coriza? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaC = coriza; RespostaC = sem_coriza ).

pergunta_dor_no_peito(RespostaDP) :-
    write("\nEsta com dor no peito? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaDP = dor_no_peito; RespostaDP = sem_dor_no_peito ).

pergunta_chiado_no_peito(RespostaCNP) :-
    write("\nEsta com chiado no peito? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim'-> RespostaCNP = chiado_no_peito; RespostaCNP = sem_chiado_no_peito ).

pergunta_falta_de_ar(RespostaFDA) :-
    write("\nEsta com falta de ar? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaFDA = falta_de_ar; RespostaFDA = sem_falta_de_ar ).

pergunta_dor_nas_articulacoes(RespostaDNA) :-
    write("\nEsta com dor nas articulacões? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaDNA = dor_nas_articulacões; RespostaDNA = sem_dor_nas_articulacões).

pergunta_tontura(RespostaTon) :-
    write("\nEsta com tontura? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaTon = tontura; RespostaTon = sem_tontura). 

pergunta_vontade_frequente_de_urinar(RespostaUrina) :-
    write("\nEsta com vontade frequente de urinar? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim'-> RespostaUrina = vontade_frequente_de_urinar; RespostaUrina = sem_vontade_frequente_de_urinar). 

pergunta_vermelhidao_na_pele(RespostaVNP) :-
    write("\nEsta com vermelhidao na pele? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaVNP = vermelhidao_na_pele; RespostaVNP = sem_vermelhidao_na_pele). 

pergunta_coceira(RespostaCoceira) :-
    write("\nEsta com coceira? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaCoceira = coceira; RespostaCoceira = sem_coceira). 

pergunta_visao_embasada(RespostaVisao) :-
    write("\nEsta com a visao embasada? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaVisao = visao_embasada; RespostaVisao = sem_visao_embasada). 

pergunta_fome_excessiva(RespostaFome) :-
    write("\nEsta com fome excessiva ? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaFome = fome_excessiva; RespostaFome = sem_fome_excessiva). 

pergunta_sede_excessiva(RespostaSede) :- 
    write("\nEsta com sede excessiva ? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaSede = sede_excessiva; RespostaSede = sem_sede_excessiva). 

pergunta_manchas_na_pele(RespostaManchas) :-
    write("\nEsta com manchas na pele ? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaManchas = manchas_na_pele; RespostaManchas = sem_manchas_na_pele). 

pergunta_respiracao_rapida(RespostaRespira) :-
    write("\nEsta com a respiracao rapida ? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaRespira = respiracao_rapida; RespostaRespira = sem_respiracao_rapida). 

pergunta_perda_de_peso(RespostaPeso) :-
    write("\nPercebeu uma perda de peso repentina ? (sim ou nao):\n"),
    read_string(user_input, "\n", "\r", _, Resposta),
    (Resposta == 'sim' -> RespostaPeso = perda_de_peso; RespostaPeso = sem_perda_de_peso). 

questionario(lista) :-
    write('Responda as seguintes perguntas: '),
    pergunta_febre(RespostaF),
    pergunta_dor_cabeca(RespostaDC),
    pergunta_dor_garganta(RespostaDG),
    pergunta_nariz_entupido(RespostaNE),
    pergunta_tosse(RespostaT),
    pergunta_coriza(RespostaC),
    pergunta_dor_no_peito(RespostaDP),
    pergunta_chiado_no_peito(RespostaCNP),
    pergunta_dores_no_corpo(RespostaDNC),
    pergunta_dor_nas_articulacoes(RespostaDNA),
    pergunta_tontura(RespostaTon),
    pergunta_vontade_frequente_de_urinar(RespostaUrina),
    pergunta_vermelhidao_na_pele(RespostaVNP),
    pergunta_coceira(RespostaCoceira),
    pergunta_visao_embasada(RespostaVisao),
    pergunta_fome_excessiva(RespostaFome),
    pergunta_sede_excessiva(RespostaSede),
    pergunta_manchas_na_pele(RespostaManchas),
    pergunta_respiracao_rapida(RespostaRespira),
    pergunta_perda_de_peso(RespostaPeso),
    pergunta_falta_de_ar(RespostaFDA),

    
    append([RespostaF, RespostaDC, RespostaDG, RespostaNE, RespostaT, RespostaC, 
    RespostaDP, RespostaCNP, RespostaDNC, RespostaDNA, RespostaTon, RespostaUrina, RespostaVNP, RespostaCoceira, RespostaVisao, RespostaFome, RespostaSede,
    RespostaManchas, RespostaRespira, RespostaPeso, RespostaFDA],lista).