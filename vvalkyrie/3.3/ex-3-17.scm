; ex 3.17

(define (last-pair x)
  (if (null? (cdr x))
    x
    (last-pair (cdr x))))

(define (append! x y)
  (set-cdr! (last-pair x) y))

(define (find-pairs x y)
  (if (null? x)
    #f
    (if (eq? (car x) y)
      (car x)
      (find-pairs (cdr x) y))))

(define (count-pairs x)
  (let ((p-list (list '())))
    (define (iter x)
      (if (not (pair? x))
        0
        (if (find-pairs (cdr p-list) x)
          0
          (begin
            (append! p-list (cons x '()))
            (+ (iter (car x))
               (iter (cdr x))
               1)))))
    (iter x)))

(count-pairs (list 'a 'b 'c))
;;=> 3

(define x (cons 'a 'b))

(define y (cons x 'c))

(define z1 (cons x y))

(count-pairs z1)
;;=> 3

(define w (cons x x))

(define z2 (cons w w))

(count-pairs z2)
;;=> 3

