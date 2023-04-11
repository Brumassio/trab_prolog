:- consult('sintomas.pl').

printa_lista(Lista) :-
    write('Sintomas do paciente: '), nl,
    write(Lista), nl.

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

% cadastrar paciente no arquivo .txt
input_do_paciente(Nome, Idade) :-
    write('Digite o nome do paciente: '),
    read(Nome),
    write('Digite a idade do paciente: '),
    read(Idade).

% Filtra as listas de sintomas para obter apenas as que estão nas respostas do paciente
intersect(Lista1, Lista2, R) :-
    findall(X, (member(X, Lista1), member(X, Lista2)), R).

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
        (   
            NomeA == Nome,
            IdadeA2 == Idade
        ->  
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

% Deixa em porcentagem a probabilidade de cada doença
multiplica_por_100([], []).
multiplica_por_100([[Probabilidade, Doenca] | Resto], [[ProbabilidadeMultiplicada, Doenca] | ProbsMultiplicadas]) :-
    ProbabilidadeMultiplicada is (Probabilidade * 100),
    multiplica_por_100(Resto, ProbsMultiplicadas).

% Calcula a probabilidade de cada doença e pega a lista com os Sintomas em Comum
probabilidade_sintomas(Doenca, Sintomas, Probabilidade) :-
    sintomas(Doenca, SintomasDoenca),
    probabilidade(Doenca, ProbabilidadeGlobal),
    intersection(Sintomas, SintomasDoenca, SintomasComuns),
    length(SintomasComuns, Tamanho),
    length(SintomasDoenca, Total),
    Probabilidade is (Tamanho / Total) * ProbabilidadeGlobal.

% Imprime as probabilidades : doencça - probabilidade
imprime_probs([]).
imprime_probs([[Prob, Doenca] | Resto]) :-
    format('~w - Probabilidade: ~w%~n', [Doenca, Prob]),
    imprime_probs(Resto).

ordenar_por_probabilidade_decrescente(Lista, ListaOrdenada) :-
    sort(1, @>=, Lista, ListaOrdenada).

% Predicado principal que chama todos os outros relacionados a probabilidade
main_probabilidade(ListaRespostas, ListaAux) :-
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
    Probs = [[ProbabilidadeGripe,gripe], [ProbabilidadeResfriado, resfriado], [ProbabilidadeCovid, covid_19], [ProbabilidadeAsma, asma], [ProbabilidadeBronquite, bronquite], 
    [ProbabilidadePneumonia, pneumonia], [ProbabilidadeDengue,dengue], [ProbabilidadeZika, zika], [ProbabilidadeChikungunya, chikungunya], [ProbabilidadeDiabetes, diabetes],
    [ProbabilidadeHipertensao, hipertensao]],
    ordenar_por_probabilidade_decrescente(Probs, ProbsOrdenadas),
    multiplica_por_100(ProbsOrdenadas,ProbFinal),
    imprime_probs(ProbFinal),nl,
    write('o resultado do prototipo eh apenas informativo e que o paciente deve consultar um medico para obter um diagnostico correto e preciso.'), nl,
    solicitar_sintomas_nao_informados(ListaDeSintomas).

% Define os sintomas que o paciente não informou
solicitar_sintomas_nao_informados(ListaPaciente):-
    write('Deseja mais informacoes sobre o diagnostico de alguma doenca ? (sim/nao)'), nl,
    read(Resposta),
    (   Resposta == sim
    ->  write('Informe a doenca:'), nl,
        read(Doenca),
        sintomas(Doenca, SintomasDoenca),
        intersection(ListaPaciente, SintomasDoenca, SintomasComuns),
        write('\nSintomas que o paciente apresenta da doenca '), write(Doenca), write(': '), write(SintomasComuns), nl,
        subtract(SintomasDoenca, SintomasComuns, SintomasNaoComuns),
        write('\nSintomas que o paciente nao apresenta da doenca '), write(Doenca), write(': '), write(SintomasNaoComuns), nl,nl,
        solicitar_sintomas_nao_informados(ListaPaciente)
    ;  true
    ).