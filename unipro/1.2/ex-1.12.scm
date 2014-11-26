;;; Exercise 1.12
;;; Pascal's triangle
(define (pascal-triangle-recur n)
  '(1))

(define (pascal-triangle-iter n)
  (define (row lst)
    (if (< (length lst) 2)
	'()
	(append (list (+ (car lst) (cadr lst)))
		(row (cdr lst)))))
  (define (column lst count)
    (if (>= count n)
	lst
	(column (row (cons 0 (append lst '(0))))
		(+ count 1))))
  (column '(1) 0))
