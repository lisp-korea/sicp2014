;; Alyssa P. Hacker's code.

(define (make-interval a b) (cons a b))

(define (lower-bound x) (car x))

(define (upper-bound x) (cdr x))

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (div-interval x y)
  (mul-interval x
                (make-interval (/ 1.0 (upper-bound y))
                               (/ 1.0 (lower-bound y)))))

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
                 (- (upper-bound x) (lower-bound y))))

;; Ben Bitdiddle's advice.

(define (print-error-divide-by-0 ret)
  (newline)
  (display "error: divide by 0!")
  ret)

(define (div-interval-1 x y)
  (let ((upper-y (upper-bound y))
        (lower-y (lower-bound y)))
    (if (or (= upper-y 0) (= lower-y 0))
        (print-error-divide-by-0
          (make-interval 0 0))
        (mul-interval x
                      (make-interval (/ 1.0 upper-y)
                                     (/ 1.0 lower-y))))))

(div-interval-1 (make-interval 3 5) (make-interval 0 4))
