#lang planet neil/sicp

(define (fib n)
  (fib-iter 1 0 0 1 n))

(define (fib-iter a b p q count)
  (cond
    ((= count 0) b)
    ((even? count)
      (fib-iter a
                b
                (update-p p q)  ; calc p'
                (update-q p q)  ; calc q'
                (/ count 2)))
    (else
      (fib-iter (+ (* b q) (* a q) (* a p))
                (+ (* b p) (* a q))
                p
                q
                (- count 1)))))

(define (update-p p q)
  (+ (* p p) (* q q)))

(define (update-q p q)
  (+ (* 2 p q) (* q q)))

