;;; Exercise 1.17

(define (fast-* x y)
  (define (*-recur a xr yr)
    (cond ((= yr 0) 0)
	  ((= yr 1) (+ a xr))
	  ((even? yr) (*-recur a (double xr) (halve yr)))
	  (else (*-recur (+ a xr) xr (- yr 1)))))
  (*-recur 0 x y))

(define (even? n)
  (= (remainder n 2) 0))

(define (double n)
  (+ n n))

(define (halve n)
  (/ n 2))
