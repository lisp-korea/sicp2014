;;; Ex 1.3.
;;; Define a procedure that takes three numbers as arguments
;;; and returns the sum of the squares of the two larger numbers.

(define (square x)
  (* x x))

(define (abs x)
  (if (< x 0)
      (- x)
      x))

(define (max x y)
  (if (> x y)
      x
      y))

(define (min x y)
  (if (> x y)
      y
      x))

(define (max3 x y z)
  (max (max x y) z))

(define (min3 x y z)
  (min (min x y) z))

(define (be-in-order? x y z)
  (or (and (>= x y) (>= y z))
      (and (>= z y) (>= y x))))

(define (middle3 x y z)
  (if (be-in-order? x y z)
      y
      (middle3 y z x)))

(define (sum-of-squares x y z)
  (+ (square (max3 x y z))
     (square (middle3 x y z))))
