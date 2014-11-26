#lang planet neil/sicp

(define (square x)
  (* x x))

(define (average x y)
  (/ (+ x y) 2))

(define (sqrt-iter old-guess guess x)
  (if (good-enough? old-guess guess x)
      guess
      (sqrt-iter guess (improve guess x) x)))

(define (good-enough? old-guess guess x)
  (and
   (< (abs (- (square guess) x)) 0.001)
   (< 0 (abs (- old-guess guess)) 0.000001)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (sqrt x)
  (sqrt-iter 0.0 1.0 x))

