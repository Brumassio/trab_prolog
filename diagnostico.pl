% Alunos:
% Diogo Brumassio 120122 
% Gabriel Rodrigues de Souza 118038

% Curso:
% Ciência da Computação (UEM)

% Diciplina: 
% Paradigmas de Programação Lógica e Funcional 
% 2 Trabalho Prático
:- consult('perguntas.pl').
:- consult('tools.pl').
:- consult('sintomas.pl').


:- use_module(library(readutil)).
:- use_module(library(lists)).
:- use_module(library(system)).

:- dynamic(paciente/2).
:- dynamic(doenca/2).

:- discontiguous printa_lista/1.
:- discontiguous doencas/1.

% regra principal do trabalho
menu :-
    repeat,
    write('\n---------------------------'), nl,
    write('       MENU PRINCIPAL      '), nl,
    write('---------------------------'), nl,
    write('1 - Listar pacientes'), nl,
    write('2 - Cadastrar novo paciente'), nl,
    write('3 - Editar pacientes'), nl,
    write('4 - Excluir paciente'), nl,
    write('5 - Realizar Diagnostico'), nl,
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
    questionario.

opcao_menu(6) :- 
    write('Saindo do sistema...').


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

%escreva todas as doenças que o programa pode identificar
questionario :-
    write('Responda as seguintes perguntas: '), nl,
    pergunta_febre(RespostaF),  
    pergunta_tosse(RespostaT), 
    pergunta_dores_no_corpo(RespostaDNC), 
    pergunta_dor_cabeca(RespostaDC),
    pergunta_dor_garganta(RespostaDG),  
    % pergunta_nariz_entupido(RespostaNE),    
    % pergunta_coriza(RespostaC),   
    % pergunta_dor_no_peito(RespostaDP), 
    % pergunta_chiado_no_peito(RespostaCNP),   
    % pergunta_falta_de_ar(RespostaFDA),   
    % pergunta_dor_nas_articulacoes(RespostaDNA),
    % pergunta_tontura(RespostaTon),   
    % pergunta_vontade_frequente_de_urinar(RespostaUrina),    
    % pergunta_vermelhidao_na_pele(RespostaVNP),    
    % pergunta_coceira(RespostaCoceira),
    % pergunta_visao_embasada(RespostaVisao),   
    % pergunta_fome_excessiva(RespostaFome),    
    % pergunta_sede_excessiva(RespostaSede),    
    % pergunta_manchas_na_pele(RespostaManchas),
    % pergunta_respiracao_rapida(RespostaRespira),
    % pergunta_perda_de_peso(RespostaPeso),
    % amamos o vitor greff
    ListaRespostas = [RespostaF, RespostaT, RespostaDNC, RespostaDC, RespostaDG],
    % , RespostaNE, RespostaC, RespostaDP, RespostaCNP, RespostaFDA, RespostaDNA, RespostaTon, RespostaUrina, RespostaVNP, RespostaCoceira, RespostaVisao, RespostaFome, RespostaSede, RespostaManchas, RespostaRespira, RespostaPeso
    ListaAux = ['febre_alta','febre_baixa','tosse_com_catarro','tosse_sem_catarro','dor_no_corpo','dor_de_cabeca','dor_de_garganta','nariz_entupido','coriza','dor_no_peito','chiado_no_peito','dor_nas_articulacoes','tontura','vontade_frequente_de_urinar','vermelhidao_na_pele','coceira','visao_embasada','fome_excessiva','sede_excessiva','manchas_na_pele','respiracao_rapida','perda_de_peso','falta_de_ar'],
    intersection(ListaRespostas,ListaAux, ListaDeSintomas), nl,
    probabilidade_sintomas(gripe, ListaDeSintomas, ProbabilidadeGripe),
    probabilidade_sintomas(resfriado, ListaDeSintomas, ProbabilidadeResfriado),
    probabilidade_sintomas(covid_19,ListaDeSintomas,ProbabilidadeCovid),
    probabilidade_sintomas(asma, ListaDeSintomas, ProbabilidadeAsma),
    probabilidade_sintomas(bronquite, ListaDeSintomas, ProbabilidadeBronquite),
    probabilidade_sintomas(pneumonia, ListaDeSintomas, ProbabilidadePneumonia),
    probabilidade_sintomas(dengue, ListaDeSintomas, ProbabilidadeDengue),
    probabilidade_sintomas(zika, ListaDeSintomas, ProbabilidadeZika),
    probabilidade_sintomas(chikungunya, ListaDeSintomas, ProbabilidadeChikungunya),
    probabilidade_sintomas(diabetes, ListaDeSintomas, ProbabilidadeDiabetes),
    probabilidade_sintomas(hipertensao, ListaDeSintomas, ProbabilidadeHipertensao),
    Probs = [ProbabilidadeGripe, ProbabilidadeResfriado, ProbabilidadeCovid, ProbabilidadeAsma, ProbabilidadeBronquite, ProbabilidadePneumonia, ProbabilidadeDengue, ProbabilidadeZika, ProbabilidadeChikungunya, ProbabilidadeDiabetes, ProbabilidadeHipertensao],
    ordenado_decrescente(Probs, ProbsOrdenadas),
    nth1(1, ProbsOrdenadas, DoencaMaiorProb),
    nth1(2, ProbsOrdenadas, DoencaSegundaMaiorProb),
    nth1(3, ProbsOrdenadas, DoencaTerceiraMaiorProb),
    write('A doenca mais provavel e: '), write(DoencaMaiorProb), nl,
    write('A segunda doenca mais provavel e: '), write(DoencaSegundaMaiorProb), nl,
    write('A terceira doenca mais provavel e: '), write(DoencaTerceiraMaiorProb), nl,
    imprime_doencas_ordenadas(ProbsOrdenadas, _, [gripe, resfriado, covid_19, asma, bronquite, pneumonia, dengue, zika, chikungunya, diabetes, hipertensao]).

    %printar em ordem decrescente de probabilidade
