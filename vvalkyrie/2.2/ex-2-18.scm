;; ex 2.18. define reverse

(define (reverse a-list)
  (define (iter a-list r-list)
    (if (null? (cdr a-list))
        (cons (car a-list) r-list)
        (iter (cdr a-list) (cons (car a-list) r-list))))
  (iter a-list '()))

(reverse (list 1 4 9 16 25))
;; => (25 16 9 4 1)
