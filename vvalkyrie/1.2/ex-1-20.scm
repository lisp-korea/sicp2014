#lang planet neil/sicp

;; how many calls in (remainder) in
;; normal-order evaluation and applicative-order evaluation

(define (gcd a b)
	(if (= b 0)
		a
		(gcd b (remainder a b))))

;; (gcd 206 40)
;; (gcd 40 (remainder 206 40))
;; (gcd 40 6)
;; (gcd 6 (remainder 40 6))
;; (gcd 6 4)
;; (gcd 4 (remainder 6 4))
;; (gcd 4 2)
;; (gcd 2 (remainder 4 2))
;; (gcd 2 0)
;; 2

;; 4 times in both.
