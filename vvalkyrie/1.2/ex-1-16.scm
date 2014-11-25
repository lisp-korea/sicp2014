#lang planet neil/sicp

;; b^n = (b^(n/2))^2  n == even
;;     = b.b^(n-1)    n == odd

;;(define (fast-expt b n)
;;  (cond ((= n 0) 1)
;;        ((even? n) (square (fast-expt b (/ n 2))))
;;        (else (* b (fast-expt b (- n 1))))))

;; iterative version of fast-expt

;; b^4 (square (square b))
;; b^5 (square (square b)).b
;; b^6 (square (square b)).(square b)

(define (square x) (* x x))

(define (fast-expt b n)
  (fast-expt-iter 1 b n))

(define (fast-expt-iter product b n)
  (cond
    ((= n 0) product)
    ((even? n) (fast-expt-iter product (square b) (/ n 2)))
    (else (fast-expt-iter (* product b) b (- n 1)))))

;;--

(define (pwr2 n)
  (pwr2-iter 1 1 n))

(define (pwr2-iter val cnt n)
  (if (> cnt n)
    val
    (pwr2-iter (* val 2) (+ cnt 1) n)))

(runtime) ;; 1415795864485388
(fast-expt 2 65536) ;;  31,516us
(runtime) ;; 1415795864516904
(pwr2 65536)        ;; 157,633us
(runtime) ;; 1415795864674537

