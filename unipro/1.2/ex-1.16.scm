;;; Exercise 1.16
(define (fast-expr b n)
 (define (expt-recur a br nr)
   (cond ((= nr 0) 1)
	 ((even? nr) (expt-recur a (square br) (/ nr 2)))
	 (else (expt-recur (* a br) br (- nr 1)))))
 (expt-recur 1 b n))

(define (even? n)
  (= (remainder n 2) 0))

(define (square x)
  (* x x))
