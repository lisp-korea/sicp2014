(define (make-interval a b) (cons a b))

(define (lower-bound x) (car x))

(define (upper-bound x) (cdr x))

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

;; ex 2.12
;; define procedures `make-center-percent' and `percent'.

(define (make-center-percent c p)
  (let ((w (* c (* p 0.01))))
    (make-interval (- c w) (+ c w))))

(make-center-percent 3 20)
;;=> (2.4 . 3.6)

(define (percent i)
  (let ((c (center i))
        (w (width i)))
    (* (/ w c) 100)))

(percent (make-interval 2.4 3.6))
;;=> 20.000000000000004
