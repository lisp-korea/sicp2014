#lang planet neil/sicp

(define (square x) (* x x))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond
    ((> (square test-divisor) n) n)
    ((divides? test-divisor n) test-divisor)
    (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

;; --

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
    (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

;; --
;; make (search-for-primes)
;; find first 3 primes larger than 1,000, 10,000, 100,000, and 1,000,000
;; check time with (runtime)

(define (search-for-primes n)
  (find-prime-from n 3 (runtime)))

(define (print-time elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (print-and-go n cnt start-time)
  (display n)
  (newline)
  (if (= cnt 0)
    (print-time (- (runtime) start-time))
    (find-prime-from (+ n 1) cnt start-time)))

(define (find-prime-from n cnt start-time)
  (if (prime? n)
    (print-and-go n (- cnt 1) start-time)
    (find-prime-from (+ n 1) cnt start-time)))

;; --

(search-for-primes 1000)
;; 141

(search-for-primes 10000)
;; 178

(search-for-primes 100000)
;; 252

(search-for-primes 1000000)
;; 404
