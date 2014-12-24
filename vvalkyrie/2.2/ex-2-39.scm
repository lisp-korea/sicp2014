; ex 2.39
; 159p

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

(define (reverse sequence)
  (fold-right (lambda (x y)
                (if (null? x) nil
                    (cons y x))) ;; <??> XXX
              nil sequence))
;;=> (((((() . 5) . 4) . 3) . 2) . 1)

(define (reverse sequence)
  (fold-left (lambda (x y)
               (cons y x)) ;; <??>
             nil sequence))
;;=> (5 4 3 2 1)

(reverse '(1 2 3 4 5))
