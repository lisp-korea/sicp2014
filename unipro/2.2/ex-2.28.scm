;;; Exercise 2.28
(define nil '())

(define (fringe x)
  (define (leaf? y) (not (pair? y)))

  (cond ((null? x) nil)
	((leaf? x) (list x))
	(else (append (fringe (car x))
		      (fringe (cdr x))))))
