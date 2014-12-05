;2.2 pratice :dryjins

(cons (cons 1 2)
      (cons 3 4))
(cons (cons 1
            (cons 2 3))
      4)

(define one-through-four (list 1 2 3 4))
(car one-through-four)
(cdr one-through-four)
(car (cdr one-through-four))
(cons 5 one-through-four)

;; cdr-ing the index of list starts from 1
(define (list-ref2 items n)
  (if (= n 1)
      (car items)
      (list-ref2 (cdr items)(- n 1))))
(define squares (list 1 4 9 16 25))
(list-ref2 squares 3)

;; the index of list starts from 0
(define (list-ref3 items n)
  (if (= n 0)
      (car items)
      (list-ref3 (cdr items)(- n 1))))
(define squares (list 1 4 9 16 25))
(list-ref3 squares 3)


;; length of a list
(define (length2 items)
  (if (null? items)
      0
      (+ 1 (length2 (cdr items)))))
(define odds `(1 3 5 7))
(length2 odds)
(append squares odds)
(append odds squares)

;; ex 2.17
(define (last-pair items)
  (if (= (length2 items) 1)
      (car items)
      (last-pair (cdr items))))

;; ex 2.18
