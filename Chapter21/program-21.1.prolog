mastermind(Code) :-
    cleanup, guess(Code), check(Code), announce.

guess(Code) :-
    Code = [X1,X2,X3], selects(Code,[1,2,3,4]).

/*  Verify the proposed guess    */

check(Guess) :-
    not inconsistent(Guess), ask(Guess).

inconsistent(Guess) :-
    query(OldGuess,Bulls,Cows),
    not bulls_and_cows_match(OldGuess,Guess,Bulls,Cows).

bulls_and_cows_match(OldGuess,Guess,Bulls,Cows) :-
    exact_matches(OldGuess,Guess,N1),
    Bulls =:= N1,
    common_members(OldGuess,Guess,N2),
    Cows =:= N2 - Bulls.

exact_matches(X,Y,N) :-
    size_of(A,same_place(A,X,Y),N).

common_members(X,Y,N) :-
    size_of(A,(member(A,X),member(A,Y)),N).

same_place(X,[X|Xs],[X|Ys]).
same_place(A,[X|Xs],[Y|Ys]) :- same_place(A,Xs,Ys).

/*   Asking a guess	*/

ask(Guess) :-
    repeat,
    writeln(['How many bulls and cows in ',Guess,'?']),
    read((Bulls,Cows)),
    sensible(Bulls,Cows), !,
    assert(query(Guess,Bulls,Cows)),
    Bulls =:= 4.

sensible(Bulls,Cows) :-
    integer(Bulls), integer(Cows), Bulls + Cows =< 4.

/*    Bookkeeping     */

cleanup :- abolish(query,3).

announce :-
    size_of(X,query(X,A,B),N),
    writeln(['Found the answer after ',N,' queries']).

size_of(X,Goal,N) :-
    findall(X,Goal,Instances), length(Instances,N).

selects([X|Xs],Ys) :-
    select(X,Ys,Ys1),selects(Xs,Ys1).
selects([],Ys).

select(X,[X|Xs],Xs).
select(X,[Y|Ys],[Y|Zs]) :-
    select(X,Ys,Zs).

length(Xs,N) :- length(Xs,0,N).
length([X|Xs],Acc,N) :-
    Acc1 is Acc + 1,
    length(Xs,Acc1,N).
length([],N,N).

%   Program 21.1  Playing mastermind
