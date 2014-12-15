;;; Exercise 2.1

;; retuns the rational number whose numerator is the integer n
;; and whose denominator is the integer d.
(define (make-rat n d)
  (if (> d 0)
      (let ((g (gcd (abs n) (abs d))))
	(cons (/ n g) (/ d g)))
      (make-rat (- n) (- d))))

;; retuns the numerator of the rational number x.
(define (numer x) (car x))

;; retuns the denominator of the rational number x.
(define (denom x) (cdr x))

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))
