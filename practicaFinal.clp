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
=>
(printout t "Bienvenido al sistema de asesoramiento de rama Elva." crlf)
(printout t "Se le haran una serie de preguntas relacionadas con sus preferencias para aconsejarle rama." crlf crlf)
(assert (cuestionario)) ;;; Hecho para dar comienzo al cuestionario sobre las preferencias.
)

(defrule pregunta2
(cuestionario)
=>
(printout t "Te gusta trastear y diseniar circuitos? (si|no|nsnc): " crlf)
(assert (Preferencia Hardware (read)))
)

(defrule aconsejarIC ;;;; Si le gusta el hardware, la rama aconsejada es Ingeniería de Computadores.
?c <- (cuestionario)
(Preferencia Hardware si)
=>
(retract ?c) ;;;; Eliminar hecho 'cuestionario' para que no continúe con las preguntas.
(assert (RamaAconsejada Ingenieria_de_Computadores))
)

(defrule pregunta3
(cuestionario)
(Preferencia Hardware ?)
=>
(printout t "Prefieres carga de trabajo de tipo entregas o examenes? (entregas|examenes|nsnc): " crlf)
(assert (Preferencia CargaTrabajo (read)))
)

(defrule pregunta4
(cuestionario)
(Preferencia CargaTrabajo entregas)
=>
(printout t "Te gusta las ciencias de datos (big data, machine learning...)? (si|no|nsnc): " crlf)
(assert (Preferencia CienciaDatos (read)))
)

(defrule pregunta5
(cuestionario)
(Preferencia CienciaDatos si)
=>
(printout t "Toleras una alta dificultad en las asignaturas? (si|no|nsnc): " crlf)
(assert (Preferencia ToleranciaDificultad (read)))
)

(defrule aconsejarCSI ;;;; Si prefiere entregas, le gusta la ciencia de los datos y tolera (o no le importa) la dificultad, la rama aconsejada es Computación y Sistemas Inteligentes.
?c <- (cuestionario)
(Preferencia ToleranciaDificultad si|nsnc)
=>
(retract ?c)
(assert (RamaAconsejada Computacion_y_Sistemas_Inteligentes))
)

(defrule pregunta6
(cuestionario)
(or (Preferencia CargaTrabajo examenes|nsnc) (Preferencia CienciaDatos no|nsnc))
=>
(printout t "Te gusta la programacion de graficos en 3D o 2D? (si|no|nsnc): " crlf)
(assert (Preferencia ProgramacionGrafica (read)))
)

(defrule pregunta7
(cuestionario)
(Preferencia ProgramacionGrafica si)
=>
(printout t "Te gusta el aspecto empresarial de la informatica (metodologias agiles, direccion de proyectos...)? (si|no|nsnc): " crlf)
(assert (Preferencia AspectoEmpresarial (read)))
)

(defrule aconsejarIS ;;; Si prefiere exámenes, le gusta la programación gráfica y la dirección de empresas, la rama aconsejada es Ingeniería del Software.
?c <- (cuestionario)
(Preferencia AspectoEmpresarial si)
=>
(retract ?c)
(assert (RamaAconsejada Ingenieria_del_Software))
)

(defrule pregunta8
(cuestionario)
(or (Preferencia ProgramacionGrafica no|nsnc) (Preferencia AspectoEmpresarial no|nsnc) (Preferencia ToleranciaDificultad no))
=>
(printout t "Te gusta la programacion web y la administracion de servidores? (si|no|nsnc): " crlf)
(assert (Preferencia ProgramacionWeb (read)))
)

(defrule pregunta9
(cuestionario)
(Preferencia ProgramacionWeb si)
=>
(printout t "Te gustan las bases de datos? (si|no|nsnc): " crlf)
(assert (Preferencia BaseDeDatos (read)))
)

(defrule aconsejarSI ;;; Si le gusta la programación web y servidores, y le gustan las bases de datos, la rama aconsejada es Sistemas de Información.
?c <- (cuestionario)
(Preferencia BaseDeDatos si)
=>
(retract ?c)
(assert (RamaAconsejada Sistemas_de_Informacion))
)

(defrule aconsejarTI ;;; Si le gusta la programación web y servidores, pero no las bases de datos, la rama aconsejada es Tecnologías de la Información.
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
(declare (salience -1)) ;;; Para que no salte antes del cuestionario.
(not (cuestionario)) ;;; Para que no salte durante el cuestionario.
=>
(printout t crlf "Sabiendo que..." crlf)
(assert (justificar)) ;;; Hecho para comenzar a justificar.
)

(defrule imprimirExplicaciones
(justificar)
(Preferencia ?p ?r)
(Explicacion ?p ?e)
(test (and (neq ?r nsnc) (neq ?p CargaTrabajo)))
=>
(printout t ?r ?e crlf)
)

(defrule imprimirExplicacionCargaTrabajo ;;; Es necesario una regla específica para esa preferencia porque el formato de respuesta es distinto.
(justificar)
(Preferencia CargaTrabajo ?r)
(test (neq ?r nsnc))
=>
(printout t "prefieres una carga de trabajo basada en " ?r crlf)
)

(defrule finalizarExplicacion
(declare (salience -1)) ;;; Para que no salte antes de las explicaciones.
(justificar)
(RamaAconsejada ?r)
=>
(printout t "He considerado que su mejor opcion de rama es " ?r crlf)
)

(defrule finalizarNoExplicacion ;;; Regla para el caso en el que no se consiga deducir cuál es la mejor rama para el usuario por falta de información.
(declare (salience -1)) ;;; Para que no salte antes de las preguntas y escoger la rama.
(cuestionario) ;;; Si el hecho 'cuestionario' sigue en pie, es porque no se ha escogido rama (el hecho 'cuestionario' se retracta al escoger rama).
=>
(printout t "La informacion es insuficiente. Por favor, intentelo de nuevo (demasiados no/nsnc)" crlf)
)




