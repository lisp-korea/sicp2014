#lang planet neil/sicp

;; f(n) = n                        (n < 3)
;;        f(n-1)+2f(n-2)+3f(n-3)   (n >= 3)
;;

;; recursive

(define (f-recur n)
	(cond
		((< n 3) n)
		(else (+ (* 1 (f-recur (- n 1)))
						 (* 2 (f-recur (- n 2)))
						 (* 3 (f-recur (- n 3)))))))

;; iterative

(define (f n)
	(cond
		((< n 3) n)
		(else (f-iter 2 1 0 n))))

(define (f-iter f1 f2 f3 cnt)
	(cond
		((< cnt 3) f1)
		(else  
			(f-iter (+ f1 (* 2 f2) (* 3 f3)) f1 f2 (- cnt 1)))))

