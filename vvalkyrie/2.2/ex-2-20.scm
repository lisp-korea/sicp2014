;; ex 2.20. same-parity

(define (same-parity-iter x . y)
  (let ((parity (even? x)))
    (define (iter y-list p-list)
      (if (null? y-list)
          p-list
          (if (eqv? parity (even? (car y-list)))
              (iter (cdr y-list) (cons p-list (car y-list)))
              (iter (cdr y-list) p-list))))
    (iter y (list x))))

(define (same-parity x . y)
  (let ((parity (even? x)))
    (define (recur y-list)
      (if (null? y-list)
          '()
          (if (eqv? parity (even? (car y-list)))
              (cons (car y-list) (recur (cdr y-list)))
              (recur (cdr y-list)))))
    (cons x (recur y))))

(same-parity 1 2 3 4 5 6 7)
;; => (1 3 5 7)

(same-parity 2 3 4 5 6 7)
;; => (2 4 6)

(same-parity 1 2 4 6)
;; => (1)
