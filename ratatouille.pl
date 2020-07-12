/** Base de conocimiento */
rata(remy, gusteaus).
rata(emile, chezMilleBar).
rata(django,pizzeriaJeSuis).

cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5).
cocina(colette, salmonAsado, 9).
cocina(colette, sopa, 10).
cocina(horst, ensalaRusa, 8).

trabaja(linguini, gusteaus).
trabaja(colette, gusteaus).
trabaja(horst, gusteaus).
trabaja(skinner, gusteaus).
trabaja(amelie, cafeDes2Moulins).

/** 2. inspeccionSatisfactoria/1 se cumple para un restaurante cuando no viven ratas allí. */
inspeccionSatisfactoria(Restaurante) :- 
    trabaja(_,Restaurante),
    not(rata(_,Restaurante)).

/** 3. chef/2: relaciona un empleado con un restaurante si el empleado trabaja allí y sabe cocinar algún plato. */
chef(Cocinere, Restaurante) :-
    trabaja(Cocinere, Restaurante),
    cocina(Cocinere,_ ,_).

/** 4. chefcito/1: se cumple para una rata si vive en el mismo restaurante donde trabaja linguini. */
chefcito(Rata):-
    rata(Rata, Restaurante),
    trabaja(linguini, Restaurante).

/** 5. cocinaBien/2 es verdadero para una persona si su experiencia preparando ese plato es mayor a 7. Además, remy cocina bien cualquier plato que exista. */
cocinaBien(remy, Plato) :- cocina(_, Plato, _).
cocinaBien(C, Plato) :- cocina(C, Plato, Exp), Exp > 7.



/** 6. encargadoDe/3: nos dice el encargado de cocinar un plato en un restaurante, que es quien más experiencia tiene preparándolo en ese lugar. */

encargadeDe(Encargado, Plato, Restaurante) :- 
    trabaja(Encargado,Restaurante),
    cocina(Encargado, Plato, Experiencia),
    forall((trabaja(OtroCocinere,Restaurante),OtroCocinere \= Encargado,cocina(OtroCocinere, Plato, Experiencia2)), Experiencia >= Experiencia2).

/** Platos de comida: */
plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(pechugaALaPlancha, principal(ensalada, 10)).
plato(frutillasConCrema, postre(265)).
plato(ensalaDeFrutas, postre(70)).

/** 7. saludable/1: un plato es saludable si tiene menos de 75 calorías. */
saludable(Plato):- 
    plato(Plato, postre(Calorias)), 
    Calorias < 75.
saludable(Plato):- 
    plato(Plato, principal(Guarnicion,TiempoCoccion)), 
    calorias(Guarnicion, Calorias),
    CaloriasTotales is TiempoCoccion * 5 + Calorias,
    CaloriasTotales < 75.
saludable(Plato) :-
    plato(Plato, entrada(Ingredientes)), 
    length(Ingredientes, Cantidad),
    CaloriasTotales is Cantidad * 15,
    CaloriasTotales < 75.
calorias(papasFritas,60).
calorias(pure,20).
calorias(ensalada,0).

/** 8. criticaPositiva/2: es verdadero para un restaurante si un crítico le escribe una reseña positiva. */

criticaPositiva(Critico, Restaurante):-
    inspeccionSatisfactoria(Restaurante),
    buenaResenia(Critico, Restaurante).

especialistas(Plato, Restaurante) :- 
    trabaja(Alguien, Restaurante),
    cocina(Alguien, Plato, _),
    forall((trabaja(Cocinere, Restaurante), cocina(Cocinere, Plato, _)),cocinaBien(Cocinere, Plato)).
buenaResenia(antonEgo, Restaurante) :- 
    trabaja(_, Restaurante),
    especialistas(ratatouille, Restaurante).
buenaResenia(cormillot , Restaurante) :- 
    forall((trabaja(Cocinere, Restaurante), cocina(Cocinere, Plato, _)),saludable(Plato)).



