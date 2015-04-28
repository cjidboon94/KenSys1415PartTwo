%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Joram Wessel  -  10631542   %%%%
%%% Cornelis Boon -  10561145   %%%%
%%% Assignment 4 Kennissystemen %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- op(300, yfx, before).
:- op(300, fx, after).
:- dynamic isBefore/2.
:- dynamic event/1.
:- dynamic isAfter/2.



go1:-
	killall,
	assert(event(a)),
	assert(event(b)),
	assert(event(c)),
	assert(isBefore(a, b)),
	assert(isAfter(b, c)),
	assert(isAfter(a, c)).

killall:-
	retractall(event(_)),
	retractall(isBefore(_,_)),
	retractall(isAfter(_,_)).


%Dummy events and relations.
event(a).
event(b).
event(c).
event(e).
isBefore(a, b).
isBefore(b, c).
isAfter(d, c).
isAfter(e, c).
isAfter(a, h).

isConcurrent(b, f).
isConcurrent(g, h).
isConcurrent(X,X):- event(X).

isEvent(X, Y):- 
	event(X), 
	event(Y).


before(X, Y):- isEvent(X, Y), isBefore(X, Y), !.
before(X, Y):- isEvent(X, Y), isAfter(Y, X), !.

before(X, Y):-
	isEvent(X, Y),
	(isBefore(X, Z); isAfter(Z, X)),
	before(Z, Y), !, assertNewRelation([isBefore, X, Y]), assertNewRelation([isAfter, Y, X]).

assertNewRelation(L):-
	Fact .. L,
	assert(Fact).

concurrent(X, Y):- isEvent(X, Y), isConcurrent(X, Y), !.

concurrent(X, Y):-
	\+ before(X, Y),
	\+ after(X, Y), !, .



after(X, Y):-
	before(Y, X).