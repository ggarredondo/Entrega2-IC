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
(FactorCerteza gira_motor ?f2)
(test (and (> ?f1 0) (> ?f2 0)))
=>
(assert (FactorCerteza problema_bujias si (encadenado (* ?f1 ?f2) 0.7)))
)