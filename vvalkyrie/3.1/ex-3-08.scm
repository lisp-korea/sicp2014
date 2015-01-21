; ex 3.8

(define (g y)
  (lambda (x)
    (set! y (- 1 y))
    (if (= y 1) (- x 1) 1)))

(define f (g 0))

(+ (f 0) (f 1))
;;=> 0

(+ (f 1) (f 0))
;;=> 1

