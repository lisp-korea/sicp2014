; ex 3.1

(define (make-accumulator x)
  (lambda (y)
    (begin
      (set! x (+ x y))
      x)))

(define A (make-accumulator 5))

(A 10)
;;=> 15

(A 10)
;;=> 25
