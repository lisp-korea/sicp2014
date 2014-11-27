#lang planet neil/sicp

;; a.
;; - recursive version
;; - pi/4 = 2/3*4/3*4/5*6/5*6/7*8/7 ...

(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))

(define (product-pi a b)
  (define (term-pi n)
    (/ (* 2.0 (+ (quotient n 2) 1))
       (+ n 1 (remainder n 2))))
  (product term-pi a inc b))


;; b. iterative version
(define (product term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* result (term a)))))
  (iter a 1))
