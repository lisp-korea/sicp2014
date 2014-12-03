#연습문제 1.16
(define (fast-iter n b)
  (define (fast-iter-iter a b n tmp)
    (cond ((= n tmp) a)
          ((= a 1) (fast-iter-iter b b n 1))
	  ((> n (* tmp 2)) (fast-iter-iter (square a) b n (* tmp 2)))
	  (else (fast-iter-iter (* a b) b n (+ tmp 1)))))
  (fast-iter-iter 1 n b 0))


