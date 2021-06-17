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


