;;; Exercise 1.16

(define (fast-expt b n)
 (define (expt-iter a br nr)
   (cond ((= nr 0) a)
	 ((even? nr) (expt-iter a (square br) (/ nr 2)))
	 (else (expt-iter (* a br) br (- nr 1)))))
 (expt-iter 1 b n))

(define (even? n)
  (= (remainder n 2) 0))

(define (square x)
  (* x x))

;;; Examples

;; (define (expt b n)
;;   (if (= n 0)
;;       1
;;       (* b (expt b (- n 1)))))

(define (expt b n)
  (define (expt-iter counter product)
    (if (= counter n)
	product
	(expt-iter (+ counter 1) (* b product))))
  (expt-iter 0 1))
