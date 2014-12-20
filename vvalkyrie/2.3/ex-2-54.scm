;; ex 2.54

(define (equal? a b)
  (cond
   ((or (null? a) (null? b)) (and (null? a) (null? b)))
   ((not (pair? a)) (eq? a b))
   (else (and (equal? (car a) (car b))
              (equal? (cdr a) (cdr b))))))


(equal? '(this is a list) '(this is a list))
;;=> #t

(equal? '(this is a list) '(this (is a) list))
;;=> #f

(equal? '(this (is a) list) '(this (is a) list))
;;=> #t

(equal? '(this is) '(this is a list))
;;=> #f

(equal? '(this is a list) '(this is))
;;=> #f
