;;; Exercise 1.17

(define (fast-* a b)
  (cond ((= b 0) 0)
	((even? b) (double (fast-* a (halve b))))
	(else (+ a (fast-* a (- b 1))))))

(define (even? n)
  (= (remainder n 2) 0))

(define (double n)
  (+ n n))

;; (define (halve n)
;;   (define (find-half m)
;;     (if (= (+ m m) n)
;;	m
;;	(find-half (+ m 1))))
;;   (find-half 1))
(define (halve n)
  (/ n 2))
