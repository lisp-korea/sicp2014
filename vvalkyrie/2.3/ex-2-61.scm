;; ex 2.61

(define (adjoin-of-set x set)
  (cond ((null? set) (cons x '()))
        ((< x (car set)) (cons x set))
        (else (cons (car set) (adjoin-of-set x (cdr set))))))

(adjoin-of-set 3 '(1 2 4 5))
;;=> (1 2 3 4 5)

(adjoin-of-set 0 '(1 2 4 5))
;;=> (0 1 2 4 5)

(adjoin-of-set 6 '(1 2 4 5))
;;=> (1 2 4 5 6)
