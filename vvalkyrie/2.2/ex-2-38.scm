; ex 2.38

(define (accumulate op init seq)
  (if (null? seq)
      init
      (op (car seq)
          (accumulate op init (cdr seq)))))

(define nil '())

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(define fold-right accumulate)

;;--

(fold-right / 1 (list 1 2 3))
;;=> 3/2

(fold-left / 1 (list 1 2 3))
;;=> 1/6

(fold-right list nil (list 1 2 3))
;;=> (1 (2 (3 ())))

(fold-left list nil (list 1 2 3))
;;=> (((() 1) 2) 3)

;;--

(fold-right + 1 (list 1 2 3))
;;=> 7

(fold-left + 1 (list 1 2 3))
;;=> 7

(fold-right * 1 (list 1 2 3))
;;=> 6

(fold-left * 1 (list 1 2 3))
;;=> 6

(fold-right - 1 (list 1 2 3))
;;=> 1

(fold-left - 1 (list 1 2 3))
;;=> -5
