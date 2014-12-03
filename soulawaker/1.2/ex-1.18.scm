연습문제 1.18

(define (* a b)
  (define (fast-prod a b n t)
    (cond ((= b n) t)
          ((= n 0) (fast-prod a b (+ n 1) a))
	  ((> b (double n)) (fast-prod a b (double n) (double t)))
	  (else (fast-prod a b (+ n 1) (+ t a)))))
  (fast-prod a b 0 0))

(define (double x) (+ x x))

