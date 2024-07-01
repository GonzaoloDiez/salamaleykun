/*animal(Nombre,Clase, Medio)*/
% animal(ballena,mamifero,acuatico).
% animal(tiburon,pez,acuatico).
% animal(lemur,mamifero,terrestre).
% animal(golondrina,ave,aereo).
% animal(tarantula,insecto,terrestre).
% animal(lechuza,ave,aereo).
% animal(orangutan,mamifero,terrestre).
% animal(tucan,ave,aereo).
% animal(puma,mamifero,terrestre).
% animal(abeja,insecto,aereo).
% animal(leon,mamifero,terrestre).

/* tiene(Quien, Que, Cuantos)*/
tiene(nico, ballena, 1).
tiene(nico, lemur, 2).
tiene(maiu, lemur, 1).
tiene(maiu, tarantula, 1).
tiene(juanDS, golondrina, 1).
tiene(juanDS, lechuza, 1).
tiene(juanR, tiburon, 2).
tiene(nico, golondrina, 1).
tiene(juanDS, puma, 1).
tiene(maiu, tucan, 1).
tiene(juanR, orangutan,1).
tiene(maiu,leon,2).
tiene(juanDS,lagartija,1).
tiene(feche,tiburon,1).


% leGusta/2
leGusta(nico,Animal):-
    animal(Animal,_,terrestre), Animal\=lemur.
leGusta(maiu,abeja).
leGusta(maiu,Animal):-
    animal(Animal,Raza,_),Raza\=insecto.    
leGusta(juanDS,Animal):-
    animal(Animal,_,acuatico).
leGusta(juanDS,Animal):-
    animal(Animal,ave,_).
leGusta(juanR,Animal):-
    tiene(juanR,,Animal,_).
leGusta(feche,lechuza).

% animalDificil/1: si nadie lo tiene, o bien si una sola persona tiene uno solo.
animalDificil(Animal):- tiene(Persona,Animal,1),not((tiene(OtraPersona,Animal,_),Persona\=OtraPersona)).
animalDificil(Animal):- nadieLoTiene(Animal).

nadieLoTiene(Animal):- animal(Animal,_,_), not(tiene(_,Animal,_)).
% estaFeliz/1: si le gustan todos los animales que tiene.
estaFeliz(Persona):- tiene(Persona,_,_),not((tiene(Persona,Animal,_),not(leGusta(Persona,Animal)))).
estaFeliz(Persona):- tiene(Persona,_,_),forall(tiene(Persona,Animal,_), leGusta(Persona,Animal)).

animal(lagartija,reptil,terrestre).
animal(dragon,reptil,aereo).

tiene(yo,lagartija,3).
tiene(yo,dragon,1).

tiene(el,dragon,8).
%tiene(el,lechuza,1).
% tieneTodosDe/2: si la persona tiene todos los animales de ese medio o clase.
tieneTodosDe(Persona,Clase):-tiene(Persona,_,_),animal(_,Clase,_),forall(tiene(Persona,Animal,_),animal(Animal,Clase,_)).

tieneTodosDe(Persona,Medio):-tiene(Persona,_,_),animal(_,_,Medio),forall(tiene(Persona,Animal,_),animal(Animal,_,Medio) ).
% completoLaColeccion/1: si la persona tiene todos los animales.
completoLaColeccion(Persona):-tiene(Persona,_,_),forall(animal(Animal,_,_),tiene(Persona,Animal,_)).
% delQueMasTiene/2: si la persona tiene más de este animal que del resto.
delQueMasTiene(Persona,Animal):-tiene(Persona,Animal,Cant),
    not((
        tiene(Persona,OtroAnimal,OtraCant),
        OtraCant>Cant,
        Animal\=OtroAnimal
    )).

tieneParaCambiar(Persona,Animal):- tiene(Persona,Animal,_),not(leGusta(Persona,Animal)).
tieneParaCambiar(Persona,Animal):- tiene(Persona,Animal,Cant),Cant>1.
tieneParaCambiar(juanR,Animal):-tiene(juanDS,Animal,_).%????

tieneParaOfrecer(Vendedor,Comprador):- tieneParaCambiar(Vendedor,Animal),leGusta(Comprador),not(tiene(Comprador,Animal,_)),

puedenNegociar(Persona1,Persona2):-tieneParaCambiar(Persona1,Persona2),tieneParaCambiar(Persona2,Persona1).

manejaElMercado(Vendedor,Comprador)