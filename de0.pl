/*BASE DE CONOCIMIENTO*/
trabaja(linguini, gusteaus).
trabaja(colette, gusteaus).
trabaja(horst, gusteaus).
trabaja(skinner, gusteaus).
trabaja(amelie, cafeDes2Moulins).
/*Agregamos para completar con mejores consultas*/
trabaja(guille, cafeDes2Moulins).
trabaja(gise, cafeMargot).


cocina(linguini,ratatouille,3).
cocina(linguini,sopa,5).
cocina(colette,salmonAsado,8).
cocina(horst,ensaladaRusa,8).

/*Agregamos para completar con mejores consultas*/
cocina(amelie, raclette, 8).
cocina(guille, pizza,10).
cocina(guille, milangaConFritas,10).
cocina(amelie, pizza, 1). 

rata(remy, gusteaus).
rata(emile, chezMilleBar).
rata(django, pizzeriaJeSuis).


tutor(amelie, skinner).
tutor(linguini, Rata) :- 
    rata(Rata, Vivienda), 
    trabaja(linguini, Vivienda).


/* PUNTO 1 ==> Guille */
/* menu/2: un plato y un restaurante, por ejemplo: menu(ratatouille,gusteaus). */
/* esta en el menu cuando alguno de sus chefs lo sabe cocinar*/ 
/* 
 * Importante a mencionar! Tips para el modelo-modelado de la base de conocimientos. La importancia de probar y CAMBIAR. Algunos smells a mencionar:
    - Leer todo el enunciado antes de arrancar
    - Si se la pasan haciendo findall + elem ==> 120% que NO ERA POR AHÍ!
    - Las respuestas "repetidas" NO son un problema
    - Probar siempre el paso a paso, leer los errores y mostrar que funciona
    - Probar siempre una consulta individual como primer prueba (con todo ligado!) antes que la existencial
*/
menu(Plato, Restaurante):-
    trabaja(Chef, Restaurante),
    cocina(Chef, Plato, _).

                                                 
/* PUNTO 2 ==> Gise */

/* cocinaBien(colette,salmonAsado).*/
/*
 * Importante para mencionar:
    - Los ó como nuevas cláusulas
    - Ojo con el principio de universo cerrado, a veces me dan info que lo que tengo que hacer es nada
*/
cocinaBien(Cocinere, Plato):-
    cocina(Cocinere, Plato, Experiencia),
    Experiencia > 7.
cocinaBien(Cocinere, Plato):-
    tutor(Cocinere, Tutor),
    cocinaBien(Tutor, Plato).
cocinaBien(remy, _).

/* PUNTO 3 ==> Guille */ 
/*
    chef(remy, gusteaus).  ==> chef(Cocinere, Restaurante).
 * Importante para mencionar:
    - forall: Condición ++ consecuencia
        - Para todo los ¿qué? lo que no llega ligado (los platos)
        - ¿Que le tiene que pasar? ==> condición (que ese cocinere los cocine bien)
    - tip: leer el forall "en voz alta":
        - para todos los PLATOS de ese restaurante, ese COCINERE los cocina bien 
        (vs)
        - para todo lo que el cocinere COCINA BIEN, está en el menú del restaurante
    - Posibles problemas de inversibilidad: al forall tiene que llegar ligado todo lo que no queres "que cambie" (en nuestro caso Cocinere y Restaurante, pero NUNCA platos)
    - (si sale recordar antecedente falso ==> consecuente verdadero) 
    - refactorear y delegar en otros predicados! para no repetir el trabaja: tener un esRespetado
*/
chef(Cocinere, Restaurante) :-
    trabaja(Cocinere, Restaurante),
    forall(menu(Plato, Restaurante), cocinaBien(Cocinere, Plato)).

chef(Cocinere, Restaurante) :-
    trabaja(Cocinere, Restaurante),
    findall(Experiencia,cocina(Cocinere,_,Experiencia),Experiencias),
    sumlist(Experiencias, Total),
    Total >=20.


/*

chef(Cocinere, Restaurante) :-
    trabaja(Cocinere, Restaurante),
    esRespetade(Cocinere, Restaurante).
    
esRespetade(Cocinere, Restaurante):-
   forall(menu(Plato, Restaurante), cocinaBien(Cocinere, Plato)).
 
 esRespetade(Cocinere, _):-
    findall(Experiencia,cocina(Cocinere,_,Experiencia),Experiencias),
    sumlist(Experiencias, Total),
    Total >=20.
*/

/* PUNTO 4: Gise */
/*
  * aCargo(colette, salmonAsado, gusteaus). ==> aCargo(Cocinere,Plato,Restaurante).
  * Importante para mencionar:
    - forall: antecedente y consecuente: TIP LEER EN VOZ ALTA
    - inversibilidad
    - delegar
*/


aCargo(Cocinere, Plato, Restaurante):-
    trabaja(Cocinere, Restaurante),
    cocina(Cocinere, Plato, Experiencia),
    forall((trabaja(Otre, Restaurante), Cocinere \= Otre, cocina(Otre, Plato, ExperienciaOtre)), Experiencia > ExperienciaOtre).


/*
aCargo(Cocinere, Plato, Restaurante):-
    trabaja(Cocinere, Restaurante),
    cocina(Cocinere, Plato, Experiencia),
    forall(experienciaDeCompaniereCocinando(Plato, Cocinere, ExperienciaOtre), Experiencia > ExperienciaOtre).
experienciaDeCompaniereCocinando(Plato, Companiere, Experiencia):-
    trabaja(Companiere, Restaurante),
    trabaja(Cocinere, Restaurante),
    Cocinere \= Companiere, 
    cocina(Cocinere, Plato, Experiencia).
*/


/* Punto 5: Guille */
/* saludable/1: saludable(bifeDeChorizo).
 * Importante a mencionar 
   - polimorfismo
   - pattern matching con functores
   - delegación
   - que no se puede MUTAR CaloriasBase is Calorias * 5 NOOOO Calorias is Calorias * 5 (salvo el 0 es siempre false!!!!)
   - universo cerrado no nos ayuda
   - caloriasGuarnicion ¡son hechos!
 */

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(ensaladaMixta, entrada([lechuga, tomate, cebolla])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(ratatouille, principal(pure, 10)).
plato(frutillasConCrema, postre(265)).
plato(ensaladaDeFrutas, postre(74)).

saludable(Plato):-
    plato(Plato, Info),
    calorias(Info, Calorias),
    Calorias < 75.

calorias(entrada(Ingredientes), Calorias) :- 
    length(Ingredientes, Cantidad),
    Calorias is Cantidad * 15.

calorias(principal(Guarnicion, Tiempo), Calorias):-
    CaloriasBase is Tiempo * 5,
    caloriasGuarnicion(Guarnicion, CaloriasGuarnicion),
    Calorias is CaloriasBase + CaloriasGuarnicion.

calorias(postre(Calorias), Calorias).

caloriasGuarnicion(pure, 20).
caloriasGuarnicion(fritas, 50).
caloriasGuarnicion(ensalada, 0).

/* Punto 6: Gise */
/*
 * reseniaPositiva(antonEgo, gusteaus). ==> /2 critico con restaurante
Marcar:
    - pide a gritos la delegación
    - posible problema de inveribilidad, seCumpleCriterio tiene que ser inversible
    - generamos con MENU que es exacto lo que necesitamos (para anton)
    - habla de CHEF no son los cocineres son los CHEFS
    - universo cerrado (por gordon ramsey!)
    - picardía en generar en el momento adecuado: "El orden no importa salvo que esté adentro de la cláusula ahi lamentablemente me importa."
 */

reseniaPositiva(Critico, Restaurante) :-
    seCumpleCriterio(Critico, Restaurante),
    not(rata(_, Restaurante)).

/*Anton Ego espera, además, que en el lugar sean especialistas preparando ratatouille. Un restaurante es especialista en aquellos platos que todos sus chefs saben cocinar bien.*/
especialistas(Plato, Restaurante) :-
    menu(Plato, Restaurante),
    forall(chef(Chef, Restaurante), cocinaBien(Chef, Plato)).

seCumpleCriterio(antonEgo, Restaurante):- especialistas(ratatouille, Restaurante).
seCumpleCriterio(cormillot, Restaurante) :-
    menu(_, Restaurante),
    forall((trabaja(Cocinere, Restaurante), cocina(Cocinere, Plato, _)), saludable(Plato)).
/* seCumpleCriterio(cormillot, Restaurante) :- cocinanSoloSaludable(Restaurante).*/
seCumpleCriterio(martiniano, Restaurante):-
    trabaja(Cocinere, Restaurante),
    findall(Trabajador, trabaja(Trabajador, Restaurante), [Cocinere]).

