% Alunos:
% Diogo Brumassio 120122 
% Gabriel Rodrigues de Souza 

% Curso:
% Ciência da Computação (UEM)

% Diciplina: 
% Paradigmas de Programação Lógica e Funcional 
% 2 Trabalho Prático

:- use_module(library(readutil)).
:- use_module(library(lists)).
:- use_module(library(system)).

:- dynamic(paciente/2).
:- dynamic(doenca/2).

:- discontiguous doenca_sintomas/1.
:- discontiguous sintomas/2.
:- discontiguous probabilidade/2.
:- discontiguous printa_lista/1.
:- discontiguous comparar_listas/3.

% ler arquivo pacientes.txt
ler_arquivo_pacientes(NomeArquivo) :-
    open(NomeArquivo, read, Stream),
    ler_linha(Stream),
    close(Stream).

% ler linha do arquivo pacientes.txt
ler_linha(Stream) :-
    read_line_to_codes(Stream, Line),
    (Line == end_of_file -> true ; processar_linha(Line), ler_linha(Stream)).

% processar linha do arquivo pacientes.txt
processar_linha(Line) :-
    ascii_para_string(Line, String),
    write(String), nl.
    
% transforma o código ascii em string
ascii_para_string(Codes, String) :-
    atom_codes(String, Codes).

% regra principal do trabalho
menu :-
    repeat,
    write('---------------------------'), nl,
    write('       MENU PRINCIPAL      '), nl,
    write('---------------------------'), nl,
    write('1 - Listar pacientes'), nl,
    write('2 - Cadastrar novo paciente'), nl,
    write('3 - Editar pacientes'), nl,
    write('4 - Excluir paciente'), nl,
    write('5 - Realizar Diagnostico'), nl,
    % write('6 - Listar Probabilidades'), nl, fazer ele listar no final do diagnostico?
    write('6 - Sair'), nl,
    
    read(Opcao),
    opcao_menu(Opcao),
    Opcao =:= 6, !.

opcao_menu(1) :-
    write('Listando pacientes: \n'),
    ler_arquivo_pacientes('pacientes.txt').
    
opcao_menu(2) :-
    input_do_paciente(Nome, Idade),
    adicionar_paciente(Nome,Idade).
    
opcao_menu(3) :-
    write('Editando !!!'), nl,
    input_do_paciente(Nome, Idade),
    write('Digite o novo nome do paciente:'), 
    read(NovoNome),
    write('Digite a nova idade do paciente:'), 
    read(NovaIdade),
    editar_paciente(Nome, Idade, NovoNome, NovaIdade),
    write('Paciente editado com sucesso!'), nl.
    
opcao_menu(4) :-
    input_do_paciente(Nome, Idade),
    excluir_paciente(Nome, Idade),
    write('Paciente excluido com sucesso!'), nl.

opcao_menu(5) :-
    questionario(ListaRespostas).

% opcao_menu(6) :-
%     write('Listando probabilidades: \n'),
%     probabilidade(gripe, ProbGripe),
%     probabilidade(resfriado, ProbResfriado),
%     probabilidade(asma, ProbAsma),
%     probabilidade(bronquite, ProbBronquite),
%     probabilidade(pneumonia, ProbPneumonia),
%     probabilidade(dengue, ProbDengue),
%     probabilidade(zika, ProbZika),
%     probabilidade(chikungunya, ProbChikungunya),
%     probabilidade(diabetes, ProbDiabetes),
%     probabilidade(hipertensao, ProbHipertensao),
%     write('Probabilidade de Gripe: '), write(ProbGripe), nl,
%     write('Probabilidade de Resfriado: '), write(ProbResfriado), nl,
%     write('Probabilidade de Asma: '), write(ProbAsma), nl,
%     write('Probabilidade de Bronquite: '), write(ProbBronquite), nl,
%     write('Probabilidade de Pneumonia: '), write(ProbPneumonia), nl,
%     write('Probabilidade de Dengue: '), write(ProbDengue), nl,
%     write('Probabilidade de Zika: '), write(ProbZika), nl,
%     write('Probabilidade de Chikungunya: '), write(ProbChikungunya), nl,
%     write('Probabilidade de Diabetes: '), write(ProbDiabetes), nl,
%     write('Probabilidade de Hipertensao: '), write(ProbHipertensao), nl,
%     write('---------------------------'), nl,
%     write(' O resultado do prototipo eh apenas informativo e que o paciente deve consultar um medico para obter um diagnostico correto e preciso.'), nl.


opcao_menu(6) :- 
    write('Saindo do sistema...').

% cadastrar paciente no arquivo .txt
input_do_paciente(Nome, Idade) :-
    write('Digite o nome do paciente: '),
    read(Nome),
    write('Digite a idade do paciente: '),
    read(Idade).

adicionar_paciente(Nome, Idade) :-
    open('pacientes.txt', append, Stream), 
    write(Stream, Nome), 
    write(Stream, '| '),
    write(Stream, Idade), 
    nl(Stream),
    close(Stream),
    write('Paciente cadastrado com sucesso!'), nl.

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
        atomic_list_concat([NomeA, IdadeA], '| ', NomeIdade),
        atom_number(IdadeA, IdadeA2),
        (   
            NomeA == Nome,
            IdadeA2 == Idade
        ->  true
        ;   
            atom_codes(NewLine, Line),
            writeln(Out, NewLine)
        ),
        excluir_paciente_aux(Nome, Idade, In, Out)
    ).

%editar paciente (Nome, Idade) do arquivo pacientes.txt, caso o paciente não exista, retorna erro
editar_paciente(Nome, Idade, NovoNome, NovaIdade) :-
    open('pacientes.txt', read, In),
    open('pacientes_tmp.txt', write, Out),
    editar_paciente_aux(Nome, Idade, NovoNome, NovaIdade, In, Out),
    close(In),
    close(Out),
    rename_file('pacientes_tmp.txt', 'pacientes.txt').

editar_paciente_aux(Nome, Idade, NovoNome, NovaIdade, In, Out) :-
    read_line_to_codes(In, Line),
    (   Line == end_of_file
    ->  true
    ;   atom_codes(NomeIdade, Line),
        atomic_list_concat([NomeA, IdadeA], '| ', NomeIdade),
        atom_number(IdadeA, IdadeA2),
        write('TO AQUI !!!'), nl,
        (   
            NomeA == Nome,
            IdadeA2 == Idade
        ->  
            write('To escrevendo aqui po'), nl,
            write(Out, NovoNome), 
            write(Out, '| '),
            write(Out, NovaIdade), 
            nl(Out)
        ;   
            atom_codes(NewLine, Line),
            writeln(Out, NewLine)
        ),
        editar_paciente_aux(Nome, Idade,NovoNome, NovaIdade, In, Out)
    ).

% probabilidade de uma doença, dado uma lista de sintomas
probabilidade_doenca(Doenca, Sintomas, Prob) :-
    probabilidade(Doenca, P), % probabilidade padrão da doença
    probabilidade_sintomas(Doenca, Sintomas, PS), % probabilidade de ter os sintomas na doença
    Prob is P * PS. % probabilidade da doença, dado os sintomas

% probabilidade de ter uma lista de sintomas na doença
probabilidade_sintomas(_, [], 1).
probabilidade_sintomas(Doenca, [Sintoma|Resto], PS) :-
    sintoma(Doenca, Sintoma), % se a doença tem o sintoma
    probabilidade_sintomas(Doenca, Resto, PS1), % calcular a probabilidade do resto dos sintomas
    PS is PS1 * 0.9. % considerar uma probabilidade alta (0.9) para ter um sintoma
probabilidade_sintomas(Doenca, [Sintoma|Resto], PS) :-
    \+ sintoma(Doenca, Sintoma), % se a doença não tem o sintoma
    probabilidade_sintomas(Doenca, Resto, PS1), % calcular a probabilidade do resto dos sintomas
    PS is PS1 * 0.1. % considerar uma probabilidade baixa (0.1) para não ter um sintoma


% calcular a probabilidade para cada doença
calcular_probabilidade_doencas(Probs) :-
    sintomas_paciente(Sintomas),
    findall(Prob-D, (probabilidade_doenca(D, Sintomas, Prob)), Pares),
    sort(Pares, Probs). % ordenar por ordem decrescente de probabilidade

% exibir as doenças com as respectivas probabilidades
exibir_probabilidades_doencas :-
    calcular_probabilidade_doencas(Probs),
    write('Probabilidades de doenças:'), nl,
    forall(member(Prob-D, Probs), (write(D), write(': '), write(Prob), nl)).


% comparar_listas([], _, []).
% comparar_listas([H1|T1], L2, [H1|T2]) :-
%     member(H1, L2),
%     comparar_listas(T1, L2, T2).
% comparar_listas([_|T1], L2, T2) :-
%     comparar_listas(T1, L2, T2).

%  Doenca 1: Gripe
sintomas(gripe, [febre, tosse, dor_de_cabeca, dores_no_corpo]). % sintomas da gripe
probabilidade(gripe, 0.6).

%  Doenca 2: Resfriado
sintomas(resfriado, [nariz_entupido, coriza, dor_de_garganta, tosse]). % sintomas do resfriado
probabilidade(resfriado, 0.4).

%  Doenca 3: Asma
sintomas(asma, [falta_de_ar, chiado_no_peito, tosse, respiracao_rapida]). % sintomas da asma
probabilidade(asma, 0.2).

%  Doenca 4: Bronquite
sintomas(bronquite, [tosse_com_catarro, falta_de_ar, chiado_no_peito, dor_no_peito]). % sintomas da bronquite
probabilidade(bronquite, 0.3).

%  Doenca 5: Pneumonia
sintomas(pneumonia, [febre_alta, tosse_com_catarro, dor_no_peito, respiracao_rapida]). % sintomas da pneumonia
probabilidade(pneumonia, 0.1).

%  Doenca 6: Dengue
sintomas(dengue, [febre_alta, dor_de_cabeca, dor_nas_articulacoes, manchas_na_pele]). % sintomas da dengue
probabilidade(dengue, 0.05).

%  Doenca 7: Zika
sintomas(zika, [febre_baixa, coceira, vermelhidao_na_pele, dor_nas_articulacoes]). % sintomas da zika
probabilidade(zika, 0.03).

%  Doenca 8: Chikungunya
sintomas(chikungunya, [febre_alta, dor_nas_articulacoes, dor_de_cabeca, vermelhidao_na_pele]). % sintomas da chikungunya
probabilidade(chikungunya, 0.02).

% Doenca 9: Chikungunya
sintomas(diabetes, [sede_excessiva, fome_excessiva, vontade_frequente_de_urinar, perda_de_peso]). % sintomas da diabetes
probabilidade(diabetes, 0.1).

%  Doenca 10: Hipertensao
sintomas(hipertensao, [dor_de_cabeca, tontura, visao_embasada, dor_no_peito]). % sintomas da hipertensao
probabilidade(hipertensao, 0.15).


% Definir uma lista com todas as doenças
doencas([gripe, resfriado, asma, bronquite, pneumonia, dengue, zika, chikungunya, diabetes, hipertensao]).

% Definir um predicado que recebe a lista de respostas e retorna a lista de sintomas
sintomas_do_paciente(Respostas, Sintomas) :-
    % Obter a lista de sintomas de cada doença
    doencas(Doencas),
    maplist(sintomas_da_doenca, Doencas, ListasDeSintomas),
    % Juntar todas as listas de sintomas em uma só
    append(ListasDeSintomas, TodosOsSintomas),
    % Filtrar apenas os sintomas que estão nas respostas do paciente
    include(memberchk(Respostas), TodosOsSintomas, Sintomas).

% Definir um predicado auxiliar para obter a lista de sintomas de uma doença
sintomas_da_doenca(Doenca, Sintomas) :-
    sintomas(Doenca, Sintomas).

printa_lista([], _).
printa_lista(ListaComp) :-
    write('Sintomas do paciente: '), nl,
    forall(member(X, ListaComp), (write(X), nl)).

teste(ListaIguais) :-
    write(ListaIguais), nl,
    write('Imprimindo dnv pra ver se da'), nl,
    write(ListaIguais), nl.

%%%%%%%%%%%%%%%%%%% QUESTIONARIO DE SINTOMAS DO PACIENTE %%%%%%%%%%%%%%%%%%%%

pergunta_febre(RespostaF) :-
    write('\nEsta sentindo febre? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> grau_febre(RespostaF); true).
    
grau_febre(RespostaF) :-
    write('\nSua temperatura esta ate 38 graus ou acima de 39 (responda maior ou igual a 39 ou inferior a 39)'),
    read(Resposta),
    (Resposta >= 39 -> RespostaF = 'febre_alta'; RespostaF = 'febre_baixa').

pergunta_tosse(RespostaT) :-
    write('\nEsta com tosse? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> grau_tosse(RespostaT); true).

grau_tosse(RespostaT) :-
    write('\ntosse com catarro (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaT = 'tosse_com_catarro'; RespostaT = 'tosse_sem_catarro').    

pergunta_dores_no_corpo(RespostaDNC) :-
    write('\nEsta sentindo dores no corpo? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaDNC = 'dor_no_corpo'; true).

pergunta_dor_cabeca(RespostaDC) :-
    write('\nEsta sentindo dor de cabeca? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaDC = 'dor_de_cabeca'; true ).

pergunta_dor_garganta(RespostaDG) :-
    write('\nEsta sentindo dor de garganta? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaDG = 'dor_de_garganta'; true ).

pergunta_nariz_entupido(RespostaNE) :-
    write('\nEsta com o nariz entupido? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaNE = 'nariz_entupido';true ).

pergunta_coriza(RespostaC) :-
    write('\nEsta com coriza? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaC = 'coriza'; true ).

pergunta_dor_no_peito(RespostaDP) :-
    write('\nEsta com dor no peito? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaDP = 'dor_no_peito'; true ).

pergunta_chiado_no_peito(RespostaCNP) :-
    write('\nEsta com chiado no peito? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim'-> RespostaCNP = 'chiado_no_peito'; true ).

pergunta_falta_de_ar(RespostaFDA) :-
    write('\nEsta com falta de ar? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaFDA = 'falta_de_ar'; true ).

pergunta_dor_nas_articulacoes(RespostaDNA) :-
    write('\nEsta com dor nas articulacões? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaDNA = 'dor_nas_articulacoes'; true).

pergunta_tontura(RespostaTon) :-
    write('\nEsta com tontura? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaTon = 'tontura'; true). 

pergunta_vontade_frequente_de_urinar(RespostaUrina) :-
    write('\nEsta com vontade frequente de urinar? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim'-> RespostaUrina = 'vontade_frequente_de_urinar'; true). 

pergunta_vermelhidao_na_pele(RespostaVNP) :-
    write('\nEsta com vermelhidao na pele? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaVNP = 'vermelhidao_na_pele';true). 

pergunta_coceira(RespostaCoceira) :-
    write('\nEsta com coceira? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaCoceira = 'coceira'; true). 

pergunta_visao_embasada(RespostaVisao) :-
    write('\nEsta com a visao embasada? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaVisao = 'visao_embasada';true). 

pergunta_fome_excessiva(RespostaFome) :-
    write('\nEsta com fome excessiva ? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaFome = 'fome_excessiva'; true). 

pergunta_sede_excessiva(RespostaSede) :- 
    write('\nEsta com sede excessiva ? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaSede = 'sede_excessiva'; true). 

pergunta_manchas_na_pele(RespostaManchas) :-
    write('\nEsta com manchas na pele ? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaManchas = 'manchas_na_pele'; true). 

pergunta_respiracao_rapida(RespostaRespira) :-
    write('\nEsta com a respiracao rapida ? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaRespira = 'respiracao_rapida'; true). 

pergunta_perda_de_peso(RespostaPeso) :-
    write('\nPercebeu uma perda de peso repentina ? (sim ou nao): '),
    read(Resposta),
    (Resposta == 'sim' -> RespostaPeso = 'perda_de_peso'; true). 
    
%escreva todas as doenças que o programa pode identificar
questionario(ListaRespostas) :-
    write('Responda as seguintes perguntas: '), nl,
    pergunta_febre(RespostaF),  
    pergunta_tosse(RespostaT), 
    pergunta_dores_no_corpo(RespostaDNC), 
    pergunta_dor_cabeca(RespostaDC),
    pergunta_dor_garganta(RespostaDG),  
    pergunta_nariz_entupido(RespostaNE),    
    pergunta_coriza(RespostaC),   
    pergunta_dor_no_peito(RespostaDP), 
    pergunta_chiado_no_peito(RespostaCNP),   
    pergunta_falta_de_ar(RespostaFDA),   
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
    

    append([],[RespostaF, RespostaT, RespostaDNC, RespostaDC, RespostaDG, RespostaNE, RespostaC, RespostaDP, RespostaCNP, RespostaFDA, RespostaDNA, RespostaTon, RespostaUrina, RespostaVNP, RespostaCoceira, RespostaVisao, RespostaFome, RespostaSede, RespostaManchas, RespostaRespira, RespostaPeso], ListaRespostas),
    append([],['febre_alta','febre_baixa','tosse_com_catarro','tosse_sem_catarro','dor_no_corpo','dor_de_cabeca','dor_de_garganta','nariz_entupido','coriza','dor_no_peito','chiado_no_peito','dor_nas_articulacoes','tontura','vontade_frequente_de_urinar','vermelhidao_na_pele','coceira','visao_embasada','fome_excessiva','sede_excessiva','manchas_na_pele','respiracao_rapida','perda_de_peso','falta_de_ar'],ListaComp),
    intersection(ListaRespostas, ListaComp, ListaIguais),
    % intersection(ListaIguais,ListaComp,ListaIguais),
    sleep(2),
    teste(ListaIguais).
    %printa_lista(ListaIguais).
    % calcular_probabilidade_doencas(ListaRespostas, ListaProbabilidades)