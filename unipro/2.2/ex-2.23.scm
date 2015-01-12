;;; Exercise 2.23

(define (for-each proc items)
  (if (not (null? items))
      ((lambda ()
	 (proc (car items))
	 (for-each proc (cdr items))))))
