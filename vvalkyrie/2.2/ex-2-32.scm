; ex 2.32

(define (subsets s)
  (if (null? s) (list '()) ;; xxx
      (let ((rest (subsets (cdr s))))
        (append rest (map
                      (lambda (x) (cons (car s) x)) ;; <??>
                      rest)))))

(subsets '(1 2 3))
;;=> (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))

;; (list nil) 을 '() 로 바꾼 부분이 bug 였다.
;; (list '())이 정확한 표현이다.

;; s = (3) 일 때 rest = (()) -> (() (3))
;; s = (2 3) 일 때 rest = (() (3))
;;     -> consing 하면 ((2) ((2 3)))
;;     -> rest에 append 하면 (() (3) (2) (2 3))
;; s = (1 2 3) 일 때 rest = (() (3) (2) (2 3))
;;     -> consing 하면 ((1) (1 3) (1 2) (1 2 3))
;;     -> rest에 append 하면 최종 결과가 나옴
