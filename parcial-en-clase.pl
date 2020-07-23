/* Base de conocimiento */
trabaja(linguini, gusteaus).
trabaja(colette, gusteaus).
trabaja(horst, gusteaus).
trabaja(skinner, gusteaus).
trabaja(amelie, cafeDes2Moulins).
trabaja(guille, cafeDes2Moulins).

cocina(linguini,ratatouille,3).
cocina(linguini,sopa,5).
cocina(colette,salmonAsado,8).
cocina(colette,ratatouille,9).
cocina(horst,ensaladaRusa,8).
cocina(amelie, raclette, 8).
cocina(guille, pizza,10).
cocina(guille, milangaConFritas,10).
cocina(amelie, pizza, 1).

rata(remy, gusteaus).
rata(emile,chezMilleBar).
rata(django,pizzeriaJeSuis).

tutor(linguini, Rata):-
    rata(Rata, Lugar),
    trabaja(linguini, Lugar).
tutor(skinner, amelie).

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(ensaladaMixta, entrada([lechuga, tomate, cebolla])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(ratatouille, principal(pure, 10)).
plato(frutillasConCrema, postre(265)).
plato(ensaladaDeFrutas, postre(74)).

caloriasGuarnicion(pure, 20).
caloriasGuarnicion(papasFritas, 50).
caloriasGuarnicion(ensalada, 0). 

/* Punto 1 */
/* menu(ratatouille,gusteaus). ==> menu/2: Plato con un Restaurante */
menu(Plato, Restaurante) :-
    trabaja(Cocinero, Restaurante),
    cocina(Cocinero, Plato, _).

/* Punto 2 */
/* que es verdadero para 
 - una persona si su experiencia preparando ese plato es mayor a 7
 - si tiene un tutor que cocina bien el plato ( además que Amelie es la tutora de Skinner.)
 - también se sabe que remy cocina bien cualquier plato que exista
 - el resto de las ratas no cocina bien nada.
cocinaBien(sopa, horst). ==> cocinaBien(Plato, Cocinero).
*/
cocinaBien(Plato, Cocinero):- 
    cocina(Cocinero, Plato, Experiencia),
    Experiencia > 7.
cocinaBien(Plato, Cocinero) :-
    tutor(Cocinero, Tutor),
    cocinaBien(Plato, Tutor).
cocinaBien(Plato,remy):- cocina(_,Plato,_).
/* El resto de las ratas no cocina bien nada ==> POR UNIVERSO CERRADO NO HAY QUE HACER NADA :) */

/* Punto 3 */
/*chef(linguini, gusteaus). chef(Cocinero, Restaurante).*/
/*
Saber si alguien es chef de un restó. 
Los chefs son, 
    de los que trabajan en el restó, 
        - aquellos que cocinan bien todos los platos del menú
        - entre todos los platos que sabe cocinar suma una experiencia de al menos 20.
*/
chef(Cocinero, Restaurante):-
    trabaja(Cocinero, Restaurante),
    criterioChef(Cocinero, Restaurante).

criterioChef(Cocinero, Restaurante):- forall(menu(Plato, Restaurante),cocinaBien(Plato, Cocinero)).
criterioChef(Cocinero, _):- 
    findall(Experiencia, cocina(Cocinero,_,Experiencia), Experiencias),
    sumlist(Experiencias, Total),
    Total >= 20.

/* Punto 4 */
/* persona encargada de cocinar un plato en un restaurante, 
    - que es quien más experiencia tiene preparándolo en ese lugar.
    encargada(pizza, guille, cafeDes2Moulins). ==> encargada(Plato, Cocinero, Restaurante).
*/
encargada(Plato, Cocinero, Restaurante) :-
    trabaja(Cocinero, Restaurante),
    cocina(Cocinero, Plato, ExperienciaCocinando),
    forall(experienciaDeCompa(Cocinero, Restaurante, Plato, ExperienciaCompa),ExperienciaCocinando > ExperienciaCompa).

experienciaDeCompa(Cocinero, Restaurante, Plato, Experiencia):-
    trabaja(Compa, Restaurante), 
    Compa \= Cocinero,
    cocina(Compa, Plato, Experiencia).


/* Punto 5 */

saludable(Plato):-
    plato(Plato, Info),
    calorias(Info, Calorias),
    Calorias < 75.

calorias(entrada(Ingredientes),Calorias):-
    length(Ingredientes, CantidadIngredientes),
    Calorias is CantidadIngredientes * 15.

calorias(principal(Guarnicion,Tiempo), Calorias) :-
    CaloriasPorTiempo is Tiempo * 5,
    caloriasGuarnicion(Guarnicion, CaloriasGuarnicion),
    Calorias is CaloriasPorTiempo + CaloriasGuarnicion.

calorias(postre(Calorias), Calorias).

/* Punto 6 */
/*
reseniaPositiva(antonEgo, gusteaus). ==> reseniaPositiva(Critico, Restaurante).
*/

reseniaPositiva(Critico, Restaurante) :-
    cumpleCriterio(Critico, Restaurante),
    not(rata(_, Restaurante)).

cumpleCriterio(antonEgo, Restaurante):- especialistas(ratatouille, Restaurante).
cumpleCriterio(cormillot, Restaurante):- 
    menu(_,Restaurante),
    forall(menu(Plato, Restaurante),saludable(Plato)).
    /*forall((trabaja(Cocinere, Restaurante), cocina(Cocinere, Plato, _)), saludable(Plato)).*/
cumpleCriterio(martiniano, Restaurante):-
    chef(Alguien, Restaurante),
    findall(Trabajador, chef(Trabajador, Restaurante), [Alguien]).

/*Por universo cerrado se cumple que nadie cumple el criterio de gordonRamsey*/
especialistas(Plato, Restaurante) :- 
    menu(Plato, Restaurante),
    forall(chef(Chef, Restaurante),cocinaBien(Chef, Plato)).


