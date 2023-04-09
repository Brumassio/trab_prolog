:- consult('sintomas.pl').

:- discontiguous probabilidades/2.
:- discontiguous probabilidade_doenca/2.

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


% Funcao que calcula a probabilidade de uma doenca a partir de uma lista de sintomas
probabilidade_doenca(Sintomas, Probabilidade) :-
    % Verifica se a doenca tem os sintomas informados
    sintomas(Doenca, ListaSintomas),
    sublist(ListaSintomas, Sintomas),
    % Retorna a probabilidade da doenca
    probabilidade(Doenca, Probabilidade).

% Funcao que verifica se uma lista eh uma sublista de outra lista
sublist([], []).
sublist(_, []).
sublist(Sublist, [Head|Tail]) :-
    prefix(Sublist, [Head|Tail]).
sublist(Sublist, [_|Tail]) :-
    sublist(Sublist, Tail).
% Definir o predicado principal que recebe a lista de sintomas do paciente e retorna a probabilidade de cada doença
probabilidade_doenca(Sintomas, Probabilidade) :-
    findall(Prob, (sintomas(Doenca, SintomasDoenca), subconjunto(SintomasDoenca, Sintomas), probabilidade(Doenca, Prob)), Probabilidades),  
    sumlist(Probabilidades, Probabilidade).

checar_sintomas(Sintomas) :- % Sintomas = lista q o usuario respondeu SIM
    probabilidades(Doenca, Probabilidade),
    probabilidade_doenca(Sintomas, Doenca, Probabilidade),
    write('Probabilidade de ter '), write(Doenca), write(': '), write(Probabilidade), nl,
    fail.

% checar_sintomas(Paciente, Doenca) :-
%     sintomas(Doenca, Sintomas),
%     subset(Sintomas, Paciente).

% Definir o predicado que verifica se uma lista eh um subconjunto de outra lista
subconjunto([], _).
subconjunto([X|Xs], Set) :-
    member(X, Set),
    subconjunto(Xs, Set).

% probabilidade_doencas(SintomasUsuario, Probabilidades) :-
% findall(Doenca-Sintomas, sintomas(Doenca, Sintomas), Doencas),
% probabilidades_doencas(SintomasUsuario, Doencas, [], ProbabilidadesSemNormalizar),
% sum_list(ProbabilidadesSemNormalizar, SomatorioProbabilidades),
% maplist(dividir_pela_soma(SomatorioProbabilidades), ProbabilidadesSemNormalizar, Probabilidades).

% probabilidades_doencas(_, [], Probabilidades, Probabilidades).
% probabilidades_doencas(SintomasUsuario, [Doenca-Sintomas|RestoDoencas], ProbabilidadesAcumuladas, Probabilidades) :-
%     tem_sintomas_em_comum(SintomasUsuario, Sintomas),
%     probabilidades_doencas(SintomasUsuario, RestoDoencas, [Doenca-Probabilidade|ProbabilidadesAcumuladas], Probabilidades),
%     probabilidade(Doenca, ProbabilidadeDoenca),
%     Probabilidade is ProbabilidadeDoenca * multiplicar_probabilidades(SintomasUsuario, Sintomas).

% tem_sintomas_em_comum(SintomasUsuario, SintomasDoenca) :-
%     intersection(SintomasUsuario, SintomasDoenca, SintomasEmComum),
%     SintomasEmComum \= [].

% multiplicar_probabilidades(_, [], 1).
% multiplicar_probabilidades(SintomasUsuario, [Sintoma|RestoSintomas], Probabilidade) :-
%     multiplicar_probabilidades(SintomasUsuario, RestoSintomas, ProbabilidadeResto),
%     probabilidade_sintoma(Sintoma, ProbabilidadeSintoma),
%     (member(Sintoma, SintomasUsuario) -> Probabilidade is ProbabilidadeSintoma * ProbabilidadeResto ; Probabilidade is ProbabilidadeResto).

% probabilidade_sintoma(Sintoma, Probabilidade) :-
%     findall(Doenca, (sintomas(Doenca, SintomasDoenca), member(Sintoma, SintomasDoenca)), DoencasComSintoma),
%     maplist(probabilidade, DoencasComSintoma, Probabilidades),
%     sum_list(Probabilidades, Probabilidade).

% regra para obter as probabilidades gerais
probabilidades(Probs) :- findall(P, probabilidade(_,P), Probs).

% regra para calcular a probabilidade de uma doença com base na lista de sintomas e na lista de probabilidades globais
probabilidade_doenca(Sintomas, Probabilidade) :- 
    sintomas(Doenca, SintomasD),
    intersection(Sintomas, SintomasD, SintomasComuns),
    length(SintomasComuns, Tamanho),
    probabilidades(Probs),
    nth0(Index, Probs, P),
    length(SintomasD, Total),
    Probabilidade is Tamanho / Total * P,
    Index is Doenca-1.

% dividir_pela_soma(Somatorio, Valor, Valor/Somatorio).