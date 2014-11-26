#lang planet neil/sicp

(define (square x)
  (* x x))

(define (gt x y) ;; greater-than
  (if (> x y) x y))

(define (lt x y) ;; less-than
  (if (< x y) x y))

(define (sum-2-squares a b c)
  (+
   (square (gt a b))
   (square (gt (lt a b) c))))
