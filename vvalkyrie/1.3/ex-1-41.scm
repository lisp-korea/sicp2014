;; ex 1.41
;; define double.

(define (inc x) (+ x 1))

(define (double p)
  (lambda (x)
    (p (p x))))

((double inc) 1)
;;=> 3

(((double (double double)) inc) 5)
;;=> 21
