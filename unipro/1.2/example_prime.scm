(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
	((divides? test-divisor n) test-divisor)
	(else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (square x)
  (* x x))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (even? n)
  (= (remainder n 2) 0))

;;; recursive version
;; (define (expmod base exp m)
;;   (if (= exp 0)
;;       1
;;       (remainder (* base (expmod base (- exp 1) m)) m)))

;;; iterative version
;; (define (expmod base exp m)
;;   (define (expmod-iter mod cnt)
;;     (if (= cnt exp)
;;	mod
;;	(expmod-iter (remainder (* mod base) m) (+ cnt 1))))
;;   (expmod-iter 1 0))

;;; fast version
(define (expmod base exp m)
  (cond ((= exp 0) 1)
	((even? exp)
	 (remainder (square (expmod base (/ exp 2) m))
		    m))
	(else
	 (remainder (* base (expmod base (- exp 1) m))
		    m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) #t)
	((fermat-test n) (fast-prime? n (- times 1)))
	(else #f)))
