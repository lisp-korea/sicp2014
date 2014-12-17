;; ex 2.23 define for-each

(define (for-each f l)
  (f (car l))
  (if (null? (cdr l))
      #t
      (for-each f (cdr l))))

(for-each (lambda (x) (newline) (display x))
          (list 57 321 88))

;;=>
;;57
;;321
;;88#t
