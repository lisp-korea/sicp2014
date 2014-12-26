;; ex 1.42
;; define compose.

(define (inc x) (+ x 1))

(define (square x) (* x x))

(define (compose f g)
  (lambda (x)
    (f (g x))))

((compose square inc) 6)
