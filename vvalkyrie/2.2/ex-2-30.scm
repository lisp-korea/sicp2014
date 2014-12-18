; ex 2.30
; define square-tree like ex 2.21's square-list

(define (square x) (* x x))

(define (square-tree t)
  (cond ((null? t) '())
        ((not (pair? t)) (square t))
        (else (cons (square-tree (car t))
                    (square-tree (cdr t))))))

(square-tree (list 1 (list 2 (list 3 4) 5) (list 6 7)))
;;=> (1 (4 (9 16) 25) (36 49))

; and, use map and recursive

(define (square-tree-map t)
  (cond ((null? t) '())
        ((not (pair? t)) (square t))
        (else (map square-tree-map t))))

(square-tree-map (list 1 (list 2 (list 3 4) 5) (list 6 7)))
;;=> (1 (4 (9 16) 25) (36 49))
