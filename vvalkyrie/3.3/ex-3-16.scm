; ex 3.16
; Ben Bitdiddle version
(define (count-pairs x)
  (if (not (pair? x))
    0
    (+ (count-pairs (car x))
       (count-pairs (cdr x))
       1)))

; count for duplicate pairs makes wrong result.

(count-pairs (list 'a 'b 'c))
;;=> 3

(define x (cons 'a 'b))

(define y (cons x 'c))

(define z1 (cons x y))

(count-pairs z1)
;;=> 4

(define w (cons x x))

(define z2 (cons w w))

(count-pairs z2)
;;=> 7

; ex 3.13's list can make (count-pairs) to infinite loop

(define (last-pair x)
  (if (null? (cdr x))
    x
    (last-pair (cdr x))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define z3 (make-cycle (list 'a 'b 'c)))

(count-pairs z3)
;;=> (endless)
