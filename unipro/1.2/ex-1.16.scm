;;; Exercise 1.16
(define (fast-expr b n)
 (define (expr-recur a br nr)
   (cond ((= nr 0) 1)
	 ((= nr 1) (* a br))
	 ((even? nr) (expr-recur a (square br) (/ nr 2)))
	 (else (expr-recur (* a b) br (- nr 1)))))
 (expr-recur 1 b n))

(define (even? n)
  (= (remainder n 2) 0))

(define (square x)
  (* x x))
