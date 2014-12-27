;; ex 1.43
;; define repeat. (hint: use compose)

(define (inc x) (+ x 1))

(define (square x) (* x x))

(define (compose f g)
  (lambda (x)
    (f (g x))))

(define (repeat f n)
  (if (= n 1)
      f
      (compose f (repeat f (- n 1)))))

((repeat square 2) 5)
;;=> 625

((repeat square 1) 5)
;;=> 25

((repeat inc 5) 2)
;;=> 7
