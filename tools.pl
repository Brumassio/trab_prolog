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

% Definir o predicado que verifica se uma lista eh um subconjunto de outra lista
subconjunto([], _).
subconjunto([X|Xs], Set) :-
    member(X, Set),
    subconjunto(Xs, Set).


multiplica_lista([], _, []).
multiplica_lista([X|Xs], Valor, [Y|Ys]) :-
    Y is X * Valor,
    multiplica_lista(Xs, Valor, Ys).


% probabilidade_sintomas(Doenca,Sintomas, Probabilidade) :-
%     sintomas(Doenca, SintomasDoenca),
%     probabilidade(Doenca, ProbabilidadeGlobal),
%     length(SintomasDoenca, Total),
%     length(Sintomas, Tamanho),
%     Probabilidade is (Tamanho / Total)*ProbabilidadeGlobal.

probabilidade_sintomas(Doenca, Sintomas, Probabilidade) :-
    sintomas(Doenca, SintomasDoenca),
    probabilidade(Doenca, ProbabilidadeGlobal),
    intersection(Sintomas, SintomasDoenca, SintomasComuns),
    length(SintomasComuns, Tamanho),
    length(SintomasDoenca, Total),
    Probabilidade is (Tamanho / Total) * ProbabilidadeGlobal.

imprime_doencas_ordenadas([], _, _).
imprime_doencas_ordenadas([ProbCabeca|Resto], ProbCabeca, [Cabeca|Doencas]) :-
    format('~w - Probabilidade: ~w%~n', [Cabeca, ProbCabeca]),
    imprime_doencas_ordenadas(Resto, _, Doencas).

% Predicado de comparação
compara_decrescente(Comp, X, Y) :-
    (X > Y -> Comp = (<) ; Comp = (>)).

% Exemplo de uso
ordenado_decrescente(Lista, Ordenada) :-
    predsort(compara_decrescente, Lista, Ordenada).