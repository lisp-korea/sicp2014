#lang planet neil/sicp

;; make ex-1.17 to iterative version with log-scale
;; (Russian peasent method)

(define (double x) (+ x x))

(define (halve x) (/ x 2))

(define (mul a b)
  (if (= b 0) 0
    (mul-iter a 0 b)))

(define (mul-iter a p n)
  (cond
    ((= n 0) p)
    ((even? n)  (mul-iter (double a) p  (halve n)))
    (else (mul-iter a (+ p a)  (- n 1)))))
