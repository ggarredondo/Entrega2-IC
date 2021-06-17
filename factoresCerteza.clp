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
(defrule problema1
(declare (salience -10)) ;;; Para asegurarnos de que el sistema ha tenido tiempo de inferir y hacer las respectivas combinaciones antes de dar una respuesta
(FactorCerteza problema_starter ?r ?f)
=>
(printout t "Considero que " ?r " hay un problema con el starter con un " ?f " de certeza" crlf)
)

(defrule problema2
(declare (salience -10))
(FactorCerteza problema_bujias ?r ?f)
=>
(printout t "Considero que " ?r " hay un problema con las bujias con un " ?f " de certeza" crlf)
)

(defrule problema3
(declare (salience -10))
(FactorCerteza problema_bateria ?r ?f)
=>
(printout t "Considero que " ?r " hay un problema con la bateria con un " ?f " de certeza" crlf)
)

(defrule problema4
(declare (salience -10))
(FactorCerteza motor_llega_gasolina ?r ?f)
=>
(printout t "Considero que " ?r " llega gasolina al motor con un " ?f " de certeza" crlf)
)








