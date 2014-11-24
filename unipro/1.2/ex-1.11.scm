;;; Exercise 1.11
(define (ex-1-11-recur n)
  (if (< n 3)
      n
      (+ (ex-1-11-recur (- n 1))
	 (* 2 (ex-1-11-recur (- n 2)))
	 (* 3 (ex-1-11-recur (- n 3))))))

;; a <- (+ a (* 2 b) (* 3 c)
;; b <- a
;; c <- b
(define (ex-1-11-iter n)
  (define (iter a b c count)
    (if (< count 3)
	a
	(iter (+ a (* 2 b) (* 3 c)) a b (- count 1))))
  (if (< n 3)
      n
      (iter 2 1 0 n)))
