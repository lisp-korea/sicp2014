#lang planet neil/sicp

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

;; --

(define (x-point p)
  (car p))

(define (y-point p)
  (cdr p))

(define (make-point x y)
  (cons x y)) ;; (x y)

(define (start-segment l)
  (car l))

(define (end-segment l)
  (cdr l))

(define (midpoint-segment l)
  (cons
   (/ (+ (x-point (start-segment l)) (x-point (end-segment l))) 2)
   (/ (+ (y-point (start-segment l)) (y-point (end-segment l))) 2)
  ))

(define (make-segment start-point end-point)
  (cons start-point end-point)) ;; ((x1 y1) (x2 y2))
