; ex 2.28 - define fringe procedure

(define (fringe l)
  (if (null? l)
      '() ; nil
      (if (list? (car l))
          (append (fringe (car l)) (fringe (cdr l)))
          (cons (car l) (fringe (cdr l))))))

(define x (list (list 1 2) (list 3 4)))

(fringe x)
;;=> (1 2 3 4)

(fringe (list x x))
;;=> (1 2 3 4 1 2 3 4)
