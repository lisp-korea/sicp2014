;;; Exercise 1.17

(define (fast-* x y)
  (define (*-iter a xr yr)
    (cond ((= yr 0) a)
	  ((even? yr) (*-iter a (double xr) (halve yr)))
	  (else (*-iter (+ a xr) xr (- yr 1)))))
  (*-iter 0 x y))

(define (even? n)
  (= (remainder n 2) 0))

(define (double n)
  (+ n n))

(define (halve n)
  (/ n 2))
