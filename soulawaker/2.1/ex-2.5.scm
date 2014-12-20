(define (cons x y)
  (define (very-square x y)
    (cond ((= y 0) 1)
      (else (* x (very-square x (- y 1))))))
  (define (dispatch m)
    (cond ((= m 0) x)
    	  ((= m 1) y)
	  (else (* (very-square 2 x) (very-square 3 y)))))
  (cond ((< x 0) (display "error: x is not a positive integer"))
        ((< y 0) (display "error: y is not a positive integer"))
	(else (dispatch))))

(define (car z) (z 0))
(define (cdr z) (z 1))
