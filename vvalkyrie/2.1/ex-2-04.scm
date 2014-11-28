#lang planet neil/sicp

(define (cons x y)
  (lambda (m) (m x y)))

(define (car z)
  (z (lambda (p q) p)))

;; explain (car (cons x y)) = x

;; car의 z를 cons의 lambda 함수로 대치한다.
((lambda (m) (m x y))
 (lambda (p q) p))

;; lambda 함수의 m이 car의 lambda 함수로 대치된다.
((lambda (p q) p) x y)

;; p, q에 각각 x, y를 넣으면 결과로 x가 나온다.
x

;; define cdr.
(define (cdr z)
  (z (lambda (p q) q)))

