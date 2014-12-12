;; ex 2.21. define square-list

(define (square x) (* x x))

(define (square-list items)
  (if (null? items)
    '() ;nil
    (cons (square (car items)) (square-list (cdr items)))))


(define (square-list-map items)
  (map (lambda (i) (square i)) items))

; test
(square-list (list 1 2 3 4))
;;=> (1 4 9 16)

(square-list-map (list 1 2 3 4))
;;=> (1 4 9 16)
