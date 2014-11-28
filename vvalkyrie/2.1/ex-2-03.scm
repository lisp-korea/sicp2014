#lang planet neil/sicp

;; # 2.2 ----------------

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

(define (make-segment start-point end-point)
  (cons start-point end-point)) ;; ((x1 y1) (x2 y2))

;; # 2.3a ---------------

(define (square x) (* x x))

(define (segment-length l)
  ;; sqrt((x_2 - x_1)^2 + (y_2 - y_1)^2)
  (sqrt (+ (square (abs (- (x-point (start-segment l))
                           (x-point (end-segment l)))))
           (square (abs (- (y-point (start-segment l))
                           (y-point (end-segment l))))))))

(define (make-rectangle-side h-side v-side)
  (cons h-side v-side))

(define (make-rectangle top-left bottom-right)
  (let ((top-right (make-point (x-point bottom-right)
                               (y-point top-left)))
        (bottom-left (make-point (x-point top-left)
                                 (y-point bottom-right))))
    (cons (make-rectangle-side
            (make-segment top-left top-right)
            (make-segment top-left bottom-left))
          (make-rectangle-side
            (make-segment bottom-left bottom-right)
            (make-segment top-right bottom-right)))))

(define (top-segment r)
  (car (car r)))

(define (bottom-segment r)
  (car (cdr r)))

(define (right-segment r)
  (cdr (cdr r)))

(define (left-segment r)
  (cdr (car r)))

(define (perimeter-rectangle r)
  (+ (segment-length (top-segment r))
     (segment-length (bottom-segment r))
     (segment-length (right-segment r))
     (segment-length (left-segment r))))

(define (area-rectangle r)
  (* (segment-length (top-segment r))
     (segment-length (left-segment r))))

;; # 2.3b ---------------

(define (make-rectangle top-left bottom-right)
  (cons top-left bottom-right))

(define (top-segment r)
  (let ((top-left (car r))
        (top-right (make-point (x-point (cdr r))
                               (y-point (car r)))))
    (make-segment top-left top-right)))

(define (bottom-segment r)
  (let ((bottom-left (make-point (x-point (car r))
                                 (y-point (cdr r))))
        (bottom-right (cdr r)))
    (make-segment bottom-left bottom-right)))

(define (right-segment r)
  (let ((top-right (make-point (x-point (cdr r))
                               (y-point (car r))))
        (bottom-right (cdr r)))
    (make-segment top-right bottom-right)))

(define (left-segment r)
  (let ((top-left (car r))
        (bottom-left (make-point (x-point (car r))
                                 (y-point (cdr r)))))
    (make-segment top-left bottom-left)))
