;; ex 2.60

(define (element-of-set? x set)
  (cond ((null? set) #f)
        ((equal? x (car set)) #t)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-of-set x set) (cons x set))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        (else (cons (car set1)
                    (intersection-set (cdr set1) set2)))))

(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        (else (cons (car set1)
                    (union-set (cdr set1) set2)))))

(union-set '(1 2 3 4) '(3 4 5 6))
;;=> (1 2 3 4 3 4 5 6)

