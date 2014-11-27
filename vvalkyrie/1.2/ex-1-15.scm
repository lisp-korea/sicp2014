#lang planet neil/sicp

(define (cube x) (* x x x))

(define (p x) (- (* 3 x) (* 4 (cube x))))

(define (sine angle)
  (if (not (> (abs angle) 0.1))
    angle
    (p (sine (/ angle 3.0)))))

;; a. how many calls of p procedure in (sine 12.15)?

;; (sine 12.15)
;; (p (sine (/ 12.15 3.0))) --> (p (sine 4.05))
;; (p (sine (/  4.05 3.0))) --> (p (sine 1.35))
;; (p (sine (/  1.35 3.0))) --> (p (sine 0.45))
;; (p (sine (/  0.45 3.0))) --> (p (sine 0.15))
;; (p (sine (/  0.15 3.0))) --> (p (sine 0.05)) --> (p 0.05)

;; ==> 5 times

;; b. function of a in (sine a)

;; ==> memory & steps : theta(log a)

