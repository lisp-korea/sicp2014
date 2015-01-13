;;; Exercise 2.27

(define (deep-reverse x)
  (define (leaf? y) (not (pair? y)))

  (if (leaf? x)
      x
      (let ((rx (reverse x)))
	(cons (deep-reverse (car rx))
	      (deep-reverse (cdr rx))))))
