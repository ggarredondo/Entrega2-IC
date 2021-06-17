;;;;;;;;;;;;;;;;;;Representación ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (ave ?x) representa “?x es un ave ”
; (animal ?x) representa “?x es un animal”
; (vuela ?x si|no seguro|por_defecto) representa “?x vuela si|no con esa certeza”
; (consultado ?x) representa "se ha preguntado sobre el animal ?x"

;;;Las aves y los mamíferos son animales
;;;Los gorriones, las palomas, las águilas y los pingüinos son aves
;;;La vaca, los perros y los caballos son mamíferos
;;;Los pingüinos no vuelan
(deffacts datos 
(ave gorrion) (ave paloma) (ave aguila) (ave pinguino) 
(mamifero vaca) (mamifero perro) (mamifero caballo) 
(vuela pinguino no seguro)
)


;;; Las aves son animales
(defrule aves_son_animales
(ave ?x)
=>
(assert (animal ?x))
(bind ?expl (str-cat "sabemos que un " ?x " es un animal por las aves son un tipo de animal"))
(assert (explicacion animal ?x ?expl))
)
;;; añadimos un hecho que contiene la explicación de la deducción


;;; Los mamiferos son animales
(defrule mamiferos_son_animales
(mamifero ?x)
=>
(assert (animal ?x))
(bind ?expl (str-cat "sabemos que un " ?x " es un animal por los mamiferos son un tipo de animal"))
(assert (explicacion animal ?x ?expl))
)
;;; añadimos un hecho que contiene la explicación de la deducción


;;; Casi todas las aves vuelan -> puedo asumir por defecto que las aves vuelan
;;; Asumimos por defecto
(defrule ave_vuela_por_defecto
(declare (salience -1)) ;;; para disminuir la probabilidad de añadir erróneamente
(ave ?x)
=>
(assert (vuela ?x si por_defecto))
(bind ?expl(str-cat "asumo que un " ?x " vuela, porque casi todas las aves vuelan"))
(assert (explicacion vuela ?x ?expl))
)


;;; Retractamos cuando hay algo en contra
(defrule retracta_vuelo_por_defecto
(declare (salience 1)) ;;; para retractar antes de inferir cosas erróneamente
?f <- (vuela ?x ?r por_defecto)
(vuela ?x ?s seguro)
=>
(retract ?f)
(bind ?expl (str-cat "retractamos que un " ?x ?r " vuela por defecto, porque sabemos seguro que " ?x ?s " vuela"))
(assert (explicacion retracta_vuela ?x ?expl))
)
;;; COMENTARIO: esta regla también elimina los por defecto cuando ya está seguro


;;; La mayor de los animales no vuelan -> puede interesarme asumir por defecto que un animal no va a volar
(defrule mayor_parte_animales_no_vuelan
(declare (salience -2)) ;;; es más arriesgado, mejor después de otros razonamientos
(animal ?x)
(not (vuela ?x ? ?))
=>
(assert (vuela ?x no por_defecto))
(bind ?expl (str-cat "asumo que " ?x " no vuela, porque la mayor parte de los animales no vuelan"))
(assert (explicacion vuela ?x ?expl))
)


;;;;;;;;;; COMPLETAR SISTEMA

;;; Preguntar sobre el animal del que se quiere saber si vuela o no
(defrule pregunta
=>
(printout t "Cual es del nombre del animal (mamifero o ave) sobre el que quiere saber si vuela o no?: " crlf)
(assert (consultado (read)))
)

;;; Preguntar en caso de que el animal no esté entre los recogidos en la base de conocimiento
(defrule pregunta2
(consultado ?x)
(not (animal ?x)) ;; si el animal consultado no existe como "animal" en la bc
=>
(printout t "Disculpeme pero desconozco ese animal. Es un ave o un mamifero?: " crlf)
(assert (aniadirTipo (read)) ;; hecho para saber qué tipo añadir
)

;;; añadir tipo del animal consultado si es ave
(defrule nuevoTipoAve
(consultado ?x)
(aniadirTipo ave)
=>
(ave ?x)
)

;;; añadir tipo del animal consultado si es mamifero
(defrule nuevoTipoMamifero
(consultado ?x)
(aniadirTipo mamifero)
=>
(mamifero ?x)
)












