연습문제 1.17 

(define (* a b)
  (cond ((= b 0) 0)
   	((even? b) (* (double a) (halves b)))
	(else (+ a (* a (- b 1))))))

(define (even? n)
  (= (remainder n 2) 0))

(define (double x) (+ a a))

(define (halves x) (/ a 2))

