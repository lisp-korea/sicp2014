#lang planet neil/sicp

(define (make-rat n d)
  (let ((g (gcd n d)))
    (cons (/ (numer-sign n d) g)
          (abs (/ d g)))))

(define (numer-sign n d)
  (if (< d 0) (- n) n))

(define (numer x)
  (car x))

(define (denom x)
  (cdr x))

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))

;; --
;; 결과

(print-rat (make-rat 2 4))
;; ==> 1/2
(print-rat (make-rat 2 -4))
;; ==> -1/2
(print-rat (make-rat -2 4))
;; ==> -1/2
(print-rat (make-rat -2 -4))
;; ==> 1/2

;; --
;; 다음과 같이 더 보기 쉽게 작성할 수 있다.

;; (define (make-rat n d)
;;   (let ((g (gcd n d)))
;;     (cons (/ (numer-sign n d) g)
;;           (/ (denom-sign n d) g))))

;; (define (denom-sign n d)
;;   (abs d))
