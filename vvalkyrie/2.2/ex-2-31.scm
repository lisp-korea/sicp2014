; ex 2.31
; abstract ex 2.31's square-tree and
; define high-order procedure tree-map

(define (square x) (* x x))

(define (tree-map f tree)
  (define (recur t)
    (cond ((null? t) '())
          ((not (pair? t)) (f t))
          (else (map recur t))))
  (recur tree))

(define (square-tree tree) (tree-map square tree))

(square-tree (list 1 (list 2 (list 3 4) 5 (list 6 7))))
;;=> (1 4 (9 16) 25) (36 49))
