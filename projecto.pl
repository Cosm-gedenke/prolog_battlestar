% lp24 - Leonardo Guerreiro ist1114011 - projecto 
:- use_module(library(clpfd)). % para poder usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- [puzzles]. % Ficheiro dado. A avaliação terá mais puzzles.
:- [codigoAuxiliar]. % Ficheiro dado. Não alterar.
% Atenção: nao deves copiar nunca os puzzles para o teu ficheiro de código
% Nao remover nem modificar as linhas anteriores. Obrigado.
% Segue-se o código
%%%%%%%%%%%%

% visualiza(Tabuleiro)
% predicado que sera verdadeiro caso a lista seja uma lista 
% e seja possivel escrever linha por linha cada elemento da lista

visualiza([]).
visualiza([X|Xs]):- write(X), nl, visualiza(Xs).


% visualizaLinha(Tabuleiro)
% predicado que sera verdadeiro caso a lista seja uma lista
% e seja possivel escrever linha por linha cada elemento da lista
% com o detalhe de adicionar um o numero da linha um : e um espaço antes de demonstrar o elemento

visualizaLinha(X):-visualizaLinha(X, 0).
visualizaLinha([], _).
visualizaLinha([X|Xs], Acc):-
    Acc1 is Acc+1,
    write(Acc1),
    write(:),
    write(' '),
    write(X),
    nl,
    visualizaLinha(Xs, Acc1).

% insereObjecto((L,C), Tabuleiro, Obj), (L,C) sao coordenadas que começam em 1
% sera verdadeiro se o tabuleiro forr um tabuleiro e que apos a aplicacao deste predicado
% passa a ter o objecto nas coordenadas (L,C) caso nestas se encontre uma variavel
% nao falha se tiver uma variavel

insereObjecto((L, C), Tab, Obj) :-
    nth1(L, Tab, L1), 
    nth1(C, L1, Elem),
    
    % verifica se e uma variavel e unifica
    
    var(Elem),
    Elem = Obj, !.
% caso geral para nunca falhar    
insereObjecto(_, _, _).

% insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs)
% sera verdadeiro caso ListaCoords forr uma lista de coordenadas, ListaObjs uma lista de objectos
% e Tabuleiro um tabuleiro que apos a aplicacao doo predicado passa a ter nas coordenadas
% ListaCoords os objectos de ListaObjs. tem de ter o mesmo tamanho e sao percorridas ao mesmo tempo.
% nao falha se nao forr possivel inserir o objeto e passa para a proxima


insereVariosObjectos([], _, []).
insereVariosObjectos([Cord|Restocord], Tab,[Obj|Restoobj]):-  
    % verificamos a dimensao das listas com o predicado same_length
    
    same_length(Restocord, Restoobj),
    
    % o insereobjecto garante que retorna sempre true
    
    insereObjecto(Cord, Tab, Obj),
    insereVariosObjectos(Restocord, Tab, Restoobj), !.

% inserePontosVolta(Tabuleiro, (L,C))
% predicado que sera verdade se Tabuleiro e um tabuleiro que apos a aplicacao doo predicado, passa a ter
% pontos (p) a volta das coordenadas (L,C)

inserePontosVolta(Tab, (L,C)):-
    L1 is L-1,
    L2 is L+1,
    C1 is C-1,
    C2 is C+1,
    
    % inserimos o objeto em todas as posicoes, começando noo sentido horario na posicao diagonal 
    % noo canto superior esquerdo, em relacao as coordenadas
    
    insereObjecto((L1, C1), Tab, p),
    insereObjecto((L1, C), Tab, p),
    insereObjecto((L1, C2), Tab, p),
    insereObjecto((L, C2), Tab, p),
    insereObjecto((L2, C2), Tab, p),
    insereObjecto((L2, C), Tab, p),
    insereObjecto((L2, C1), Tab, p),
    insereObjecto((L, C1), Tab, p), !.

% inserePontos(Tabuleiro, ListaCoord)
% e verdade se Tabuleiro e um tabuleiro que, apos a aplicacao doo predicado, passa a ter
% pontos (p) em todas as coordenadas de ListaCoord
% se em alguma coordenada existir um objecto que nao seja uma variavel, salta em frente

inserePontos(Tab, [Cord]):- \+ verificaatomovazio(Tab, Cord),!.
inserePontos(Tab, [Cord]):- verificaatomovazio(Tab, Cord), insereObjecto(Cord, Tab, p).

% o verificaatomovazio, predicado escrito mais a baixo no projeto, serve somente para determinar
% se saltamos ou nao para a proxima Cord

inserePontos(Tab, [Cord|Resto]):- 
    verificaatomovazio(Tab, Cord),
    insereObjecto(Cord, Tab, p), 
    inserePontos(Tab, Resto), !.
inserePontos(Tab, [Cord|Resto]):- \+ verificaatomovazio(Tab, Cord), inserePontos(Tab, Resto).

% objectoEmCoordenada(Obj, Tabuleiro, (L,C))
% predicado auxiliar que sera verdade se o Tabuleiro forr um objeto e se na coordenada (L,C)
% estiver realmente la o objeto Obj

objectoEmCoordenada(Obj, Tab, (L,C)):-
    L >= 1,
    C >= 1,
    nth1(L, Tab, L1),
    length(Tab,Ltamannho),
    length(L1, Ctamanho),
    L =< Ltamannho,
    C =< Ctamanho,
    nth1(C, L1, Obj).

% verificaatomovazio(Tabuleiro, (L,C))
% predicado auxiliar que sera verdade se o Tabuleiro forr um objeto e se na coordenada (L,C)
% estiver realmente la um atomo vazio

verificaatomovazio(Tab, (L,C)):-
    L >= 1,
    C >= 1,
    nth1(L, Tab, L1),
    length(Tab,Ltamannho),
    length(L1, Ctamanho),
    L =< Ltamannho,
    C =< Ctamanho,
    nth1(C, L1, Obj),
    var(Obj).
    
% objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs)
% predicado que e verdade se listaObjs forr a lista de objectos das coordenadas ListaCoords 
% no tabuleiro Tabuleiro, apresentados na mesma ordem das coordenadas
% falha se alguma coordenada nao pertence

objectosEmCoordenadas([], _, []).
objectosEmCoordenadas([Cord|RestoCord], Tabuleiro, [Obj|RestoObj]):-
    % o objectoemcoordenada ja verifica se a coordenada pertence
    objectoEmCoordenada(Obj, Tabuleiro, Cord),
    objectosEmCoordenadas(RestoCord, Tabuleiro, RestoObj).

% o objectoemcordenadagoal existe de forma a evitar o problema de o Elemento ser uma variavel.
% como, por minha observacao, pretendo utilizar um include para evitar dificuldade a ler, atraves de um metodo recursivo
% decidi implementar o goal que evita qualquer problema

objectoEmCoordenadaGoal(Obj, Tabuleiro, (L,C)):-
    L >= 1,
    C >= 1,
    nth1(L, Tabuleiro, L1),
    length(Tabuleiro,Ltamannho),
    length(L1, Ctamanho),
    L =< Ltamannho,
    C =< Ctamanho,
    nth1(C, L1, Elem),
    \+ var(Elem),
    Obj=Elem.

% coordObjectos(Objeto, Tabuleiro, ListaCoords, ListaCoordsobjs, NumObjectos)
% e verdade se Tabuleiro for um tabuleiro, ListaCoords uma lista de coordenadas e ListaCoordsobjs 
% a sublista de ListaCoords que contem as coordenadas dos objectos do tipo objecto, tal como ocorrem no tabuleiro
% NumObjectos e o numero de objectos Objecto encontrado

coordObjectos(Obj, Tab, ListaCoords, ListaCoordsobjs, NumObjectos):-
    \+ var(Obj), 
    include(objectoEmCoordenadaGoal(Obj, Tab), ListaCoords, ListaCoordsobjs),
    length(ListaCoordsobjs, Count),
    NumObjectos = Count, !.
    
% dois casos vaso Obj seja uma variavel ou nao, cada uma utiliza auxiliares diferentes no include

coordObjectos(Obj, Tab, ListaCoords, ListaCoordsobjs, NumObjectos):-
    var(Obj),
    include(verificaatomovazio(Tab), ListaCoords, ListaCoordsobjs),
    length(ListaCoordsobjs, Count),
    NumObjectos = Count, !.

% coordenadaVars(Tabuleiro, ListaVars)
% e verdade se ListaVars forem as coordenadas das variaveis do tabuleiro Tabuleiro.
% mais uma vez, ListaVars deve estar ordenada por linhas e colunas.

coordenadasVars(Tab, ListaVars):-
    length(Tab, Cont),
    coordLinhas(Cont, Coordlinhas),
    % o flatten facilita a utilizacao do include
    flatten(Coordlinhas, Coordtotais),
    include(verificaatomovazio(Tab), Coordtotais, ListaCoordsobjs),
    ListaVars=ListaCoordsobjs.

% fechaListaCoordenadas(Tabuleiro, ListaCoord)
% e verdade se Tabuleiro for um tabuleiro e ListaCoord for uma lista de coordenadas
% apos a aplicacao do predicado, as coordenadas de ListaCoord deverao ser apenas estrelas e pontos
% considerando as hipoteses definidas no enunciado(h1-h2-h3)

fechaListaCoordenadas(Tab, ListaCoord):-
    % verifica os casos todos (h1,h2,h3) e se nenhum deles se verificar continua true(nao falha)
    (coordObjectos(e, Tab, ListaCoord, _, Numestrelas),
    2=Numestrelas,
    inserePontos(Tab, ListaCoord), !);
    (coordObjectos(e, Tab, ListaCoord, _, Numestrelas),
    coordObjectos(_, Tab, ListaCoord, Coordslivre, Numlivre),
    1=Numlivre,
    1=Numestrelas,
    nth1(1, Coordslivre, Coord),
    insereObjecto(Coord, Tab, e),
    inserePontosVolta(Tab, Coord), !);
    (coordObjectos(e, Tab, ListaCoord, _, Numestrelas),
    coordObjectos(_, Tab, ListaCoord, Coordslivre, Numlivre),
    2=Numlivre,
    0=Numestrelas,
    insereVariosObjectos(Coordslivre, Tab, [e, e]),
    nth1(1, Coordslivre, Coord1),
    nth1(2, Coordslivre, Coord2),
    inserePontosVolta(Tab, Coord1),
    inserePontosVolta(Tab, Coord2), !);
    true, !.

% fecha(Tabuleiro, ListaListaCoords)
% e verdade se Tabuleiro for um tabuleiro e ListaListaCoords for uma lista de listas de coordenadas
% apos a aplicacao deste predicado, tabuleiro e o resultado de aplicar o fechalistaCoordenadas
% a todas as listas de coordenadas

fecha(_, []):- !.
fecha(Tab, [ListaCoord|RestoCoord]):- fechaListaCoordenadas(Tab, ListaCoord), !, fecha(Tab, RestoCoord). 


% encontraSequencia(Tabuleiro, N, ListaCoords, Seq)
% e verdade se Tabuleiro for um tabuleiro, ListaCoords for uma lista de coordenadas e N o tamanho de Seq
% que e uma sublista de ListaCoords que verifica o seguinte:

% as suas coordenadas representam posicoes com variaveis;
% as suas coordenadas aparecem seguidas(linha, coluna, regiao);
% Seq pode ser concatenada antes e depois de maneira a obter ListaCoords

% falha se tiver mais variaveis na sequencia que N

encontraSequencia(Tab, N, ListaCoords, Seq):-
    coordObjectos(e, Tab, ListaCoords, _, 0),
    coordObjectos(_, Tab, ListaCoords, Seq, N),
    append([_, Seq, _], ListaCoords), !.

% aplicaPadraoI(Tabuleiro, Seq)
% e verdade se Tabuleiro for um tabuleiro e Seq for uma lista de coordenadas de tamanho 3
% apos a aplicacao deste predicado, Tabuleiro sera o resultado de colocar uma estrela na primeira
% e terceira posicao e os obrigatorios pontos p a volta de cada estrela

aplicaPadraoI(Tab, Seq):-
    length(Seq, Cont),
    3=Cont,
    nth1(1, Seq, Cord1),
    nth1(3, Seq, Cord2),
    insereObjecto(Cord1, Tab, e),
    insereObjecto(Cord2, Tab, e),
    inserePontosVolta(Tab, Cord1),
    inserePontosVolta(Tab, Cord2), !.

% aplicaPadroes(Tabuleiro, ListaListaCoords)
% e verdade se Tabuleiro for um tabuleiro, ListaListaCoords for uma lista de listas com coordenadas
% apos a aplicacao deste predicado ter-se-ao encontrado sequencias de tamanho 3
% e aplicado o aplicaPadraoI\2 ou sequencias de tamanho 4 e aplicado o aplicaPadraoT\2.

aplicaPadroes(_, []).
aplicaPadroes(Tab, [ListaCoord| RestoListaCoords]):-
    % verifica ambos os casos e continua a iterar recursivamente caso nenhum se verifique
    % o caso base confirma que de true no final independemente de haver alguma sequencia possivel ou nao

    (encontraSequencia(Tab, 4, ListaCoord, Seq),
    aplicaPadraoT(Tab, Seq), aplicaPadroes(Tab, RestoListaCoords));
    (encontraSequencia(Tab, 3, ListaCoord, Seq),
    aplicaPadraoI(Tab, Seq), aplicaPadroes(Tab, RestoListaCoords));
    aplicaPadroes(Tab, RestoListaCoords).

% resolveaux(Estruturas, Tab)
% auxiliar e verdade se  aplicaPadroes\2,fecha\2 e resolve\2 forem verdadeiros(nota que o resolve\2 funciona recursivamente)

resolveaux(Estrutura, Tab):-
    coordTodas(Estrutura, CooordTodas),
    aplicaPadroes(Tab, CooordTodas),
    fecha(Tab, CooordTodas),
    resolve(Estrutura, Tab), !.

% resolve(Estruturas, Tabuleiro)
% e verdade se Estrutura for uma estrutura e Tabuleiro for um tabuleiro que resulta de aplicar os predicados
% aplicaPadroes\2 e fecha\2 ate ja nao haver mais alteracoes nas variaveis do tabuleiro
% nao resolve todos os casos ate ao fim

resolve(Estrutura, Tab):-
    coordenadasVars(Tab, Vars1),
    visualizaLinha(Tab),
    
    % duplicamos o Tab

    duplicate_term(Tab, NovoTab),
    
    % aplicamos os predicados aplicaPadroes\2 e o fecha\2 no novoTab(nao utilizamos resolveaux pois isso usa o resolve\2)
    
    coordTodas(Estrutura, CooordTodas),
    aplicaPadroes(NovoTab, CooordTodas),
    fecha(NovoTab, CooordTodas),
    coordenadasVars(NovoTab, Vars2),
    length(Vars1, Cont1),
    length(Vars2, Cont2),
    
    % verificamos se o tamanho e igual entre Vars1 e Vars2 do Tab e do NovoTab 
    % existe a necessidade de usar o ->(o unico do meu projeto!, para evitar que o prolog use variaveis nao instaciadas)
    % (e acabe por igualar Cont1 a Cont2)
    (Cont1 =:= Cont2 -> true, !;
    resolveaux(Estrutura, Tab), !).




    
    


