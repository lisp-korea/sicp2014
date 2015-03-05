;; -- prerequisities

(define the-empty-stream '())

(define (stream-null? s)
  (null? s))

(define-syntax cons-stream
  (syntax-rules ()
                ((cons-stream x y)
                 (cons x (delay y)))))

(define (stream-car stream) (car stream))

(define (stream-cdr stream) (force (cdr stream)))

(define (stream-ref s n)
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))))

(define (stream-map proc s)
  (if (stream-null? s)
    the-empty-stream
    (cons-stream (proc (stream-car s))
                 (stream-map proc (stream-cdr s)))))

(define (stream-for-each proc s)
  (if (stream-null? s)
    'done
    (begin (proc (stream-car s))
           (stream-for-each proc (stream-cdr s)))))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter pred
                                     (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

(define (display-line x)
  (newline)
  (display x))

(define (display-stream s)
  (stream-for-each display-line s))

(define (stream-enumerate-interval low high)
  (if (> low high)
    the-empty-stream
    (cons-stream
      low
      (stream-enumerate-interval (+ low 1) high))))

;; -- prerequisities end

; ex 3.52

(define sum 0)

(define (accum x)
  (set! sum (+ x sum))
  sum)

(define seq
  (stream-map accum
              (stream-enumerate-interval 1 20)))

seq
;;=> (1 . #<promise>)

(define y (stream-filter even? seq))

y
;;=> (6 . #<promise>)

(define z (stream-filter (lambda (x) (= (remainder x 5) 0)) seq))

z
;;=> (10 . #<promise>)

(stream-ref y 7)
;;=> 136

(display-stream y)
;;=> 6
;;=> 10
;;=> 28
;;=> 36
;;=> 66
;;=> 78
;;=> 120
;;=> 136
;;=> 190
;;=> 210done

(stream-ref z 7)
;;=> 210

(display-stream z)
;;=> 10
;;=> 15
;;=> 45
;;=> 55
;;=> 105
;;=> 120
;;=> 190
;;=> 210done

