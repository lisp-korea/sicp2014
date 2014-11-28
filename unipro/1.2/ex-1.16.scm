;;; Exercise 1.16
(define (fast-expr b n)
 (define (expr-iter a br nr)
   (cond ((= nr 0) a)
	 ((even? nr) (expr-iter a (square br) (/ nr 2)))
	 (else (expr-iter (* a br) br (- nr 1)))))
 (expr-iter 1 b n))

(define (even? n)
  (= (remainder n 2) 0))

(define (square x)
  (* x x))
