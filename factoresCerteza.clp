;;;;;;;;;;;;;;;;;;Representación ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (FactorCerteza ?h si|no ?f) representa que ?h se ha deducido con un factor de certeza ?f
; ?h podrá ser:
; 			- problema_starter
;			- problema_bujias
;			- problema_bateria
;			- problema_bateria
;			- motor_llega_gasolina

; (Evidencia ?e si|no) representa el hecho de si evidencia ?e se da
; ?e podrá ser:
;			- hace_intentos_arrancar
;			- hay_gasolina_en_deposito
;			- encienden_las_luces
;			- gira_motor


;;; convertimos cada evidencia en una afirmación sobre su factor de certeza
(defrule certeza_evidencias
(Evidencia ?e ?r)
=>
(assert (FactorCerteza ?e ?r 1))
)

;;; Función encadenado
(deffunction encadenado(?fc_antecedente ?fc_regla)
(if (> ?fc_antecedente 0)
	then
		(bind ?rv (* ?fc_antecedente ?fc_regla))
	else
		(bind ?rv 0)
)
?rv
)

;;; Función combinación
(deffunction combinacion (?fc1 ?fc2)
(if (and (> ?fc1 0) (> ?fc2 0))
	then
		(bind ?rv (- (+ ?fc1 ?fc2) (* ?fc1 ?fc2)))
	else
		(if (and (< ?fc1 0) (< ?fc2 0))
			then
				(bind ?rv (+ (+ ?fc1 ?fc2) (* ?fc1 ?fc2)))
			else
				(bind ?rv (/ (+ ?fc1 ?fc2) (- 1 (min (abs ?fc1) (abs ?fc2)))))
		)
)
?rv
)

;;; Función combinación de signos
(defrule combinar_signo
(declare (salience 2))
(FactorCerteza ?h si ?fc1)
(FactorCerteza ?h no ?fc2)
=>
(assert (FactorCerteza ?h si (- ?fc1 ?fc2)))
)

;;; Combinar misma deducción por distintos caminos
(defrule combinar
(declare (salience 1))
?f <- (FactorCerteza ?h ?r ?fc1)
?g <- (FactorCerteza ?h ?r ?fc2)
(test (neq ?fc1 ?fc2))
=>
(retract ?f ?g)
(assert (FactorCerteza ?h ?r (combinacion ?fc1 ?fc2)))
)


;;;;;;;;;;;; REGLAS
;;; R1: SI el motor obtiene gasolina Y el motor gira ENTONCES problemas con las bujías con certeza 0,7
(defrule R1
(FactorCerteza motor_llega_gasolina si ?f1)
(FactorCerteza gira_motor si ?f2)
(test (and (> ?f1 0) (> ?f2 0)))
=>
(assert (FactorCerteza problema_bujias si (encadenado (* ?f1 ?f2) 0.7)))
)

;;; R2: SI NO gira el motor ENTONCES problema con el starter con certeza 0,8
(defrule R2
(FactorCerteza gira_motor no ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza problema_starter si (encadenado ?f1 0.8)))
)

;;; R3: SI NO encienden las luces ENTONCES problemas con la batería con certeza 0,9
(defrule R3
(FactorCerteza encienden_las_luces no ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza problema_bateria si (encadenado ?f1 0.9)))
)

;;; R4: SI hay gasolina en el deposito ENTONCES el motor obtiene gasolina con certeza 0,9
(defrule R4
(FactorCerteza hay_gasolina_en_deposito si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza motor_llega_gasolina si (encadenado ?f1 0.9)))
)

;;; R5: SI hace intentos de arrancar ENTONCES problema con el starter con certeza -0,6
;;; R6: SI hace intentos de arrancar ENTONCES problema con la batería 0,5
(defrule R5R6
(FactorCerteza hace_intentos_arrancar si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza problema_starter si (encadenado ?f1 -0.6)))
(assert (FactorCerteza problema_bateria si (encadenado ?f1 0.5)))
)


;;;;;;;;; ACABAR EL EJEMPLO

;;; Preguntas sobre cada evidencia

(defrule pregunta1
=>
(printout t "El coche hace intentos de arrancar (si|no)?: " crlf)
(assert (Evidencia hace_intentos_arrancar (read)))
)

(defrule pregunta2
(Evidencia hace_intentos_arrancar ?) ;;; Hecho para comprobar que se ha realizado la pregunta anterior sobre los intentos de arrancar
=>
(printout t "Hay gasolina en el deposito (si|no)?: " crlf)
(assert (Evidencia hay_gasolina_en_deposito (read)))
)

(defrule pregunta3
(Evidencia hay_gasolina_en_deposito ?)
=>
(printout t "Encienden las luces (si|no)?: " crlf)
(assert (Evidencia encienden_las_luces (read)))
)

(defrule pregunta4
(Evidencia encienden_las_luces ?)
=>
(printout t "Gira el motor (si|no)?: " crlf)
(assert (Evidencia gira_motor (read)))
)

;;; Resultados para cada problema posible
(defrule problema
(declare (salience -1)) ;;; Para asegurarnos de que el sistema ha tenido tiempo de inferir y hacer las respectivas combinaciones antes de dar una respuesta
(FactorCerteza ?p ?r ?f)
(test (neq ?p hace_intentos_arrancar)) ;;; Para asegurarnos que no muestre las evidencias como problemas
(test (neq ?p hay_gasolina_en_deposito))
(test (neq ?p encienden_las_luces))
(test (neq ?p gira_motor))
=>
(printout t "Considero que " ?r " se da el problema " ?p " con un " ?f " de certeza" crlf)
)

;;; Escoger hipótesis final
(deffacts hipotesisInicial (Hipotesis ninguna no 0)) ;;; Hipótesis inicial con certeza 0

;;; Regla para comparar la certeza de la hipótesis actual con la certeza de otro problema cualquiera
(defrule hipotesisFinal
(declare (salience -2)) ;;; Para asegurarnos de que el sistema ha tenido tiempo de inferir y hacer las respectivas combinaciones antes de dar una respuesta
?h <- (Hipotesis ?p1 ?r1 ?f1)
(FactorCerteza ?p2 ?r2 ?f2)
(test (> ?f2 ?f1)) ;;; Si el problema 2 si tiene mayor certeza que el de la hipótesis actual...
(test (neq ?p2 hace_intentos_arrancar)) ;;; Para asegurarnos que no tome en cuenta certezas de evidencias
(test (neq ?p2 hay_gasolina_en_deposito))
(test (neq ?p2 encienden_las_luces))
(test (neq ?p2 gira_motor))
=>
(retract ?h) ;;; Se retracta la hipótesis escogida
(assert (Hipotesis ?p2 ?r2 ?f2)) ;;; Se levanta la nueva hipótesis con el segundo problema
)

;;; Decir al usuario la hipótesis con mayor certeza
(defrule explicarHipotesis
(declare (salience -3)) ;;; Menor prioridad para asegurarnos que se ha terminado de inferir la hipótesis
(Hipotesis ?p ?r ?f)
(not (Hipotesis ninguna no 0)) ;;; Asegurarnos que esa hipótesis no es la inicial
=>
(printout t "Por tanto, mi hipotesis final es que " ?r " se da el problema " ?p " con un " ?f " de certeza" crlf)
)

;;; Decir al usuario que no se ha encontrado hipótesis
(defrule noHayHipotesis
(declare (salience -3))
(Hipotesis ninguna no 0) ;;; Algo que sabemos si la hipótesis siga siendo la inicial después del proceso de inferir hipótesis (prioridad -3)
=>
(printout t "No se ha encontrado problema" crlf)
)









