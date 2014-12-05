(define (cons x y)
  (lambda (m) (m x y)))

(define (car z)
  (z (lambda (p q) p)))

전개 (car (cons x y))
-> ((cons x y) (lambda (p q) p))
-> ((lambda (m) (m x y)) (lambda (p q) p))
-> ((lambda (p q) p) x y)
-> ((lambda (x y) x))
-> x

cdr 정의
(define (cdr z)
  (z (lambda (p q) q)))

전개 (cdr (cons x y))
-> ((cons x y) (lambda (p q) q))
-> ((lambda (m) (m x y)) (lambda (p q) q))
-> ((lambda (p q) q) x y)
-> ((lambda (x y) y))
-> y

