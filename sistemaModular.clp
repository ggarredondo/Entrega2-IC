;;;;;;;; Representación modulos
; (modulo elva) -> Módulo de mi sistema (Guillermo García Arredondo).
; (modulo kerry) -> Módulo del sistema de Santiago Gonzalez Silot.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SISTEMA DE GUILLERMO GARCÍA ARREDONDO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;; Asesorar a un alumno en qué rama matricularse

;;;; REPRESENTACIÓN DE LAS RAMAS
(deffacts Ramas
    (Rama Computacion_y_Sistemas_Inteligentes)
    (Rama Ingenieria_del_Software)
    (Rama Ingenieria_de_Computadores)
    (Rama Sistemas_de_Informacion)
    (Rama Tecnologias_de_la_Informacion)
)

;;;; Representación de las preferencias
; (Preferencia Hardware si|no|nsnc)
; (Preferencia CargaTrabajo entregas|examenes|nsnc)
; (Preferencia ToleranciaDificultad si|no|nsnc)
; (Preferencia CienciaDatos si|no|nsnc)
; (Preferencia ProgramacionGrafica si|no|nsnc)
; (Preferencia AspectoEmpresarial si|no|nsnc)
; (Preferencia ProgramacionWeb si|no|nsnc)
; (Preferencia BaseDeDatos si|no|nsnc)

;;;; Reglas

;;;; Preguntas al usuario sobre sus preferencias
(defrule pregunta1
(modulo elva)
=>
(printout t "Bienvenido al sistema de asesoramiento de rama Elva." crlf)
(printout t "Se le haran una serie de preguntas relacionadas con sus preferencias para aconsejarle rama." crlf crlf)
(assert (cuestionario)) ;;; Hecho para dar comienzo al cuestionario sobre las preferencias.
)

(defrule pregunta2
(modulo elva)
(cuestionario)
=>
(printout t "Te gusta trastear y diseniar circuitos? (si|no|nsnc): " crlf)
(assert (Preferencia Hardware (read)))
)

(defrule aconsejarIC ;;;; Si le gusta el hardware, la rama aconsejada es Ingeniería de Computadores.
(modulo elva)
?c <- (cuestionario)
(Preferencia Hardware si)
=>
(retract ?c) ;;;; Eliminar hecho 'cuestionario' para que no continúe con las preguntas.
(assert (RamaAconsejada Ingenieria_de_Computadores))
)

(defrule pregunta3
(modulo elva)
(cuestionario)
(Preferencia Hardware ?)
=>
(printout t "Prefieres carga de trabajo de tipo entregas o examenes? (entregas|examenes|nsnc): " crlf)
(assert (Preferencia CargaTrabajo (read)))
)

(defrule pregunta4
(modulo elva)
(cuestionario)
(Preferencia CargaTrabajo entregas)
=>
(printout t "Te gusta las ciencias de datos (big data, machine learning...)? (si|no|nsnc): " crlf)
(assert (Preferencia CienciaDatos (read)))
)

(defrule pregunta5
(modulo elva)
(cuestionario)
(Preferencia CienciaDatos si)
=>
(printout t "Toleras una alta dificultad en las asignaturas? (si|no|nsnc): " crlf)
(assert (Preferencia ToleranciaDificultad (read)))
)

(defrule aconsejarCSI ;;;; Si prefiere entregas, le gusta la ciencia de los datos y tolera (o no le importa) la dificultad, la rama aconsejada es Computación y Sistemas Inteligentes.
(modulo elva)
?c <- (cuestionario)
(Preferencia ToleranciaDificultad si|nsnc)
=>
(retract ?c)
(assert (RamaAconsejada Computacion_y_Sistemas_Inteligentes))
)

(defrule pregunta6
(modulo elva)
(cuestionario)
(or (Preferencia CargaTrabajo examenes|nsnc) (Preferencia CienciaDatos no|nsnc))
=>
(printout t "Te gusta la programacion de graficos en 3D o 2D? (si|no|nsnc): " crlf)
(assert (Preferencia ProgramacionGrafica (read)))
)

(defrule pregunta7
(modulo elva)
(cuestionario)
(Preferencia ProgramacionGrafica si)
=>
(printout t "Te gusta el aspecto empresarial de la informatica (metodologias agiles, direccion de proyectos...)? (si|no|nsnc): " crlf)
(assert (Preferencia AspectoEmpresarial (read)))
)

(defrule aconsejarIS ;;; Si prefiere exámenes, le gusta la programación gráfica y la dirección de empresas, la rama aconsejada es Ingeniería del Software.
(modulo elva)
?c <- (cuestionario)
(Preferencia AspectoEmpresarial si)
=>
(retract ?c)
(assert (RamaAconsejada Ingenieria_del_Software))
)

(defrule pregunta8
(modulo elva)
(cuestionario)
(or (Preferencia ProgramacionGrafica no|nsnc) (Preferencia AspectoEmpresarial no|nsnc) (Preferencia ToleranciaDificultad no))
=>
(printout t "Te gusta la programacion web y la administracion de servidores? (si|no|nsnc): " crlf)
(assert (Preferencia ProgramacionWeb (read)))
)

(defrule pregunta9
(modulo elva)
(cuestionario)
(Preferencia ProgramacionWeb si)
=>
(printout t "Te gustan las bases de datos? (si|no|nsnc): " crlf)
(assert (Preferencia BaseDeDatos (read)))
)

(defrule aconsejarSI ;;; Si le gusta la programación web y servidores, y le gustan las bases de datos, la rama aconsejada es Sistemas de Información.
(modulo elva)
?c <- (cuestionario)
(Preferencia BaseDeDatos si)
=>
(retract ?c)
(assert (RamaAconsejada Sistemas_de_Informacion))
)

(defrule aconsejarTI ;;; Si le gusta la programación web y servidores, pero no las bases de datos, la rama aconsejada es Tecnologías de la Información.
(modulo elva)
?c <- (cuestionario)
(Preferencia BaseDeDatos no)
=>
(retract ?c)
(assert (RamaAconsejada Tecnologias_de_la_Informacion))
)

;;;; Explicaciones para cada preferencia
(deffacts Explicaciones
(Explicacion Hardware " te interesa el hardware")
(Explicacion CienciaDatos " te interesan las ciencias de datos")
(Explicacion ToleranciaDificultad " toleras una alta dificultad en las asignaturas")
(Explicacion ProgramacionGrafica " te interesa la programacion de graficos")
(Explicacion AspectoEmpresarial " te interesa el aspecto empresarial de la informatica")
(Explicacion ProgramacionWeb " te interesan la programacion web y administracion de servidores")
(Explicacion BaseDeDatos " te interesan las bases de datos")
)

(defrule comenzarExplicaciones
(modulo elva)
(declare (salience -1)) ;;; Para que no salte antes del cuestionario.
(not (cuestionario)) ;;; Para que no salte durante el cuestionario.
=>
(printout t crlf "Sabiendo que..." crlf)
(assert (justificar)) ;;; Hecho para comenzar a justificar.
)

(defrule imprimirExplicaciones
(modulo elva)
(justificar)
(Preferencia ?p ?r)
(Explicacion ?p ?e)
(test (and (neq ?r nsnc) (neq ?p CargaTrabajo)))
=>
(printout t ?r ?e crlf)
)

(defrule imprimirExplicacionCargaTrabajo ;;; Es necesario una regla específica para esa preferencia porque el formato de respuesta es distinto.
(modulo elva)
(justificar)
(Preferencia CargaTrabajo ?r)
(test (neq ?r nsnc))
=>
(printout t "prefieres una carga de trabajo basada en " ?r crlf)
)

(defrule finalizarExplicacion
(modulo elva)
(declare (salience -1)) ;;; Para que no salte antes de las explicaciones.
(justificar)
(RamaAconsejada ?r)
=>
(printout t "He considerado que su mejor opcion de rama es " ?r crlf)
)

(defrule finalizarNoExplicacion ;;; Regla para el caso en el que no se consiga deducir cuál es la mejor rama para el usuario por falta de información.
(modulo elva)
(declare (salience -1)) ;;; Para que no salte antes de las preguntas y escoger la rama.
(cuestionario) ;;; Si el hecho 'cuestionario' sigue en pie, es porque no se ha escogido rama (el hecho 'cuestionario' se retracta al escoger rama).
=>
(printout t "La informacion es insuficiente. Por favor, intentelo de nuevo (demasiados no/nsnc)" crlf)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SISTEMA DE SANTIAGO GONZALEZ SILOT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; Santiago Gonzalez Silot
;;;; P1.3 CLIPS

;;;; Caracteristicas que tengo en cuenta:
;;;; (GustaHardware (SI|NO|NSNC))
;;;; (GustaIA (SI|NO|NSNC))
;;;; (GustaIngenieria (SI|NO|NSNC))
;;;; (GustaBD (SI|NO|NSNC))
;;;; (GustaProgWeb (SI|NO|NSNC))
;;;; (GustaEmpresa (SI|NO|NSNC))

;;;; Representacion de hechos
;;;; Todas las preguntas estan enumeradas por lo que ?f1 representara al hecho 1 (pregunta hardware en este caso)
;;;; asi logro que sea mas legible y facil de entender
;;;; De igual forma las respuestas a estas preguntas seran: ?r1, ?r2,...,?rn



;;;; Ire haciendo distintas preguntas y las respuestas las representare de la siguiente forma:
;;;; Para las preguntas de SI o NO:
;;;; (NombrePregunta SI|NO|NSNC)

;;;; --------------REGLAS--------

;;;; Inicio del programa
(defrule Inicio
(modulo kerry)
=>
    (assert (Presentate))
)

;;;; Una breve presentacion y empiezo con las preguntas
(defrule Presentacion
(modulo kerry)
    ?f <- (Presentate)
=>
    (retract ?f)
    (printout t "Bienvenido al sistema de recomendacion de mencion, me llamo Kerry y estoy aqui para ayudarte" crlf)
    (printout t "Para ello necesito que me vayas diciendo varias cosas sobre ti..." crlf)
    (assert (ComienzoPreguntas))
)

;;;; Pregunta 1: Pregunta Hardware
;;;; Lo primero que hago es preguntar si le gusta el hardware
;;;; Ya que en mi arbol de decision es lo que mas me descarta, ya que
;;;; automaticamente decido que su rama es la de IC
(defrule PreguntaHardware
(modulo kerry)
    ?f <- (ComienzoPreguntas)
=>
    (retract ?f) ; Se termina el comienzo de las preguntas
    (printout t "Te gusta el hardware? (SI|NO|NSNC)" crlf)
    (assert (GustaHardware (read)))
)

;;;; Si a la Pregunta 1 responde que si...
;;;; Conclusion 1: IC
;;;; Para cuando le gusta el hardware
(defrule ConclusionIC1
(modulo kerry)
    ?f1 <- (GustaHardware ?r1); Compruebo que le gusta el hardware
    (test (eq ?r1 SI)) 
=>
    (printout t "Te recomiendo que escojas la especialidad de IC, ya que..." crlf)
    (printout t ?r1 " te gusta el Hardware" crlf) ; Digo que le gusta el hardware
    (halt)
)

;;;; Si a la pregunta 1 responde que no...
;;;; Pregunta 2: Pregunta Mates
;;;; Ahora le pregunto si le gustan las mates
(defrule PreguntaMates
(modulo kerry)
    ;?f <- (GustaHardware (or (test (eq ?respuesta NO)) (test (eq ?respuesta NSNC)))) ;Me sirve si ha dicho que si o ha dicho que no sabe
    ?f1 <- (GustaHardware ?r1)
=>
    (printout t "Te gustan las mates? (SI|NO|NSNC)" crlf)
    (assert (GustaMates (read)))
)

;;;; Si a la pregunta 2 responde que si
;;;; Pregunta 3: Pregunta IA/ML/Data Science
(defrule PreguntaIA
(modulo kerry)
    ?f2 <- (GustaMates ?r2)

    (test (eq ?r2 SI))
=>
    (printout t "Te gustan la IA/ML/Data Science? (SI|NO|NSNC)" crlf)
    (assert (GustaIA (read)))
)

;;;; Si a la pregunta 3 responde que si...
;;;; Conclusion 2: CSI
;;;; Para cuando no le gusta el hardware
;;;; Para cuando le gustan las mates
;;;; Para cuando le gusta la IA/ML/Data Science
(defrule ConclusionCSI1
(modulo kerry)
    ?f1 <- (GustaHardware ?r1)
    ?f2 <- (GustaMates ?r2)
    ?f3 <- (GustaIA ?r3)
    (test (neq ?r1 SI)) ; O no le gusta hardware o le da igual
    (test (eq ?r2 SI)) ;LE gustan las mates
    (test (eq ?r3 SI)) ;Le gusta la IA
=>
    (printout t "Te recomiendo que escojas la especialidad de CSI, ya que..." crlf)
    (printout t ?r1 " te gusta el hardware" crlf)
    (printout t ?r2 " te gustan las matematicas" crlf) ; Digo que le gustan las mates
    (printout t ?r3 " te gusta la IA/ML/Data Science" crlf) ; Digo que le gusta la IA/ML/Data Science
)

;;;; Si a la pregunta 3 responde que no
;;;; Me voy a la pregunta 4: PreguntaIngenieria
;;;; Revisar: Como lo hago?


;;;; Si a la pregunta 2 (o a la 3) responde que no
;;;; Pregunta 4: Pregunta Ingenieria
;;;; Ahora le pregunto si le gusta el ambito mas ingenieril (SCRUM, Metodologias Agiles, etc)
(defrule PreguntaIngenieria
(modulo kerry)
    ?f2 <- (GustaMates ?r2) ; Puedo llegar por haber dicho que no en la 2
    (test (neq ?r2 SI))
    
=>
    
    (printout t "Te gusta el ambito mas ingenieril (SCRUM, Metodologias Agiles, etc)? (SI|NO|NSNC)" crlf)
    (assert (GustaIngenieria (read)))
)

;;;; Si a la pregunta 2 (o a la 3) responde que no
;;;; Pregunta 4: Pregunta Ingenieria
;;;; Ahora le pregunto si le gusta el ambito mas ingenieril (SCRUM, Metodologias Agiles, etc)
(defrule PreguntaIngenieria2 ; Por si va por el camino de IA
(modulo kerry)
    ?f2 <- (GustaMates ?r2) ; Puedo llegar por haber dicho que no en la 2
    ?f3 <- (GustaIA ?r3) ; O no haber dicho que si en la 3
    (test (neq ?r3 SI))
    
=>
    
    (printout t "Te gusta el ambito mas ingenieril (SCRUM, Metodologias Agiles, etc)? (SI|NO|NSNC)" crlf)
    (assert (GustaIngenieria (read)))
)


;;;; Si a la pregunta 4 responde que no
;;;; Pregunta 5: Pregunta BD
;;;; Ahora le pregunto si le gustan las Bases de Datos
(defrule PreguntaBD
(modulo kerry)
    ?f4 <- (GustaIngenieria ?r4) ;Para haber llegado aqui solo puede ser si he dicho que no a la 4
    
    (test (neq ?r4 SI)); Si he dicho que no a la 4
=>
    (printout t "Te gusta las administracion de Bases de Datos SQL y NoSQL? (SI|NO|NSNC)" crlf)
    (assert (GustaBD (read)))
)

;;;; Si a la pregunta 5 responde que si...
;;;; Conclusion 3: SI
;;;; Para cuando no le gusta el hardware
;;;; Para cuando le gustan las mates
;;;; Para cuando no le gusta el ambito ingenieril
;;;; Para cuando le gustan las BD
(defrule ConclusionSI1
(modulo kerry)
    ;Cargo los hechos
    ?f1 <- (GustaHardware ?r1)
    ?f2 <- (GustaMates ?r2)
    ?f4 <- (GustaIngenieria ?r4)
    ?f5 <- (GustaBD ?r5)

    ;Hagos las comprobaciones
    (test (eq ?r5 SI))
    
=>
    (printout t "Te recomiendo que escojas la especialidad de SI, ya que..." crlf)
    (printout t ?r1 " te gusta el hardware" crlf)
    (printout t ?r2 " te gustan las matematicas" crlf)
    (printout t ?r4 " te gustan el ambito ingenieril" crlf)
    (printout t ?r5 " te gustan las BD" crlf)
    ;(halt)
)

;;;; Si a la pregunta 5 responde que no...
;;;; Conclusion 4: TI
;;;; Para cuando no le gusta el hardware
;;;; Para cuando le gustan las mates
;;;; Para cuando no le gusta el ambito ingenieril
;;;; Para cuando no le gustan las BD
(defrule ConclusionTI1
(modulo kerry)
    ;Cargo los hechos
    ?f1 <- (GustaHardware ?r1)
    ?f2 <- (GustaMates ?r2)
    ?f4 <- (GustaIngenieria ?r4)
    ?f5 <- (GustaBD ?r5)

    ;Hagos las comprobaciones
    (test (eq ?r5 NO))
    
=>
    (printout t "Te recomiendo que escojas la especialidad de TI, ya que..." crlf)
    (printout t ?r1 " te gusta el hardware" crlf)
    (printout t ?r2 " te gustan las matematicas" crlf)
    (printout t ?r4 " te gustan el ambito ingenieril" crlf)
    (printout t ?r5 " te gustan las BD" crlf)
    ;(halt)
)

;;;; Si a la pregunta 4 responde que si o a la 5 responde que NSNC
;;;; Pregunta 6: Pregunta ProgWeb
;;;; Ahora le pregunto si le gustan las Bases de Datos
(defrule PreguntaProgWeb
(modulo kerry)
    ?f4 <- (GustaIngenieria ?r4)

    (test (eq ?r4 SI)); Comprueba que r4 es SI o 5 es NSNC
=>
    (printout t "Te gusta la programacion WEB (SI|NO|NSNC)?" crlf)
    (assert (GustaProgWeb (read)))
)

;;;; Si a la pregunta 4 responde que si o a la 5 responde que NSNC
;;;; Pregunta 6: Pregunta ProgWeb
;;;; Ahora le pregunto si le gustan las Bases de Datos
(defrule PreguntaProgWeb2
(modulo kerry)
    ?f4 <- (GustaIngenieria ?r4)
    ?f5 <- (GustaBD ?r5)

    (test (or (eq ?r4 SI) (eq ?r5 NSNC))); Comprueba que r4 es SI o 5 es NSNC
=>
    (printout t "Te gusta la programacion WEB (SI|NO|NSNC)?" crlf)
    (assert (GustaProgWeb (read)))
)

;;;; Si a la pregunta 6 responde que si...
;;;; Conclusion 5: IS
;;;; Para cuando no le gusta el hardware
;;;; Para cuando le gustan las mates
;;;; Para cuando no le gusta el ambito ingenieril
;;;; Para cuando le gustan las BD
(defrule ConclusionIS1
(modulo kerry)
;Cargo los hechos
    ?f1 <- (GustaHardware ?r1)
    ?f2 <- (GustaMates ?r2)
    ?f4 <- (GustaIngenieria ?r4)
    ?f6 <- (GustaProgWeb ?r6)

    (test (eq ?r6 SI))
=>
    (printout t "Te recomiendo que escojas la especialidad de IS, ya que..." crlf)
    (printout t ?r1 " te gusta el hardware" crlf)
    (printout t ?r2 " te gustan las matematicas" crlf)
    (printout t ?r4 " te gustan el ambito ingenieril" crlf)
    (printout t ?r6 " te gusta la programacion Web" crlf)
    (halt)
)

;;;; Si a la pregunta 6 responde que no
;;;; Pregunta 7: Pregunta Empresa
;;;; Ahora le pregunto si le gusta el ambito empresarial
(defrule PreguntaEmpresa
(modulo kerry)
    ?f6 <- (GustaProgWeb ?r6)

    (test (neq ?r6 SI))
=>
    (printout t "Te gusta el mundo empresarial (SI|NO|NSNC)?" crlf)
    (assert (GustaEmpresa (read)))
)

;;;; Si a la pregunta 7 responde que si...
;;;; Conclusion 6: IS
;;;; Para cuando no le gusta el hardware
;;;; Para cuando le gustan las mates
;;;; Para cuando le gusta el ambito ingenieril
;;;; Para cuando no le gusta la programacion web
;;;; Para cuando le gusta el mundo empresarial
(defrule ConclusionTI2
(modulo kerry)
    ?f1 <- (GustaHardware ?r1)
    ?f2 <- (GustaMates ?r2)
    ?f4 <- (GustaIngenieria ?r4)
    ?f6 <- (GustaProgWeb ?r6)
    ?f7 <- (GustaEmpresa ?r7)
    (test (eq ?r7 SI))
=>
    (printout t "Te recomiendo que escojas la especialidad de TI, ya que..." crlf)
    (printout t ?r1 " te gusta el hardware" crlf)
    (printout t ?r2 " te gustan las matematicas" crlf)
    (printout t ?r4 " te gustan el ambito ingenieril" crlf)
    (printout t ?r6 " te gusta la programacion Web" crlf)
    (printout t ?r7 " te gusta el mundo empresarial" crlf)
    (halt)
)

;;;; Si a la pregunta 7 responde que no...
;;;; Conclusion 7: SI
;;;; Para cuando no le gusta el hardware
;;;; Para cuando le gustan las mates
;;;; Para cuando le gusta el ambito ingenieril
;;;; Para cuando no le gusta la programacion web
;;;; Para cuando no le gusta el mundo empresarial
(defrule ConclusionSI2
(modulo kerry)
    ?f1 <- (GustaHardware ?r1)
    ?f2 <- (GustaMates ?r2)
    ?f4 <- (GustaIngenieria ?r4)
    ?f6 <- (GustaProgWeb ?r6)
    ?f7 <- (GustaEmpresa ?r7)
    (test (eq ?r7 NO))
=>
    (printout t "Te recomiendo que escojas la especialidad de SI, ya que..." crlf)
    (printout t ?r1 " te gusta el hardware" crlf)
    (printout t ?r2 " te gustan las matematicas" crlf)
    (printout t ?r4 " te gustan el ambito ingenieril" crlf)
    (printout t ?r6 " te gusta la programacion Web" crlf)
    (printout t ?r7 " te gusta el mundo empresarial" crlf)
    (halt)
)

;;;; Si a la pregunta 7 responde que NSNC...
;;;; Conclusion 6: IS
;;;; Para cuando no le gusta el hardware
;;;; Para cuando le gustan las mates
;;;; Para cuando le gusta el ambito ingenieril
;;;; Para cuando no le gusta la programacion web
;;;; Para cuando le gusta el mundo empresarial
(defrule ConclusionTI3
(modulo kerry)
    ?f1 <- (GustaHardware ?r1)
    ?f2 <- (GustaMates ?r2)
    ?f4 <- (GustaIngenieria ?r4)
    ?f6 <- (GustaProgWeb ?r6)
    ?f7 <- (GustaEmpresa ?r7)
    (test (eq ?r7 NSNC))
=>
    (printout t "Te recomiendo que escojas la especialidad de TI, ya que..." crlf)
    (printout t ?r1 " te gusta el hardware" crlf)
    (printout t ?r2 " te gustan las matematicas" crlf)
    (printout t ?r4 " te gustan el ambito ingenieril" crlf)
    (printout t ?r6 " te gusta la programacion Web" crlf)
    (printout t ?r7 " te gusta el mundo empresarial" crlf)
    ;(halt) ; No paro porque voy justo a la siguiente
)

;;;; Si a la pregunta 7 responde que no...
;;;; Conclusion 7: SI
;;;; Para cuando no le gusta el hardware
;;;; Para cuando le gustan las mates
;;;; Para cuando le gusta el ambito ingenieril
;;;; Para cuando no le gusta la programacion web
;;;; Para cuando no le gusta el mundo empresarial
(defrule ConclusionSI3
(modulo kerry)
    ?f1 <- (GustaHardware ?r1)
    ?f2 <- (GustaMates ?r2)
    ?f4 <- (GustaIngenieria ?r4)
    ?f6 <- (GustaProgWeb ?r6)
    ?f7 <- (GustaEmpresa ?r7)
    (test (eq ?r7 NSNC))
=>
    (printout t "Ademas tambien..." crlf)
    (printout t "Te recomiendo que escojas la especialidad de SI, ya que..." crlf)
    (printout t ?r1 " te gusta el hardware" crlf)
    (printout t ?r2 " te gustan las matematicas" crlf)
    (printout t ?r4 " te gustan el ambito ingenieril" crlf)
    (printout t ?r6 " te gusta la programacion Web" crlf)
    (printout t ?r7 " te gusta el mundo empresarial" crlf)
    (halt)
)

;;;;;;; Pregunta inicial para que el usuario escoja el sistema de asesoramiento a su gusto
(defrule preguntaInicial
=>
(printout t "Bienvenido al sistema experto conjunto de asesoramiento de rama." crlf "Cual sistema desearia que le aconsejase?: (elva|kerry)" crlf)
(assert (modulo (read)))
(printout t crlf)
)





