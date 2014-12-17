; ex 2.27
; change ex 2.18's reverse to deep-reverse that get a list as an argument.

; ex 2.18's reverse
(define (reverse a-list)
  (define (iter a-list r-list)
    (if (null? a-list)
      r-list
      (iter (cdr a-list) (cons (car a-list) r-list))))
  (iter a-list '()))


(define (deep-reverse a-list)
  (define (iter a-list r-list)
    (if (null? a-list)
      r-list
      (iter (cdr a-list)
            (cons (if (list? (car a-list))
                      (reverse (car a-list))
                      (car a-list))
                  r-list))))
  (iter a-list '()))


(define x (list (list 1 2) (list 3 4)))

x
;;=> ((1 2) (3 4))

(reverse x)
;;=> ((3 4) (1 2))

(deep-reverse x)
;;=> ((4 3) (2 1))
